package db

import (
	"context"
	"log"

	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

// Connect creates a connection to a mongodb instance
func Connect() *mongo.Client {
	ctx := context.Background()
	client, err := mongo.Connect(ctx, options.Client().ApplyURI("mondogb://localhost:27017")) //TODO replace with uri from config
	if err != nil {
		log.Fatalln(client, err)
	}
	return client
}
