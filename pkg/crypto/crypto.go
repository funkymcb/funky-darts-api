package crypto

import (
	"log"

	"golang.org/x/crypto/bcrypt"
)

// GenerateHash recieves a password as byte slice
// and returns a hash
func GenerateHash(pwd string) (string, error) {
	hash, err := bcrypt.GenerateFromPassword([]byte(pwd), bcrypt.MinCost)
	if err != nil {
		return string(hash), err
	}
	return string(hash), nil
}

// ComparePasswordHash compares the given password
// with the hashed value of the db
func ComparePasswordHash(hash string, pwd string) bool {
	byteHash := []byte(hash)

	err := bcrypt.CompareHashAndPassword(byteHash, []byte(pwd))
	if err != nil {
		log.Println(err)
		return false
	}

	return true
}
