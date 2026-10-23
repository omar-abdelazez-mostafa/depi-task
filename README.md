# DevOps Flask Application

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

The configuration uses an existing VPC and public subnet and references an
existing EC2 key pair. Copy `infra/terraform.tfvars.example` to
`infra/terraform.tfvars`, replace every placeholder, and set
`allowed_ssh_cidrs` to the operator's public IP as `/32`. Do not commit the
copied file.

```powershell
terraform -chdir=infra fmt -recursive
terraform -chdir=infra init
terraform -chdir=infra validate
terraform -chdir=infra plan
```

Review the plan and obtain authorization before `terraform apply`; no backend
or AWS resources are created automatically.

## Ansible

Copy `ansible/inventory.ini.example` to `ansible/inventory.ini`, replace the
Terraform public IP and private-key path, then run:

```powershell
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
```

The playbook installs Docker and the Compose plugin and creates
`/opt/flask-app`. Run it a second time to verify idempotency on a reachable
Ubuntu host.

## CI and SonarQube

The workflow runs on pull requests and pushes to `main`, installs dependencies,
runs pytest with coverage, and invokes SonarQube. Add the repository secret
`SONAR_TOKEN` and repository variable `SONAR_HOST_URL` in GitHub settings.
The scanner configuration is in `sonar-project.properties`.

## Layout

- `app/`, `tests/`: Flask service and tests
- `Dockerfile`, `compose.yaml`: container image and local orchestration
- `infra/`: reusable EC2 module and development environment
- `ansible/`: host bootstrap playbook and roles
- `.github/workflows/ci.yml`: test and quality gates
