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
2024:
	hugo new posts/2024/$(name)/index.md
post:
	hugo new posts/2025/$(name)/index.md
serve:
	hugo serve --disableFastRender
km:
	hugo new kamailio/$(id)/index.md
km56:
	hugo new kamailio/56/$(id)/index.md
ch=
op:
	hugo new opensips/$(ch)/$(id)/index.md