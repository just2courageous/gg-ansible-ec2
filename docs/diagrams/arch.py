from diagrams import Diagram, Cluster, Edge

from diagrams.onprem.client import User
from diagrams.onprem.iac import Terraform
from diagrams.onprem.compute import Server

from diagrams.aws.network import VPC, PublicSubnet, PrivateSubnet, InternetGateway, NATGateway
from diagrams.aws.compute import EC2

from diagrams.generic.storage import Storage
from diagrams.generic.network import Firewall


graph_attr = {
    "pad": "1.0",
    "splines": "ortho",
    "nodesep": "1.1",
    "ranksep": "1.35",
    "fontsize": "12",
    "dpi": "300",
    "bgcolor": "white",  # ✅ regular background
}

with Diagram(
    "Green-Guard: Terraform → EC2 + Ansible bootstrap",
    show=False,
    filename="docs/diagrams/gg-ansible-ec2-arch",
    outformat="png",
    direction="LR",
    graph_attr=graph_attr,
):
    # ✅ Local (your laptop)
    you = User("You\n(local)")
    tf = Terraform("Terraform\nIaC")
    ans = Server("Ansible\n(control node)")

    # ✅ Terraform local artifacts
    key_pem = Storage("p9-key.pem\n(local_sensitive_file)")
    inv_ini = Storage("inventory.ini\n(local_file)")

    # ✅ AWS
    with Cluster("AWS"):
        with Cluster("Default VPC"):
            vpc = VPC("Default VPC")
            pub = PublicSubnet("Public subnet(s)")
            priv = PrivateSubnet("Private subnet(s)")
            igw = InternetGateway("Internet Gateway")
            nat = NATGateway("NAT Gateway\n(optional)")

            vpc >> [pub, priv]
            pub >> Edge(label="egress", style="dashed") >> igw
            priv >> Edge(label="optional", style="dashed") >> nat

        # ✅ Your Diagrams package doesn't have a SecurityGroup icon,
        # so we use a generic firewall icon but label it correctly.
        sg = Firewall("Security Group\nSSH :22")

        ec2 = EC2("EC2\n(t3.micro)\nAmazon Linux 2023")

    # ✅ Flows
    you >> Edge(label="terraform init / plan / apply") >> tf

    tf >> Edge(label="reads default VPC/subnets") >> vpc
    tf >> Edge(label="creates") >> sg
    sg >> Edge(label="attached") >> ec2
    tf >> Edge(label="creates") >> ec2

    tf >> Edge(label="writes key") >> key_pem
    tf >> Edge(label="writes inventory") >> inv_ini

    key_pem >> Edge(label="used by SSH") >> ans
    inv_ini >> Edge(label="hosts") >> ans

    ans >> Edge(label="SSH (ec2-user)\nansible ping + bootstrap") >> ec2
