# Base64 Encoder/Decoder Web Application

A modern web application built with Go and Gin framework that provides Base64 encoding and decoding functionality

## Features

- **Encode**: Convert plain text to Base64 encoded string
- **Decode**: Convert Base64 encoded string back to plain text
- **Modern UI**: Clean, responsive design with tabbed interface
- **Real-time**: Instant encoding/decoding with AJAX requests
- **Copy to Clipboard**: Easy copying of results
- **File Support**: Drag and drop text files for processing
- **Keyboard Shortcuts**: Ctrl+Enter to encode/decode
- **Error Handling**: User-friendly error messages
- **Responsive Design**: Works on desktop, tablet, and mobile devices

## Prerequisites

- Go 1.21 or higher
- Git

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd web_crypt
```

2. Install dependencies:
```bash
make deps
```

3. Run the application:
```bash
make run
```

4. Open your browser and navigate to:
```
http://localhost:8080
```

## Quick Start with Makefile

The project includes a comprehensive Makefile for easy development:

```bash
# Show all available commands
make help

# Run the application
make run

# Build the binary
make build

# Run with hot reload (requires air)
make dev

# Run tests
make test

# Format and check code
make check

# Clean build artifacts
make clean
```

### Available Make Commands

- `make run` - Start development server
- `make build` - Build application binary
- `make dev` - Run with hot reload using air
- `make test` - Run tests
- `make fmt` - Format Go code
- `make vet` - Run go vet
- `make lint` - Run linter (if installed)
- `make clean` - Clean build artifacts
- `make deps` - Download dependencies
- `make prod` - Run in production mode
- `make docker-build` - Build Docker image
- `make test-api` - Test API endpoints

## Usage

### Encoding Text
1. Click on the "Encode" tab
2. Enter your text in the input field
3. Click "Encode" button or press Ctrl+Enter
4. Copy the encoded result using the "Copy" button

### Decoding Text
1. Click on the "Decode" tab
2. Enter your Base64 string in the input field
3. Click "Decode" button or press Ctrl+Enter
4. Copy the decoded result using the "Copy" button

### File Processing
- Drag and drop text files onto the input areas
- The file content will be automatically loaded

## API Endpoints

### POST /api/encode
Encodes plain text to Base64.

**Request:**
```json
{
    "text": "Hello, World!"
}
```

**Response:**
```json
{
    "encoded": "SGVsbG8sIFdvcmxkIQ=="
}
```

### POST /api/decode
Decodes Base64 string to plain text.

**Request:**
```json
{
    "text": "SGVsbG8sIFdvcmxkIQ=="
}
```

**Response:**
```json
{
    "decoded": "Hello, World!"
}
```

## Project Structure

```
web_crypt/
├── main.go              # Main application file
├── go.mod              # Go module file
├── templates/          # HTML templates
│   └── index.html      # Main page template
├── static/            # Static assets
│   ├── css/
│   │   └── style.css  # Stylesheet
│   └── js/
│       └── script.js  # JavaScript functionality
└── README.md          # This file
```

## Technologies Used

- **Backend**: Go with Gin framework
- **Frontend**: HTML5, CSS3, JavaScript (ES6+)
- **Styling**: Custom CSS with modern design principles
- **Icons**: Font Awesome
- **Encoding**: Go's built-in base64 package

## Development

To run in development mode with auto-reload:

```bash
# Install air for hot reloading (optional)
go install github.com/cosmtrek/air@latest

# Run with air
air
```

## Building for Production

```bash
# Build the binary
make prod-build

# Run the binary
./web_crypt
```

## Docker Support

The project includes Docker support for containerized deployment:

```bash
# Build Docker image
make docker-build

# Run with Docker
make docker-run

# Or manually
docker build -t web_crypt .
docker run -p 8080:8080 web_crypt
```

## License

This project is open source and available under the MIT License.
