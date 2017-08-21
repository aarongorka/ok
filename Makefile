GO = go
LDFLAGS = -s -w -linkmode external -extldflags "-static"
TARGET = ok
REPO = quay.io/assemblyline/ok
.PHONY: build clean release

all: $(TARGET)

$(TARGET): export GOOS=linux
$(TARGET): export GOARCH=amd64
$(TARGET): $(TARGET).go
	go build --ldflags '$(LDFLAGS)' $(TARGET).go

build:
	docker build --target=prod -t $(REPO) .

release: build
	docker push $(REPO)

clean:
	$(RM) $(TARGET)
