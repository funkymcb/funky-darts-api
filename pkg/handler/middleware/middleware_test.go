package middleware

import (
	"fmt"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestSkip(t *testing.T) {
	type args struct {
		uri string
	}
	tests := []struct {
		name string
		args args
		want bool
	}{
		{
			name: "skip /live uri",
			args: args{
				uri: "/live",
			},
			want: true,
		},
		{
			name: "skip /ready uri",
			args: args{
				uri: "/ready",
			},
			want: true,
		},
		{
			name: "do not skip /random uri",
			args: args{
				uri: "/random",
			},
			want: false,
		},
	}

	for _, test := range tests {
		got := Skip(test.args.uri)
		assert.Equal(t, test.want, got, fmt.Sprintf("Test '%s' failed", test.name))
	}
}
