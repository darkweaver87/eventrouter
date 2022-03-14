FROM --platform=$BUILDPLATFORM golang:1.10 AS build
COPY . /go/src/github.com/openshift/eventrouter
WORKDIR /go/src/github.com/openshift/eventrouter
ARG TARGETOS TARGETARCH
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build .

FROM alpine:3.15
COPY --from=build /go/src/github.com/openshift/eventrouter/eventrouter /bin/eventrouter
CMD ["/bin/eventrouter", "-v", "3", "-logtostderr"]
