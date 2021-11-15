package crypto

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestComparePasswordHash(t *testing.T) {
	type Args struct {
		password string
		hash     string
	}
	type Want struct {
		result bool
	}
	tests := []struct {
		name string
		args Args
		want Want
	}{
		{
			"valid hash",
			Args{
				"hello123",
				"$2a$04$nhBq5RuiAFzB8dHYWp4S..SMKfvqI3u6ZZyciB9wl6iNCe9ZqsZ5K",
			},
			Want{
				true,
			},
		},
		{
			"invalid hash",
			Args{
				"test",
				"$2a$04$nhBq5RuiAFzB8dHYWp4S..SMKfvqI3u6ZZyciB9wl6iNCe9ZqsZ5K",
			},
			Want{
				false,
			},
		},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			gotResult := ComparePasswordHash(test.args.hash, test.args.password)
			assert.Equal(t, test.want.result, gotResult)
		})
	}
}
