ARG ELIXIR_VERSION=1.16.0-alpine

FROM elixir:$ELIXIR_VERSION

WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force


COPY mix.exs mix.lock ./

RUN mix deps.get
RUN mix compile

COPY . /app

EXPOSE 8001

CMD [ "mix", "run", "--no-halt" ]
