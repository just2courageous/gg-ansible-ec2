# gg-ansible-ec2 (P9) — Terraform → EC2 → Ansible bootstrap

[![Architecture](docs/diagrams/gg-ansible-ec2-arch.png)](docs/diagrams/gg-ansible-ec2-arch.png)

Centralized **infrastructure automation**: provision **1× EC2** using **Terraform**, auto generate **inventory (host list)**, then run **Ansible** playbooks to validate access and bootstrap the server.

## ✅ What this demo shows
• **Terraform** creating the EC2 instance  
• **SSH** connectivity proof  
• **Ansible** ping proof  
• **Ansible** bootstrap proof  
• **Evidence-first** screenshots for each milestone

## 🎥 Demo (YouTube (video platform))
• Demo video: **Planned (coming soon)**

## 🧠 Architecture
• Diagram file: **[docs/diagrams/gg-ansible-ec2-arch.png](docs/diagrams/gg-ansible-ec2-arch.png)**

## 🧾 Evidence table (claim → proof)
| Claim | Proof (click) |
| --- | --- |
| Terraform apply succeeded | [p9-apply-success.png](docs/screenshots/p9/p9-apply-success.png) |
| Terraform outputs produced (IP, etc.) | [p9-terraform-outputs.png](docs/screenshots/p9/p9-terraform-outputs.png) |
| SSH access proof | [p9-ssh-proof.png](docs/screenshots/p9/p9-ssh-proof.png) |
| Inventory file generated or used by Ansible (Automation tool) | [p9-inventory-file.png](docs/screenshots/p9/p9-inventory-file.png) |
| Ansible ping succeeded | [p9-ping-ok.png](docs/screenshots/p9/p9-ping-ok.png) |
| Bootstrap playbook succeeded | [p9-bootstrap-ok.png](docs/screenshots/p9/p9-bootstrap-ok.png) |

## 📦 Repo layout
• **[terraform/](terraform/)** → Terraform  
• **[ansible/](ansible/)** → Ansible config, inventory, playbooks  
• **[docs/screenshots/p9/](docs/screenshots/p9/)** → proof screenshots  
• **[docs/runbook.md](docs/runbook.md)** → run steps later (rebuild)  
• **[docs/evidence.md](docs/evidence.md)** → extra evidence notes

## 🧹 Cleanup
• `terraform destroy` in `terraform/` (Terraform)

Last updated: 2026-01-16
