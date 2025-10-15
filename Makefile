# Base64 Encoder/Decoder Web Application Makefile

# Variables
BINARY_NAME=web_crypt
BINARY_UNIX=$(BINARY_NAME)_unix
MAIN_FILE=main.go
PORT=8082

# Default target
.DEFAULT_GOAL := help

# Help target
.PHONY: help
help: ## Show this help message
	@echo "Base64 Encoder/Decoder Web Application"
	@echo "======================================"
	@echo ""
	@echo "Available commands:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# Development targets
.PHONY: run
run: ## Run the application in development mode
	@echo "Starting web application on port $(PORT)..."
	@echo "Open http://localhost:$(PORT) in your browser"
	@go run $(MAIN_FILE)

.PHONY: build
build: ## Build the application binary
	@echo "Building $(BINARY_NAME)..."
	@go build -o $(BINARY_NAME) $(MAIN_FILE)
	@echo "Binary created: $(BINARY_NAME)"

.PHONY: build-linux
build-linux: ## Build the application for Linux
	@echo "Building $(BINARY_NAME) for Linux..."
	@GOOS=linux GOARCH=amd64 go build -o $(BINARY_UNIX) $(MAIN_FILE)
	@echo "Linux binary created: $(BINARY_UNIX)"

.PHONY: clean
clean: ## Clean build artifacts
	@echo "Cleaning build artifacts..."
	@rm -f $(BINARY_NAME) $(BINARY_UNIX)
	@echo "Clean completed"

# Dependencies
.PHONY: deps
deps: ## Download and tidy dependencies
	@echo "Downloading dependencies..."
	@go mod download
	@go mod tidy
	@echo "Dependencies updated"

.PHONY: deps-update
deps-update: ## Update all dependencies to latest versions
	@echo "Updating dependencies..."
	@go get -u ./...
	@go mod tidy
	@echo "Dependencies updated"

# Testing
.PHONY: test
test: ## Run tests
	@echo "Running tests..."
	@go test -v ./...

.PHONY: test-coverage
test-coverage: ## Run tests with coverage
	@echo "Running tests with coverage..."
	@go test -v -cover ./...

# Code quality
.PHONY: fmt
fmt: ## Format Go code
	@echo "Formatting code..."
	@go fmt ./...

.PHONY: vet
vet: ## Run go vet
	@echo "Running go vet..."
	@go vet ./...

.PHONY: lint
lint: ## Run golangci-lint (if installed)
	@echo "Running linter..."
	@if command -v golangci-lint >/dev/null 2>&1; then \
		golangci-lint run; \
	else \
		echo "golangci-lint not installed. Install with: go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest"; \
	fi

# Development tools
.PHONY: install-tools
install-tools: ## Install development tools
	@echo "Installing development tools..."
	@go install github.com/cosmtrek/air@latest
	@go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
	@echo "Development tools installed"

.PHONY: dev
dev: ## Run with hot reload using air
	@echo "Starting development server with hot reload..."
	@if command -v air >/dev/null 2>&1; then \
		air; \
	else \
		echo "Air not installed. Installing..."; \
		go install github.com/cosmtrek/air@latest; \
		air; \
	fi

# Production
.PHONY: prod
prod: ## Run in production mode
	@echo "Starting application in production mode..."
	@GIN_MODE=release go run $(MAIN_FILE)

.PHONY: prod-build
prod-build: ## Build for production
	@echo "Building for production..."
	@GIN_MODE=release go build -ldflags="-s -w" -o $(BINARY_NAME) $(MAIN_FILE)
	@echo "Production binary created: $(BINARY_NAME)"

# Docker (optional)
.PHONY: docker-build
docker-build: ## Build Docker image
	@echo "Building Docker image..."
	@docker build -t $(BINARY_NAME) .
	@echo "Docker image created: $(BINARY_NAME)"

.PHONY: docker-run
docker-run: ## Run with Docker
	@echo "Running with Docker..."
	@docker run -p $(PORT):$(PORT) $(BINARY_NAME)

# Utility targets
.PHONY: check
check: fmt vet test ## Run all checks (format, vet, test)

.PHONY: all
all: clean deps fmt vet test build ## Run all tasks

.PHONY: status
status: ## Show project status
	@echo "Project Status:"
	@echo "==============="
	@echo "Go version: $(shell go version)"
	@echo "Binary: $(BINARY_NAME)"
	@echo "Port: $(PORT)"
	@echo "Main file: $(MAIN_FILE)"
	@echo ""
	@echo "Dependencies:"
	@go list -m all | head -10
	@echo "..."

# API testing
.PHONY: test-api
test-api: ## Test API endpoints
	@echo "Testing API endpoints..."
	@echo "Testing encode endpoint..."
	@curl -s -X POST http://localhost:$(PORT)/api/encode \
		-H "Content-Type: application/json" \
		-d '{"text":"Hello, World!"}' | jq .
	@echo ""
	@echo "Testing decode endpoint..."
	@curl -s -X POST http://localhost:$(PORT)/api/decode \
		-H "Content-Type: application/json" \
		-d '{"text":"SGVsbG8sIFdvcmxkIQ=="}' | jq .

# Server management
.PHONY: start
start: build ## Build and start the application
	@echo "Starting $(BINARY_NAME)..."
	@./$(BINARY_NAME)

.PHONY: stop
stop: ## Stop the application
	@echo "Stopping application..."
	@pkill -f $(BINARY_NAME) || echo "No running instance found"
	@lsof -ti:8082 | xargs kill -9 || echo "No running instance found"

.PHONY: restart
restart: stop start ## Restart the application

# Show information
.PHONY: info
info: ## Show project information
	@echo "Base64 Encoder/Decoder Web Application"
	@echo "======================================"
	@echo "Repository: github.com/zingerone/web_crypt"
	@echo "Framework: Gin (Go web framework)"
	@echo "Features: Base64 encoding/decoding web interface"
	@echo ""
	@echo "Quick Start:"
	@echo "  make run     - Start development server"
	@echo "  make build   - Build binary"
	@echo "  make test    - Run tests"
	@echo "  make help    - Show all commands"
