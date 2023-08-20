name:=default
type:=default

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
	hugo new $(type)/$(name)/index.md
post:
	hugo new posts/2023/$(name)/index.md
serve:
	hugo serve
