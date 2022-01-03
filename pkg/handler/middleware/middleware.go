package middleware

// Skip gets a map of routes that should be skipped by the middleware
// it returns true if the map contains the requestURI
func Skip(uri string) bool {
	routesToSkip := map[string]bool{
		"/live":  true,
		"/ready": true,
	}
	return routesToSkip[uri]
}
