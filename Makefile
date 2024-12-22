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
add:
	hugo new $(name)/index.md
post:
	hugo new posts/2024/$(name)/index.md
serve:
	hugo serve
ka:
	hugo new kamailio/$(id)/index.md
