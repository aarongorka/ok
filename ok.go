package main

import (
	"flag"
	"fmt"
	log "github.com/sirupsen/logrus"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	log.WithFields(log.Fields{
		"remote_address": r.RemoteAddr,
		"method":         r.Method,
		"url":            r.URL.Path,
	}).Info()
	fmt.Fprint(w, "ok")
}

func main() {
	log.SetFormatter(&log.JSONFormatter{})
	port := flag.Int("port", 8888, "port number")
	flag.Parse()
	http.HandleFunc("/", handler)
	http.ListenAndServe(fmt.Sprintf(":%d", *port), nil)
}
