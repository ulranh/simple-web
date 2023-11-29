package main

import (
	"fmt"
	"net/http"

	log "github.com/sirupsen/logrus"
)

func main() {
	http.Handle("/", loggingMiddleware(http.HandlerFunc(handler)))
	http.Handle("/stop", http.HandlerFunc(stopHandler)))
	http.ListenAndServe(":8000", nil)
}

func handler(w http.ResponseWriter, req *http.Request) {
	fmt.Fprintf(w, "ulli 1415")
}

func stopHandler(w http.ResponseWriter, req *http.Request) {
	fmt.Fprintf(w, "STOP!")
}

func loggingMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, req *http.Request) {
		log.Infof("uri: %s", req.RequestURI)
		next.ServeHTTP(w, req)
	})
}
