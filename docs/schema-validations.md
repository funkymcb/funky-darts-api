# players:
db.createCollection("players", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: [ "firstName", "lastName", "username", "passwordHash" ],
            properties: {
                firstName: {
                    bsonType: "string",
                    description: "must be a string and is required"
                },
                lastName: {
                    bsonType: "string",
                    description: "must be a string and is required"
                },
                username: {
                    bsonType: "string",
                    description: "must be a string and is required"
                },
                passwordHash: {
                    bsonType: "string",
                    description: "must be a string and is required"
                }
            }
        }
    }
})

# game:
db.createCollection("games", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: [ "type", "players" ],
            properties: {
                type: {
                    enum: [ "301", "501", "elimination", "around the clock", "cricket" ],
                    description: "can only be one of the enum values and is required"
                },
                players: {
                    bsonType: "object",
                    required: [ "username", "passwordHash" ],
                    properties: {
                        username: {
                            bsonType: "string",
                            description: "must be a string and is required"
                        },
                        passwordHash: {
                            bsonType: "string",
                            description: "must be a string and is required"
                        }
                    }
                }
            }
        }
    }
})
