# Extremely simple HTTP server that responds on port 8000 with a hello message.

DOCKERHUB_ID:=ibmosquito
SERVICE_NAME:="web-hello-cpp"
SERVICE_VERSION:="1.0.0"
 
default: build run

build:
	docker build -t $(DOCKERHUB_ID)/$(SERVICE_NAME):$(SERVICE_VERSION) .

dev: stop build
	docker run -it -v `pwd`:/outside \
          --name ${SERVICE_NAME} \
          -p 8000:8000 \
          $(DOCKERHUB_ID)/$(SERVICE_NAME):$(SERVICE_VERSION) /bin/bash

run: stop
	docker run -d \
          --name ${SERVICE_NAME} \
          --restart unless-stopped \
          -p 8000:8000 \
          $(DOCKERHUB_ID)/$(SERVICE_NAME):$(SERVICE_VERSION)

test:
	@curl -sS http://127.0.0.1:8000

push:
	docker push $(DOCKERHUB_ID)/$(SERVICE_NAME):$(SERVICE_VERSION) 

stop:
	@docker rm -f ${SERVICE_NAME} >/dev/null 2>&1 || :

clean:
	@docker rmi -f $(DOCKERHUB_ID)/$(SERVICE_NAME):$(SERVICE_VERSION) >/dev/null 2>&1 || :

.PHONY: build dev run push test stop clean
