# B3 Operations

## Running the app

First, start the database container with:

```shell
docker compose up -d
```

Extract the input files:

```shell
tar -jxvf priv/b3/operations.tar.bz2 -C priv/b3
```

Run the application with:

```shell
iex -S mix
```

Prepare the data by processing the input files:

```shell
  iex(1)> B3.import_operations
```

From here, you can either make GET requests to the API:

```shell
curl http://localhost:8001/operations\?ticker\=WING24\&DataNegocio\=2024-01-25 | jq
```

Or use the Elixir shell:

```shell
  iex(1)> B3.find_by_ticker_and_date "WING24", "2024-01-25"
```
