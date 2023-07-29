package main

import (
	"context"
	"log"
	"os"

	"github.com/elastic/go-elasticsearch/v8"
	"github.com/elastic/go-elasticsearch/v8/typedapi/core/search"
	"github.com/elastic/go-elasticsearch/v8/typedapi/types"
	"github.com/joho/godotenv"
)

func init() {
	godotenv.Load()
}

func main() {
	cloudID := os.Getenv("ELASTIC_CLOUD_ID")
	if cloudID == "" {
		log.Fatal("cloud id: no value set to ELASTIC_CLOUD_ID")
	}
	apiKey := os.Getenv("ELASTIC_API_KEY")
	if apiKey == "" {
		log.Fatal("api key: no value set to ELASTIC_API_KEY")
	}
	typedClient, err := elasticsearch.NewTypedClient(elasticsearch.Config{
		CloudID: cloudID,
		APIKey:  apiKey,
	})
	if err != nil {
		log.Fatal("create new client: ", err)
	}

	res, err := typedClient.Search().
		Index("my_index").
		Request(&search.Request{
			Query: &types.Query{MatchAll: &types.MatchAllQuery{}},
		}).
		Do(context.TODO())
	if err != nil {
		log.Fatal("search: ", err)
	}

	hits := res.Hits.Hits
	for i := range hits {
		hit := hits[i]
		log.Printf("hit: %s", hit.Index_)
		for key, value := range hit.Fields {
			log.Printf("key: %s, value: %v\n", key, value)
		}
	}
}
