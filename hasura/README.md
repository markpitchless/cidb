# CIDB Hasura

The database and GraphQL backend for CIDB is provided by the wonderful Hasura.

## Usage

Start the backend database and GraphQL API with:

```bash
docker compose up -d
```

Get a psql prompt in the backend database with:

```bash
docker exec -it hasura_postgres_1 psql -U postgres 
```
