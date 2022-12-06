---
title: "Golang Dockerfile"
date: 2022-05-28T21:45:48+08:00
---

```
FROM golang:1.16.2 as builder
ENV GO111MODULE=on GOPROXY=https://goproxy.cn,direct
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build .

FROM scratch
WORKDIR /app
COPY --from=builder /app/your_app .
# 配置时区
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
ENV TZ=Asia/Shanghai
EXPOSE 8080
ENTRYPOINT ["./your_app"]
```

