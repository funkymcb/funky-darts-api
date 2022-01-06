package middleware

import (
	"fmt"
	"net/http"

	"github.com/savsgio/atreugo/v11"
)

func (m *Middleware) Auth(ctx *atreugo.RequestCtx) error {
	// skip authorization for live- readinessprobe
	if Skip(string(ctx.RequestURI())) {
		return ctx.Next()
	}

	authTokenBytes := ctx.Request.Header.Peek("Authorization")
	if len(authTokenBytes) <= 0 {
		err := fmt.Errorf("authorization header is missing")
		ctx.Error(err.Error(), http.StatusUnauthorized)
		return err
	}

	token, _, err := m.keycloakClient.DecodeAccessToken(
		ctx,
		string(authTokenBytes),
		m.config.Keycloak.Realm,
	)
	if err != nil || !token.Valid {
		ctx.Error(err.Error(), http.StatusUnauthorized)
		return fmt.Errorf("invalid or expired token: %v", err)
	}

	return ctx.Next()
}
