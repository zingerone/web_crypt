package main

import (
	"encoding/base64"
	"net/http"
	"os"
	"strings"

	"github.com/gin-gonic/gin"
)

type Base64Request struct {
	Text string `json:"text" binding:"required"`
}

type Base64Response struct {
	Encoded string `json:"encoded"`
	Decoded string `json:"decoded"`
	Error   string `json:"error,omitempty"`
}

func main() {
	r := gin.Default()

	// Load HTML templates
	r.LoadHTMLGlob("templates/*")

	// Serve static files
	r.Static("/static", "./static")

	// Home page
	r.GET("/", func(c *gin.Context) {
		c.HTML(http.StatusOK, "index.html", gin.H{
			"title": "Base64 Encoder/Decoder",
		})
	})

	// API routes
	api := r.Group("/api")
	{
		api.POST("/encode", encodeHandler)
		api.POST("/decode", decodeHandler)
	}
	// get env PORT
	port := os.Getenv("PORT")
	if port == "" {
		port = "8082"
	}
	// Start server
	r.Run(":" + port)
}

func encodeHandler(c *gin.Context) {
	var req Base64Request
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, Base64Response{
			Error: "Invalid request format",
		})
		return
	}

	encoded := base64.StdEncoding.EncodeToString([]byte(req.Text))

	c.JSON(http.StatusOK, Base64Response{
		Encoded: encoded,
	})
}

func decodeHandler(c *gin.Context) {
	var req Base64Request
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, Base64Response{
			Error: "Invalid request format",
		})
		return
	}

	// Clean the input (remove whitespace and newlines)
	cleanInput := strings.ReplaceAll(strings.ReplaceAll(req.Text, "\n", ""), " ", "")

	decoded, err := base64.StdEncoding.DecodeString(cleanInput)
	if err != nil {
		c.JSON(http.StatusBadRequest, Base64Response{
			Error: "Invalid base64 string",
		})
		return
	}

	c.JSON(http.StatusOK, Base64Response{
		Decoded: string(decoded),
	})
}
