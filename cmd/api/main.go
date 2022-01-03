package main

import (
	"fmt"
	"log"

	"github.com/funkymcb/funky-darts-api/pkg/config"
	"github.com/funkymcb/funky-darts-api/pkg/handler"
	"github.com/funkymcb/funky-darts-api/pkg/handler/middleware"
	"github.com/savsgio/atreugo/v11"
)

var configPath = "./configs/config.yaml"

func main() {
	config, err := config.LoadConfig(configPath)
	if err != nil {
		log.Fatalln("config could not be loaded from path:", configPath)
	}

	server := atreugo.New(atreugo.Config{
		Addr: fmt.Sprintf(":%d", config.API.Port),
	})

	server.UseAfter(middleware.Logging)

	initAPIRoutes(server)

	if err := server.ListenAndServe(); err != nil {
		log.Fatalln("could not start atreugo server:", err)
	}
}

func initAPIRoutes(server *atreugo.Atreugo) {
	server.GET("/live", handler.LivenessProbe)
	server.GET("/test", handler.Test)
}
