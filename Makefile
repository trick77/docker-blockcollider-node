IMAGE := trick77/bcnode

test:
	true

image:
	docker build -t $(IMAGE) .

push-image:
	docker push $(IMAGE)
