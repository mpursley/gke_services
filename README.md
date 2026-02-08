# Modern GKE CI/CD Pipeline with IaC

This project implements a complete, modern CI/CD pipeline for deploying Python applications to Google Kubernetes Engine (GKE) using Infrastructure as Code (Terraform), GitOps (ArgoCD), and automated PR workflows (Atlantis).

## 🚀 Architecture & Tech Stack

### Core Platform & Infrastructure
*   **Source Control:** GitHub
*   **Infrastructure as Code (IaC):** Terraform
*   **IaC Automation:** Atlantis (Pull Request automation)
*   **Runtime:** Google Kubernetes Engine (GKE)
*   **Container Registry:** Google Artifact Registry (GAR)

### Application Stack
*   **Framework:** FastAPI (Python 3.11)
*   **Code Quality:** Black (Formatting), Pylint (Linting)
*   **Testing:** Pytest

### CI/CD & Orchestration
*   **CI (Build/Test):** GitHub Actions
*   **Packaging:** Helm Charts
*   **CD (GitOps):** ArgoCD
<img width="2233" height="1719" alt="Screenshot From 2026-01-28 23-00-35" src="https://github.com/user-attachments/assets/2c2ffd96-1d96-4169-b44c-4464a90448e5" />

### Cluster Services ("The Plumbing")
*   **Ingress:** NGINX Ingress Controller
*   **Certs:** cert-manager
*   **Secrets:** External Secrets Operator
*   **Observability:** Prometheus & Grafana

---

## 📂 Project Structure

```text
├── .github/workflows/      # GitHub Actions CI pipeline
├── app/                    # Python FastAPI application code
├── argocd/                 # GitOps Application manifests
├── bootstrap/              # Cluster initialization scripts
├── charts/                 # Helm charts for application deployment
├── infra/terraform/        # IaC modules (VPC, GKE, GAR)
├── Makefile                # Local development automation
├── kind-config.yaml        # Local Kubernetes (Kind) configuration
└── atlantis.yaml           # Atlantis PR automation config
```

---

## 🛠 Local Development

### Prerequisites
*   [Podman](https://podman.io/) (or Docker)
*   [Kind](https://kind.sigs.k8s.io/)
*   [Helm](https://helm.sh/)
*   [kubectl](https://kubernetes.io/docs/tasks/tools/)

### Quick Start
1.  **Create local cluster:**
    ```bash
    make cluster
    ```
2.  **Bootstrap cluster services (ArgoCD, Ingress, etc.):**
    ```bash
    make bootstrap
    ```
3.  **Build and deploy the app locally:**
    ```bash
    make deploy-local
    ```

---

## ☁️ Cloud Deployment

### 1. Infrastructure
Initialize and apply the Terraform configuration:
```bash
cd infra/terraform
terraform init
terraform apply -var="project_id=YOUR_PROJECT_ID"
```

### 2. CI/CD Setup
*   Update `.github/workflows/ci.yaml` with your GCP Workload Identity Provider and Service Account details.
*   Point the ArgoCD Application manifest in `argocd/applications/services-landing-page-app.yaml` to your fork/repository.

---

## 🧪 Quality Control
The CI pipeline automatically runs:
*   **Linting:** `black --check app/`
*   **Static Analysis:** `pylint app/main.py`
*   **Unit Tests:** `pytest app/`

---

## 🦾 Tines (Self-Hosted)

This project includes a Helm chart to deploy a self-hosted instance of the [Tines](https://www.tines.com/) automation platform.

**Prerequisites:**
You must have a Tines account and have received your **API Key** and **Tenant Name** from Tines support to access their private container registry.

### Deployment Steps

1.  **Create the Image Pull Secret:**
    You need to create a Kubernetes secret so the cluster can pull images from `registry.tines.com`.
    Replace `<API_KEY>` and `<TENANT_NAME>` with your credentials:

    ```bash
    kubectl create namespace tines
    kubectl create secret docker-registry tines-registry-secret \
      --docker-server=registry.tines.com \
      --docker-username=<TENANT_NAME> \
      --docker-password=<API_KEY> \
      -n tines
    ```

2.  **Ensure ArgoCD Deploys Tines:**
    The ArgoCD application manifest is located at `argocd-apps/tines.yaml`. It will automatically sync the `charts/tines` directory.

3.  **Access Tines:**
    Once deployed, you can port-forward to access the Tines interface:

    ```bash
    kubectl port-forward -n tines svc/tines-app 3000:3000
    ```
    Then visit `http://localhost:3000`.
