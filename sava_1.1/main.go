package main

import (
	"flag"
	"github.com/gin-gonic/gin"
	"net/http"
	"os"
	"strconv"
)

func main() {

	port := flag.Int("port", 8080, "Sets the port to listen on")

	flag.Parse()

	envPort := os.Getenv("SAVA_PORT")

	if envPort != "" {
		*port, _ = strconv.Atoi(envPort)
	}

	r := gin.Default()
	r.Static("/public", "./public")
	r.GET("/", func(c *gin.Context) {
		c.Redirect(http.StatusMovedPermanently, "/public")
	})

	r.Run(":" + strconv.Itoa(*port))
}
