FROM alpine:3.6 as dev
RUN apk add --no-cache go make musl-dev glide
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

FROM dev as prod-build
WORKDIR $GOPATH/src/github.com/assemblyline/ok
COPY . .
RUN make

FROM scratch as prod
MAINTAINER Ed Robinson <ed@a10e.org>

COPY --from=prod-build /go/src/github.com/assemblyline/ok/ok /ok
CMD ["/ok"]
EXPOSE 8888
