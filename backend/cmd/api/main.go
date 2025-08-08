package main

import (
	"log"
	"readsync/core"
	"readsync/presentation/server"
)

func main() {
	cfg, err := core.LoadConfig()
	if err != nil {
		log.Fatalf("failed to load config: %v", err)
	}

	srv := server.New(cfg.Port)
	srv.MapRoutes(cfg.CorsOrigins)
	srv.Run()
}
