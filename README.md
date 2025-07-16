# Sortix

Sortix is an API application developed in Elixir using the Phoenix framework. 
It allows to create and participate in raffles. 

The application provides functionalities for `raffle creation`, `participation tracking`, and `result verification`. 
It also includes background job processing for handling raffle draws and participation subscribe asynchronously.

## Note

The project runs on Brazilian time.

## Requirements

- Elixir 1.18
- Docker
- ASDF

## Setup

To run the project, you need to have `make` and `asdf` installed.

| Comnmand       | Description                                                       |
| :------------- | :---------------------------------------------------------------- |
| `make install` |  Setup the entire project (language, docker, project, depdencies) |
| `make test`    |  Test     application                                             |
| `make server`  |  Run dev server                                                   |

Setup without `Make`

```
asdf install
docker-compose up -d
mix ecto.setup
mix deps.get
```

## Rotas

| Caminho                                          | Parametro / Corpo                                               | Descrição                         |
| :----------------------------------------------- | :-------------------------------------------------------------- | :-------------------------------- |
| `POST /api/users`                                |  `{"name": "Jane Doe", "email" :"jane@example.com"}`            | Rota de criacao de usuario        |
| `POST /api/raffles`                              |  `{"name": "Test Raffle", "draw_date": "2025-07-25T12:00:00Z"}` | Rota de criacao de sorteio        |
| `POST /api/raffles/:raffle_id/participations`    |  `{"user_id": "30b15363-b453-4ceb-a283-617c3192e353"}`          | Rota de participacao de sorteio   |
| `GET /api/raffles/:id`                               | id: `6e3b29ff-4c94-4987-941d-f6fbac1d55df`                      | Rota de verificacao de sorteio    |


## QA

### 0. Start server

```sh
make refresh
```

```sh
make server
```

### 1. Create a Raffle: 

```sh
curl -X POST http://localhost:4000/api/raffles \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Sorteio 01",
    "draw_date": "2025-07-17T12:00:00Z"
  }'
```

### 2. Create users

```sh
curl -X POST http://localhost:4000/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Jane Doe",
    "email": "jane@example.com"
  }'

```

### 3. Participate Raffle

```sh
curl -X POST http://localhost:4000/api/raffles/<RAFFLE_ID>/participations \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "<USER_ID>"
  }'
```

### 4. Verify result and got an error `{"message": "Not drawn yet"}`

```sh
curl -X GET http://localhost:4000/api/raffles/<RAFFLE_ID>
```

### 5. Force all Raffles Draw (test purpose)

```sh
iex -S mix
draw_all_raffles.()
```

### 6. Verify results

```sh
curl -X GET http://localhost:4000/api/raffles/<RAFFLE_ID>
```

## Utils

Enter in iex mode `make iex_server`

```elixir
# list all participantes from a raffle
participants.("<raffle_id">) 

# list all jobs created
all_jobs.()

# execute all raffles draw NOW
draw_all_raffles.()
```