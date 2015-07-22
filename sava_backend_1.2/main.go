package main

import (
	"flag"
	"github.com/gin-gonic/gin"
	"io/ioutil"
	"net/http"
	"os"
	"strconv"
)

var (
	lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
)

func main() {

	port := flag.Int("port", 8080, "Sets the port to listen on")

	flag.Parse()

	envPort := os.Getenv("SAVA_PORT")

	if envPort != "" {
		*port, _ = strconv.Atoi(envPort)
	}

	r := gin.Default()
	r.GET("/api/message", func(c *gin.Context) {

		resp, err := http.Get("http://hipsterjesus.com/api/?paras=1&type=hipster-latin&html=false")
		if err != nil {
			c.JSON(200, gin.H{"text": "" + lorem + ""})
		}
		defer resp.Body.Close()
		body, err := ioutil.ReadAll(resp.Body)
		if err != nil {
			c.JSON(200, gin.H{"text": "" + lorem + ""})
		}
		c.String(200, string(body[:]))
	})

	r.Run(":" + strconv.Itoa(*port))
}
