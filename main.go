package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()
	

	router.LoadHTMLGlob("templates/*")

	router.Static("/public", "./public")

	router.GET("/example", func(c *gin.Context) {
		c.HTML(http.StatusOK, "index.html", gin.H{
			"title": "Home",
		})
	})

  router.GET("/ping", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "pong",
		})
	})

  router.GET("/", func(c *gin.Context) {
		c.HTML(http.StatusOK, "construction.html", gin.H{
			"title": "Home",
		})
	})

	router.Run()
}
