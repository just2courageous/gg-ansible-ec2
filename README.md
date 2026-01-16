# gg-ansible-ec2 (P9) — Terraform (Infrastructure as Code) → EC2 (Elastic Compute Cloud) → Ansible (Automation tool) bootstrap

[![Architecture](docs/diagrams/gg-ansible-ec2-arch.png)](docs/diagrams/gg-ansible-ec2-arch.png)

Centralized **infrastructure automation**: provision **1× EC2 (Elastic Compute Cloud)** using **Terraform (Infrastructure as Code)**, auto generate **inventory (host list)**, then run **Ansible (Automation tool)** playbooks to validate access and bootstrap the server.

## ✅ What this demo shows
• **Terraform (Infrastructure as Code)** creating the EC2 (Elastic Compute Cloud) instance  
• **SSH (Secure Shell)** connectivity proof  
• **Ansible (Automation tool)** ping proof  
• **Ansible (Automation tool)** bootstrap proof  
• **Evidence-first** screenshots for each milestone

## 🎥 Demo (YouTube (video platform))
• Demo video: **Planned (coming soon)**

## 🧠 Architecture
• Diagram file: **[docs/diagrams/gg-ansible-ec2-arch.png](docs/diagrams/gg-ansible-ec2-arch.png)**

## 🧾 Evidence table (claim → proof)
| Claim | Proof (click) |
| --- | --- |
| Terraform (Infrastructure as Code) apply succeeded | [p9-apply-success.png](docs/screenshots/p9/p9-apply-success.png) |
| Terraform (Infrastructure as Code) outputs produced (IP, etc.) | [p9-terraform-outputs.png](docs/screenshots/p9/p9-terraform-outputs.png) |
| SSH (Secure Shell) access proof | [p9-ssh-proof.png](docs/screenshots/p9/p9-ssh-proof.png) |
| Inventory file generated or used by Ansible (Automation tool) | [p9-inventory-file.png](docs/screenshots/p9/p9-inventory-file.png) |
| Ansible (Automation tool) ping succeeded | [p9-ping-ok.png](docs/screenshots/p9/p9-ping-ok.png) |
| Bootstrap playbook succeeded | [p9-bootstrap-ok.png](docs/screenshots/p9/p9-bootstrap-ok.png) |

## 📦 Repo layout
• **[terraform/](terraform/)** → Terraform (Infrastructure as Code)  
• **[ansible/](ansible/)** → Ansible (Automation tool) config, inventory, playbooks  
• **[docs/screenshots/p9/](docs/screenshots/p9/)** → proof screenshots  
• **[docs/runbook.md](docs/runbook.md)** → run steps later (rebuild)  
• **[docs/evidence.md](docs/evidence.md)** → extra evidence notes

## 🧹 Cleanup
• `terraform destroy` in `terraform/` (Terraform (Infrastructure as Code))
