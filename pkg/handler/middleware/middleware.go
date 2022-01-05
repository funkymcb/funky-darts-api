package middleware

import (
	"github.com/Nerzal/gocloak/v10"
	"github.com/funkymcb/funky-darts-api/pkg/config"
)

// Middleware represents a new middleware
type Middleware struct {
	config         *config.Config
	keycloakClient gocloak.GoCloak
}

// NewMiddleware initializes a new middleware
func NewMiddleware(config *config.Config, kc gocloak.GoCloak) *Middleware {
	return &Middleware{
		config:         config,
		keycloakClient: kc,
	}
}

// Skip gets a map of routes that should be skipped by the middleware
// it returns true if the map contains the requestURI
func Skip(uri string) bool {
	routesToSkip := map[string]bool{
		"/live":  true,
		"/ready": true,
	}
	return routesToSkip[uri]
}
