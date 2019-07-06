# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: devine android ios devine-cross swarm evm all test clean
.PHONY: devine-linux devine-linux-386 devine-linux-amd64 devine-linux-mips64 devine-linux-mips64le
.PHONY: devine-linux-arm devine-linux-arm-5 devine-linux-arm-6 devine-linux-arm-7 devine-linux-arm64
.PHONY: devine-darwin devine-darwin-386 devine-darwin-amd64
.PHONY: devine-windows devine-windows-386 devine-windows-amd64
##export GOPATH=$(pwd)
GOBIN = $(shell pwd)/build/bin
GO ?= latest

devine:
	build/env.sh go run build/ci.go install ./cmd/devine
	@echo "Done building."
	@echo "Run \"$(GOBIN)/devine\" to launch devine."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/devine.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/devine.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

clean:
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/kevinburke/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go get -u github.com/golang/protobuf/protoc-gen-go
	env GOBIN= go install ./cmd/abigen
	@type "npm" 2> /dev/null || echo 'Please install node.js and npm'
	@type "solc" 2> /dev/null || echo 'Please install solc'
	@type "protoc" 2> /dev/null || echo 'Please install protoc'

# Cross Compilation Targets (xgo)

devine-cross: devine-linux devine-darwin devine-windows devine-android devine-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/devine-*

devine-linux: devine-linux-386 devine-linux-amd64 devine-linux-arm devine-linux-mips64 devine-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/devine-linux-*

devine-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/devine
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/devine-linux-* | grep 386

devine-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/devine
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/devine-linux-* | grep amd64

devine-linux-arm: devine-linux-arm-5 devine-linux-arm-6 devine-linux-arm-7 devine-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/devine-linux-* | grep arm

devine-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/devine
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/devine-linux-* | grep arm-5

devine-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/devine
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/devine-linux-* | grep arm-6

devine-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/devine
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/devine-linux-* | grep arm-7

devine-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/devine
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/devine-linux-* | grep arm64

devine-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/devine
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/devine-linux-* | grep mips

devine-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/devine
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/devine-linux-* | grep mipsle

devine-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/devine
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/devine-linux-* | grep mips64

devine-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/devine
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/devine-linux-* | grep mips64le

devine-darwin: devine-darwin-386 devine-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/devine-darwin-*

devine-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/devine
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/devine-darwin-* | grep 386

devine-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/devine
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/devine-darwin-* | grep amd64

devine-windows: devine-windows-386 devine-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/devine-windows-*

devine-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/devine
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/devine-windows-* | grep 386

devine-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/devine
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/devine-windows-* | grep amd64
