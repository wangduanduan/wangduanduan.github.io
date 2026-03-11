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
	hugo new posts/2026/$(name)/index.md
serve:
	hugo serve -D
km:
	hugo new kamailio/$(id)/index.md
km56:
	hugo new kamailio/56/$(id)/index.md
ch=
op:
	hugo new opensips/$(ch)/$(id)/index.md