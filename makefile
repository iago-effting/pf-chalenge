.PHONY: setup dev db reset test up down logs

install:
	@read -p "Do you want to start Docker Compose? [y/N] " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		make up; \
	fi
	asdf install
	make setup
	make db

	@echo "\n✅ Project setup completed successfully!"
	@echo "➡️  To run server execute: make server"
	
setup:
	mix deps.get

server:
	mix phx.server

refresh:
	mix ecto.reset

iex_server:
	iex -S mix phx.server

test:
	mix test

db:
	mix ecto.setup

reset:
	mix ecto.reset

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f
