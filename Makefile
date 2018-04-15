IMAGE := trick77/bcnode

test:
	true

image:
	docker build -t $(IMAGE) .


