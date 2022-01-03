package main

import (
	"log"

	"github.com/funkymcb/funky-darts-api/pkg/config"
)

var configPath = "./configs/config.yaml"

func main() {
	config, err := config.LoadConfig(configPath)
	if err != nil {
		log.Fatalln("config could not be loaded from path:", configPath)
	}
	log.Println(config)
}
