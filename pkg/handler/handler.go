package handler

import "github.com/savsgio/atreugo/v11"

func LivenessProbe(ctx *atreugo.RequestCtx) error {
	return ctx.JSONResponse("i am alive")
}

func Test(ctx *atreugo.RequestCtx) error {
	return ctx.JSONResponse("i am authorized")
}
