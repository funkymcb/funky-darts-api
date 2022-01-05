package middleware

import (
	"fmt"
	"net/http"
	"strings"

	"github.com/savsgio/atreugo/v11"
)

func (m *Middleware) Auth(ctx *atreugo.RequestCtx) error {
	// skip authorization for live- readinessprobe
	if Skip(string(ctx.RequestURI())) {
		return ctx.Next()
	}

	authTokenBytes := ctx.Request.Header.Peek("Authorization")
	authToken := strings.Replace(string(authTokenBytes), "Bearer", "", 1)

	token, _, err := m.keycloakClient.DecodeAccessToken(
		ctx,
		authToken,
		m.config.Keycloak.Realm,
	)
	if err != nil || !token.Valid {
		ctx.Error(err.Error(), http.StatusUnauthorized)
		return fmt.Errorf("invalid or expired token, error: %v", err)
	}

	return ctx.Next()
}
