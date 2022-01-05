package config

import (
	"fmt"
	"os"

	"gopkg.in/yaml.v3"
)

// Config represents the base level config file
type Config struct {
	API      API      `yaml:"api"`
	Keycloak Keycloak `yaml:"keycloak"`
}

// API represents all api configurations
type API struct {
	Port int16 `yaml:"port"`
}

// Keycloak represents all keycloak configs
type Keycloak struct {
	Host     string `yaml:"host"`
	Realm    string `yaml:"realm"`
	ClientID string `yaml:"client-id"`
}

// LoadConfig will load config yaml if path is specified correctly
func LoadConfig(path string) (*Config, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, fmt.Errorf("could not load config from path %s", path)
	}

	var result Config
	err = yaml.Unmarshal(data, &result)
	if err != nil {
		return nil, fmt.Errorf("could not unmarshal config")
	}

	return &result, nil
}
