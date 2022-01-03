package middleware

import (
	"strconv"
	"strings"

	"github.com/savsgio/atreugo/v11"
	"github.com/savsgio/go-logger"
	"github.com/valyala/fasthttp"
)

func Logging(ctx *atreugo.RequestCtx) error {

	// skip liveness- readinessprobes
	if Skip(string(ctx.RequestURI())) {
		return ctx.Next()
	}

	method := string(ctx.Request.Header.Method())
	if strings.EqualFold(method, fasthttp.MethodOptions) {
		return ctx.Next()
	}

	uri := string(ctx.Request.Header.RequestURI())
	statusCode := strconv.Itoa(ctx.Response.StatusCode())

	message, _ := ctx.UserValue("message").(string)
	if ctx.Response.StatusCode() < fasthttp.StatusBadRequest {
		logger.Infof("%s %s %s %s", method, uri, statusCode, message)
	} else {
		logger.Errorf("%s %s %s %s", method, uri, statusCode, message)
	}

	return ctx.Next()
}
