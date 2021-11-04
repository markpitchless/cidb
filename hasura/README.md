# CIDB Hasura

The database and GraphQL backend for CIDB is provided by the wonderful Hasura.

## Usage

Start the backend database and GraphQL API with:

```bash
docker compose up -d
```

To restore the [migrations and meta data](https://hasura.io/docs/latest/graphql/core/migrations/index.html) you need to [install the hasura CLI](https://hasura.io/docs/latest/graphql/core/hasura-cli/install-hasura-cli.html) tool and then:

```bash
hasura migrate apply --all-databases --endpoint=http://localhost:8080/
hasura metadata reload --endpoint=http://localhost:8080/
```

The graphql API is now up and running on http://localhost:8080/v1/graphql. The hasura console is on http://localhost:8080/console.

Get a psql prompt in the backend database with:

```bash
docker exec -it hasura_postgres_1 psql -U postgres 
```
