# DevOps Flask Application

[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=omar-abdelazez-mostafa_depi-task&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=omar-abdelazez-mostafa_depi-task)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=omar-abdelazez-mostafa_depi-task&metric=coverage)](https://sonarcloud.io/summary/new_code?id=omar-abdelazez-mostafa_depi-task)

Small Flask service with Docker, Terraform, Ansible, and GitHub Actions support.

## Application

```powershell
python -m pip install -r requirements-dev.txt
python -m pytest -v
python -m app.main
```

`GET /` returns `{"message": "DevOps Flask application"}` and `GET /health`
returns `{"status": "healthy"}`.

## Docker

```powershell
docker compose config
docker compose build
docker compose up -d
docker compose ps
curl http://localhost:8000/health
docker compose down
```

The image runs Gunicorn as the unprivileged `appuser` account.

## Terraform

The configuration can use an existing VPC and public subnet or automatically create a dedicated network. It references an existing EC2 key pair and automatically retrieves a current Ubuntu Jammy (22.04 LTS) AMI via dynamic data source (or accepts an explicit `ami_id`).

Copy `infra/terraform.tfvars.example` to `infra/terraform.tfvars`, replace placeholders, and set `allowed_ssh_cidrs` and `allowed_app_cidrs` to the operator's public IP as `/32`. Do not commit the copied file.

```powershell
terraform -chdir=infra fmt -recursive
terraform -chdir=infra init
terraform -chdir=infra validate
terraform -chdir=infra plan
```

Review the plan and obtain authorization before `terraform apply`; no backend or AWS resources are created automatically.

## Ansible

Generate the inventory from Terraform state or copy `ansible/inventory.ini.example` to `ansible/inventory.ini`:

```powershell
# Automated generation from Terraform state:
python ansible/generate_inventory.py --key-path ~/.ssh/your-key.pem

# Run playbook:
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
```

The playbook installs Docker and the Compose plugin, creates `/opt/flask-app`, copies the application, and starts it with Docker Compose. Run it a second time to verify idempotency on a reachable Ubuntu host.

## CI and SonarQube

The workflow runs on pull requests and pushes to `main`, installs dependencies, runs pytest with coverage, and invokes SonarQube. Add the repository secret `SONAR_TOKEN` and repository variable `SONAR_HOST_URL` in GitHub settings. The scanner configuration is in `sonar-project.properties`.

## Kubernetes Lab

- `lap/deployment.yaml`: Sample Kubernetes Deployment manifest configuring 5 replicas with a rolling update strategy in namespace `dev`.

## Layout

- `app/`, `tests/`: Flask service and tests
- `Dockerfile`, `compose.yaml`: container image and local orchestration
- `infra/`: reusable EC2 module and development environment
- `ansible/`: host bootstrap playbook, roles, and inventory generator
- `lap/`: Kubernetes lab deployment manifests
- `.github/workflows/ci.yml`: test and quality gates
