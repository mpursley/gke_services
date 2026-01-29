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
*   Point the ArgoCD Application manifest in `argocd/applications/python-app.yaml` to your fork/repository.

---

## 🧪 Quality Control
The CI pipeline automatically runs:
*   **Linting:** `black --check app/`
*   **Static Analysis:** `pylint app/main.py`
*   **Unit Tests:** `pytest app/`
