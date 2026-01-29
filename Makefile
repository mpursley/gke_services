CLUSTER_NAME := services
IMAGE_NAME := localhost/app-repo/python-app
TAG := 0.3.0

.PHONY: cluster build deploy-local destroy bootstrap stop start port-forward-app port-forward-argocd

cluster:
	kind create cluster --name $(CLUSTER_NAME) --config kind-config.yaml

build:
	podman build -t $(IMAGE_NAME):$(TAG) app/

deploy-local: build
	# Load image from podman to kind
	podman save $(IMAGE_NAME):$(TAG) -o image.tar
	kind load image-archive image.tar --name $(CLUSTER_NAME)
	rm image.tar
	# Install Chart
	helm upgrade --install python-app ./charts/python-app \
		--set image.repository=$(IMAGE_NAME) \
		--set image.tag=$(TAG) \
		--set image.pullPolicy=Never \
		--set ingress.enabled=true

bootstrap:
	./bootstrap/bootstrap_cluster.sh

destroy:
	kind delete cluster --name $(CLUSTER_NAME)

stop:
	docker stop $(CLUSTER_NAME)-control-plane

start:
	docker start $(CLUSTER_NAME)-control-plane

port-forward-app:
	kubectl port-forward svc/python-app 8080:80

port-forward-argocd:
	kubectl port-forward -n argocd svc/argocd-server 8081:443
