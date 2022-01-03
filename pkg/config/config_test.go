package config

import (
	"fmt"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestLoadConfig(t *testing.T) {
	type args struct {
		configPath string
	}
	tests := []struct {
		name    string
		args    args
		wantErr bool
	}{
		{
			name:    "Basic",
			args:    args{"./fixtures/basic-config.yaml"},
			wantErr: false,
		},
		{
			name:    "Corrupted",
			args:    args{"./fixtures/corrupted.yaml"},
			wantErr: true,
		},
		{
			name:    "File does not exist",
			args:    args{"./fixtures/none-existent.yaml"},
			wantErr: true,
		},
	}

	for _, test := range tests {
		var gotError bool
		_, err := LoadConfig(test.args.configPath)
		if err != nil {
			gotError = true
		}
		assert.Equal(t, test.wantErr, gotError, fmt.Sprintf("test: '%s' failed",
			test.name,
		))
	}
}
