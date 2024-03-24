IMAGE_NAME=camellia-r-oss-builder
TAG=latest

build:
	make clean_image
	export DOCKER_BUILDKIT=1
	export BUILDKIT_PROGRESS=tty

	docker build \
		-t $(IMAGE_NAME):${TAG} .

	docker run \
		--name ${IMAGE_NAME}-container \
		-v ./out:/opt/app/camellia-r-oss/out \
		$(IMAGE_NAME):${TAG}

	make clean_image

clean_image:
	docker stop $(IMAGE_NAME)-container 2> /dev/null || true
	docker rm $(IMAGE_NAME)-container 2> /dev/null || true
	docker rmi $(IMAGE_NAME):${TAG} 2> /dev/null || true

