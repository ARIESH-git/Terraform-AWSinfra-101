<div align="center">

<img src="screenshots/banner.svg" width="100%" alt="AWS DevOps Infrastructure Project banner"/>

### End-to-end AWS infrastructure automation — from `terraform apply` to a running container behind a load balancer

[![Terraform](https://img.shields.io/badge/Terraform-844FBA?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazonaws&logoColor=white)](https://aws.amazon.com/)
[![Ansible](https://img.shields.io/badge/Ansible-EE0000?style=for-the-badge&logo=ansible&logoColor=white)](https://www.ansible.com/)
[![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=jenkins&logoColor=white)](https://www.jenkins.io/)
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Amazon ECR](https://img.shields.io/badge/Amazon%20ECR-FF9900?style=for-the-badge&logo=amazonecs&logoColor=white)](https://aws.amazon.com/ecr/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu%2024.04-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)](https://ubuntu.com/)

</div>

---

## 📖 Overview

This repository holds the **Terraform infrastructure code** behind a complete AWS DevOps pipeline: it provisions a VPC with a bastion host, a Jenkins CI/CD server, and an application host — all behind an Application Load Balancer — then a Jenkins pipeline builds a Node.js app into a Docker image, pushes it to a private Amazon ECR repository, and deploys it to the app host automatically.

- **34 AWS resources**, provisioned entirely through Terraform, in a single `apply`.
- **Ansible** installs and starts Docker on both the Jenkins and application hosts from one playbook.
- **Jenkins**, reached only through the ALB at `/jenkins`, runs a 3-stage pipeline: checkout → build & push to ECR → deploy to the app host.
- **IAM instance roles** (not static credentials) authenticate EC2 to ECR.
- The application itself — a Dockerized Node.js movies app — lives in a companion repo, [`node-movies-app`](https://github.com/ARIESH-git/node-movies-app), and is pulled and deployed by the pipeline defined here.

---

## 🏗️ Architecture

```mermaid
flowchart TB
    Dev([👤 Developer]) -->|git push| GH[(GitHub<br/>node-movies-app)]
    Client([🌐 Client Request]) --> ALB{Application Load Balancer<br/>main-alb}

    ALB -->|/jenkins| Jenkins[Jenkins Host<br/>10.0.1.247<br/>private subnet]
    ALB -->|:3000 via target group| App[App Host<br/>10.0.2.77<br/>private subnet]

    Bastion[Bastion Host<br/>3.235.86.70<br/>public subnet] -.SSH proxy jump.-> Jenkins
    Bastion -.Ansible over SSH.-> Jenkins
    Bastion -.Ansible over SSH.-> App

    GH -->|Jenkins pipeline pull| Jenkins
    Jenkins -->|1 . docker build + push| ECR[(Amazon ECR<br/>project101/namespace)]
    Jenkins -->|2 . SSH deploy| App
    App -->|docker pull| ECR

    IAM[IAM Role<br/>ecr-access-role] -.attached to.-> Jenkins
    IAM -.attached to.-> App

    S3[(S3 Remote State<br/>terraform-101-bucket-backend)] -.terraform state.-> VPC[VPC 10.0.0.0/16<br/>2 public + 2 private subnets<br/>NAT Gateway]
```

**How a deploy happens, end to end:**
1. Code is pushed to the private `node-movies-app` GitHub repo.
2. The Jenkins pipeline (defined by the `Jenkinsfile` in that repo) checks out the code.
3. Jenkins authenticates to ECR using its **IAM instance role** (`ecr-access-role`) — no long-lived AWS keys stored anywhere.
4. Jenkins builds the Docker image and pushes it to the private ECR repository, tagged with the build number.
5. Jenkins SSHes into the App Host (using a dedicated `app-ssh-key` credential) and pulls + runs the new image.
6. Traffic reaches the app through the ALB's target group on port 3000.

---

## ✨ Key Features

| Capability | How it's achieved |
|---|---|
| 🧱 Infrastructure as Code | Single Terraform root module with dedicated child modules: `vpc`, `security_group`, `instances`, `alb` |
| 🔒 Safe remote state | S3 backend (`terraform-101-bucket-backend`, `us-east-1`) |
| 🚪 Bastion-only SSH access | Jenkins and App hosts sit in **private subnets**; reachable only via SSH proxy jump through the bastion |
| ⚙️ Configuration management | One Ansible playbook installs Docker on both `jenkins` and `app` inventory groups |
| 🌐 ALB path routing | Jenkins served at `/jenkins` (`--prefix=/jenkins`); app traffic routed via a separate target group |
| 🔑 Keyless AWS auth on EC2 | `ecr-access-role` IAM instance role — verified live with `aws sts get-caller-identity` |
| 🚀 Full CI/CD | 3-stage Jenkins pipeline: Checkout → Build & Push to ECR → Deploy to App Host |
| 💰 Documented cost | Full AWS Pricing Calculator breakdown, ~$88.32/month |

---

## 🧰 Tech Stack

| Tool | Version Used | Purpose |
|---|---|---|
| ![Terraform](https://img.shields.io/badge/-Terraform-844FBA?logo=terraform&logoColor=white) | v1.14.6 | Provisioning all 34 AWS resources |
| ![AWS](https://img.shields.io/badge/-AWS%20CLI-232F3E?logo=amazonaws&logoColor=white) | v2.33.30 | AWS authentication & scripting |
| ![Ansible](https://img.shields.io/badge/-Ansible-EE0000?logo=ansible&logoColor=white) | core 2.16.3 | Docker installation on Jenkins + App hosts |
| ![Jenkins](https://img.shields.io/badge/-Jenkins-D24939?logo=jenkins&logoColor=white) | 2.541.2 | CI/CD pipeline (build, push, deploy) |
| ![Docker](https://img.shields.io/badge/-Docker-2496ED?logo=docker&logoColor=white) | docker.io (apt) | Containerizing the Node.js app |
| ![Amazon ECR](https://img.shields.io/badge/-Amazon%20ECR-FF9900?logo=amazonecs&logoColor=white) | — | Private container registry |
| Java (OpenJDK) | 17.0.18 | Jenkins runtime |
| ![Ubuntu](https://img.shields.io/badge/-Ubuntu%2024.04-E95420?logo=ubuntu&logoColor=white) | LTS | OS for all EC2 instances |

---

## 📁 Repository Structure

```
Terraform-AWSinfra-101/
├── main.tf                     # Provider config, S3 backend, module calls
├── variables.tf                 # Region, AMIs, CIDR blocks, instance types
├── outputs.tf                    # 20+ outputs: IDs, IPs, ARNs, target groups
├── terraform.tfvars
├── .terraform.lock.hcl
│
└── modules/
    ├── vpc/                      # VPC (10.0.0.0/16), 2 public + 2 private subnets,
    │                             # Internet Gateway, NAT Gateway, route tables, VPC flow logs
    ├── security_group/           # SGs for bastion, Jenkins, app, ALB, and public web
    ├── instances/                # Bastion, Jenkins, and App EC2 instances
    └── alb/                      # Application Load Balancer, listeners, target groups
                                  # (jenkins-tg on /jenkins, main-tg on port 3000)
```

> The **application code** (Dockerfile, Jenkinsfile, Node.js movies app) lives in the companion repository [`ARIESH-git/node-movies-app`](https://github.com/ARIESH-git/node-movies-app) — this repo is infrastructure only. SSH keys (`c60.pem`, `jenkins_key`) and Terraform state are never committed; state lives remotely in S3 and keys are generated/exchanged at runtime.

---

## 🚀 Getting Started

### Prerequisites

- An AWS account with programmatic access (`aws configure`)
- [Terraform](https://developer.hashicorp.com/terraform/install) ≥ 1.14
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html) core ≥ 2.16 (installed on the bastion, not your local machine)
- An S3 bucket for remote state, created once before the first `init` (this project uses `terraform-101-bucket-backend` in `us-east-1`)
- An SSH key pair for bastion access

### 1. Clone the repository

```bash
git clone https://github.com/ARIESH-git/Terraform-AWSinfra-101.git
cd Terraform-AWSinfra-101
```

### 2. Provision the infrastructure

```bash
terraform init
terraform plan
terraform apply
```

This creates 34 resources: the VPC, both public and private subnets, the NAT Gateway, all security groups, the ALB with its two target groups, and the bastion, Jenkins, and app EC2 instances. Note the outputs — you'll need the bastion's public IP and the private IPs of the Jenkins and app hosts for the next steps.

### 3. Configure Jenkins + App hosts with Ansible

SSH into the **bastion** using its public IP, install Ansible, then run the playbook that installs and starts Docker on both the Jenkins and app hosts:

```bash
ssh -i c60.pem ubuntu@<bastion-public-ip>
sudo apt update && sudo apt install ansible -y

# inventory.yml already defines the jenkins and app host groups
ansible all -i inventory.yml -m ping        # connectivity check
ansible-playbook -i inventory.yml playbook.yml   # installs + starts Docker
```

### 4. Install Jenkins on the Jenkins host

From the bastion, proxy-jump into the Jenkins host (its private IP), then install Java + Jenkins and configure it to serve under `/jenkins` (required because it sits behind the ALB):

```bash
ssh -A -J ubuntu@<bastion-public-ip> ubuntu@<jenkins-private-ip>
java -version   # confirm OpenJDK is present

# Edit /etc/default/jenkins:
#   PREFIX=/jenkins
#   JENKINS_ARGS="--webroot=/var/cache/$NAME/war --httpPort=$HTTP_PORT --prefix=/jenkins"

sudo systemctl daemon-reload
sudo systemctl restart jenkins
sudo systemctl status jenkins
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### 5. Finish Jenkins setup via the ALB

Open `http://<alb-dns-name>/jenkins` in a browser, paste in the initial admin password, and create your first admin user.

### 6. Create the IAM role and ECR repository

- IAM role `ecr-access-role`, trusted entity **EC2**, attached to both the Jenkins host and the App host.
- Private ECR repository, e.g. `project101/namespace`, in `us-east-1`.

Verify the role is active from the Jenkins instance:

```bash
aws sts get-caller-identity
# should show: "Arn": ".../assumed-role/ecr-access-role/..."
```

### 7. Set up SSH access from Jenkins to the App host

```bash
ssh-keygen -f ~/.ssh/jenkins_key
ssh-copy-id -i ~/.ssh/jenkins_key.pub ubuntu@<app-host-private-ip>
```
Add this key to Jenkins as an SSH credential (e.g. `app-ssh-key`) for the deploy stage.

### 8. Configure the Jenkins pipeline

In Jenkins, create a **Pipeline** job pointing at the [`node-movies-app`](https://github.com/ARIESH-git/node-movies-app) repo (`*/main`, script path `Jenkinsfile`). That Jenkinsfile:

1. **Checkout** — pulls the app repo using `github-credentials`.
2. **Build and Push to ECR** — `docker build` + `docker push`, tagged `$BUILD_NUMBER`, authenticated via `aws ecr get-login-password`.
3. **Deploy to App Host** — SSHes in with `app-ssh-key`, stops the old container, pulls the new image, and runs it on port 3000.

### 9. Run the build and verify

```bash
# On the App host, after a successful build:
docker ps
# should show the 'movies-app' container Up, 0.0.0.0:3000->3000/tcp
```

---

## 📸 Screenshots — Proof of Work

<table>
<tr>
<td width="50%">

**Environment confirmed on both EC2 instances**
<br/>AWS CLI v2.33.30 and Terraform v1.14.6 verified — consistent tooling across the bastion/build instance.

<img src="screenshots/01-env-setup-cli-versions.png" width="100%"/>

</td>
<td width="50%">

**S3 remote state backend**
<br/>Bucket `terraform-101-bucket-backend` created in `us-east-1` to hold Terraform state.

<img src="screenshots/02-s3-backend-bucket.png" width="100%"/>

</td>
</tr>
<tr>
<td width="50%">

**Terraform initialized**
<br/>Backend + all four modules (`vpc`, `alb`, `instances`, `security_group`) initialize cleanly.

<img src="screenshots/03-terraform-init.png" width="100%"/>

</td>
<td width="50%">

**Infrastructure provisioned — 34 resources**
<br/>`terraform apply` completes: VPC, subnets, NAT Gateway, ALB, and all three EC2 instances live, with every output populated.

<img src="screenshots/04-terraform-apply-34-resources.png" width="100%"/>

</td>
</tr>
<tr>
<td width="50%">

**Ansible connectivity confirmed**
<br/>`ansible all -i inventory.yml -m ping` — both `jenkins-node` and `app-node` respond.

<img src="screenshots/05-ansible-ping-success.png" width="100%"/>

</td>
<td width="50%">

**Docker installed via Ansible**
<br/>Single playbook run — `ok=4 changed=2`, zero failures, on both hosts.

<img src="screenshots/06-ansible-playbook-docker-install.png" width="100%"/>

</td>
</tr>
<tr>
<td width="50%">

**Jenkins running, configured for the ALB**
<br/>`systemctl status jenkins` — active, with `--prefix=/jenkins` visible in the process arguments.

<img src="screenshots/07-jenkins-service-active.png" width="100%"/>

</td>
<td width="50%">

**Jenkins reachable through the load balancer**
<br/>Dashboard loads at `main-alb-2146852738.us-east-1.elb.amazonaws.com/jenkins` — no direct port exposure needed.

<img src="screenshots/08-jenkins-dashboard-alb.png" width="100%"/>

</td>
</tr>
<tr>
<td width="50%">

**IAM role for keyless ECR access**
<br/>`ecr-access-role` created with EC2 as the trusted entity, ready to attach to both hosts.

<img src="screenshots/09-iam-ecr-access-role.png" width="100%"/>

</td>
<td width="50%">

**Private ECR repository created**
<br/>`project101/namespace` — the destination for every image the pipeline builds.

<img src="screenshots/10-ecr-repository-created.png" width="100%"/>

</td>
</tr>
<tr>
<td width="50%">

**Full 3-stage Jenkinsfile**
<br/>Checkout → Build & Push to ECR → Deploy to App Host, with the SSH credential binding visible for the deploy stage.

<img src="screenshots/11-jenkinsfile-deploy-stage.png" width="100%"/>

</td>
<td width="50%">

**Pipeline build #7 — SUCCESS**
<br/>Started by `PROJECT-USER`, finished in 13 seconds, no errors.

<img src="screenshots/12-jenkins-build-success.png" width="100%"/>

</td>
</tr>
<tr>
<td width="50%">

**Container live on the App host**
<br/>`docker ps` shows `movies-app` up, port `3000->3000/tcp` — the pipeline's deploy stage worked end to end.

<img src="screenshots/13-docker-container-running.png" width="100%"/>

</td>
<td width="50%">

**ECR image history**
<br/>Multiple tags (`7, 4, 5, 3, 6...`) — one per successful Jenkins build — confirming repeated, reliable deploys.

<img src="screenshots/14-ecr-image-tags.png" width="100%"/>

</td>
</tr>
<tr>
<td width="50%">

**AWS Pricing Calculator estimate**
<br/>~$88.32/month, ~$1,059.84/year — full line-item breakdown below.

<img src="screenshots/15-aws-cost-estimate.png" width="100%"/>

</td>
<td width="50%">

**Terraform state safely in S3**
<br/>`terraform.tfstate` (56.1 KB) stored remotely — no local state file, no merge conflicts.

<img src="screenshots/16-terraform-state-s3.png" width="100%"/>

</td>
</tr>
</table>

---

## 💰 Infrastructure Cost Estimate

Estimate generated via the AWS Pricing Calculator, `us-east-1`:

| Service | Monthly Cost |
|---|---|
| Amazon EC2 (3 instances) | $0.17 |
| Elastic Load Balancer | $22.27 |
| Amazon ECR | $0.10 |
| NAT Gateway | $65.78 |
| **Total (monthly)** | **~$88.32** |
| **Total (12 months)** | **~$1,059.84** |

> 💡 As with most single-NAT-Gateway architectures, the NAT Gateway is by far the dominant cost (≈ 74% of the monthly bill). For a lower-cost dev/test setup, consider a NAT instance instead of a managed NAT Gateway.

---

## ✅ Project Status

| Task | Status |
|---|---|
| Terraform infrastructure — VPC, ALB, bastion/Jenkins/app EC2, NAT GW, security groups (34 resources) | ✔ Done |
| S3 remote state backend | ✔ Done |
| Ansible — Docker installed on Jenkins + App hosts | ✔ Done |
| Jenkins installed, configured behind ALB at `/jenkins` | ✔ Done |
| IAM role + private ECR repository | ✔ Done |
| SSH key exchange for Jenkins → App host deploys | ✔ Done |
| Node.js app Dockerized and pushed to private GitHub repo | ✔ Done |
| Jenkinsfile — checkout + build & push to ECR | ✔ Done |
| Jenkinsfile — deploy to App host | ✔ Done |
| Bonus — AWS Pricing Calculator cost estimate | ✔ Done |

---

## 👤 Author

**Ariesh** — [GitHub: @ARIESH-git](https://github.com/ARIESH-git)

Related repository: [`node-movies-app`](https://github.com/ARIESH-git/node-movies-app) — the Dockerized Node.js application deployed by this pipeline.

---

<div align="center">

*Built as a hands-on project in AWS infrastructure automation, CI/CD, and container deployment.*

</div>
