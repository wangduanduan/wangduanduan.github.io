name?=
all:
	make build
	make push
build:
	hugo -d docs
push:
	git add -A
	git commit -am "update"
	git push
new:
	hugo new posts/2023/$(name)/index.md
serve:
	hugo serve