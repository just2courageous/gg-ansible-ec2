# P9 — EC2 + Ansible (Terraform → Bootstrap)

**Goal:** Provision 1× **t3.micro** (**Amazon Linux 2023**) in **us-east-2** via **Terraform** (default VPC, **SG: SSH 22 + ICMP**, **SSM role**). Auto-generate **SSH key** and **Ansible inventory**; then run:
- `ansible all -m ping`
- `ansible-playbook playbooks/01-bootstrap.yml`

## Repo Layout
gg-ansible-ec2/
terraform/{providers.tf,variables.tf,main.tf,outputs.tf,terraform.tfvars}
ansible/{ansible.cfg,inventory.ini,playbooks/00-ping.yml,playbooks/01-bootstrap.yml}
docs/screenshots/p9/


## Terraform (Windows Git Bash)
```bash
cd terraform
terraform init && terraform apply
terraform output

Ansible (AWS CloudShell used)
# upload p9-key.pem, set IP from terraform output
ansible all -m ping -i inventory.ini
ansible-playbook playbooks/01-bootstrap.yml -i inventory.ini

Screenshots (docs/screenshots/p9/)

p9-apply-success.png

p9-terraform-outputs.png

p9-inventory-file.png

p9-ping-ok.png

p9-bootstrap-ok.png

p9-ssh-proof.png

Cleanup
cd terraform && terraform destroy


Notes: .gitignore excludes Terraform state and ansible/*.pem. AWS profile: gg, Region: us-east-2, Account: 399717050894.
