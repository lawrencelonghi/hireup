package main

import (
	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	// Serve tudo da pasta public
	r.Static("/", "./public")

	r.Run(":8080")
}