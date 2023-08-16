# Elasticsearch on Docker

## Usage

Run Docker Compose.

```bash
docker compose up -d
```

Get enrollment token for Kibana.

```bash
docker exec -it es01 /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana
```

Check kibana url.

```bash
docker compose logs kibana
```

Go to kibana url in browser then input enrollment token and click button.

When setup is finished, login as `elastic` user.