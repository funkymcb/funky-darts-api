package config

type Config struct {
	Mongo struct {
		Uri string `yaml:"mongo"`
	} `yaml:"uri"`
}

func LoadConfig(cfg *Config) {
	//TODO
}
