#!/bin/bash

# The script does automatic checking on a Go package and its sub-packages, including:
# 1. gofmt         (http://golang.org/cmd/gofmt/)
# 2. golint        (https://github.com/golang/lint)
# 3. gosimple      (https://github.com/dominikh/go-simple)
# 4. unconvert     (https://github.com/mdempsky/unconvert)
#
# gometalinter (github.com/alecthomas/gometalinter) is used to run each each
# static checker.

set -eux

GO_VERSION=$(go version | grep -Eo 'go[0-9]+\.[0-9]+')
test -n "$GO_VERSION"

if [ "$GO_VERSION" = "go1.11" ]; then
    test -z "$(gometalinter --disable-all \
        --enable=gofmt \
        --enable=golint \
        --enable=gosimple \
        --enable=unconvert \
        --deadline=10m \
        --vendor ./... | grep -v 'ALL_CAPS\|OP_' 2>&1 | tee /dev/stderr)"
fi

go test -tags rpctest ./...
