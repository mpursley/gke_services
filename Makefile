export KIND_EXPERIMENTAL_PROVIDER=podman

CLUSTER_NAME := services
IMAGE_NAME := localhost/app-repo/services-landing-page-app
TAG := 0.5.0

.PHONY: cluster build deploy-local destroy bootstrap stop start port-forward-app port-forward-argocd

cluster:
	kind create cluster --name $(CLUSTER_NAME) --config kind-config.yaml

build:
	podman build -t $(IMAGE_NAME):$(TAG) app/

deploy-local: build
	# Load image from podman to kind
	podman save $(IMAGE_NAME):$(TAG) -o image.tar
	KIND_EXPERIMENTAL_PROVIDER=podman kind load image-archive image.tar --name $(CLUSTER_NAME)
	rm image.tar
	# Install Chart
	helm upgrade --install services-landing-page-app ./charts/services-landing-page-app \
		--set image.repository=$(IMAGE_NAME) \
		--set image.tag=$(TAG) \
		--set image.pullPolicy=Never \
		--set ingress.enabled=true

bootstrap:
	./bootstrap/bootstrap_cluster.sh

destroy:
	kind delete cluster --name $(CLUSTER_NAME)

stop:
	podman stop $(CLUSTER_NAME)-control-plane
	podman machine stop

start:
	-podman machine start
	podman start $(CLUSTER_NAME)-control-plane
	@echo "Waiting for cluster to be ready..."
	@sleep 5
	./scripts/start_port_forwards.sh

port-forward-app:
	kubectl port-forward svc/services-landing-page-app 8080:80

port-forward-argocd:
	kubectl port-forward -n argocd svc/argocd-server 8081:443

port-forward-tines:
	kubectl port-forward -n tines svc/tines-app 3000:80
