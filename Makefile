postgres:
	docker run --name postgres15 -p 5433:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:15-alpine

create_db:
	docker exec -it postgres15 createdb --username=root --owner=root video_sharing_system

drop_db:
	docker exec -it postgres15 dropdb video_sharing_system

create_migrations:
	migrate create -ext sql -dir db/migrations -seq $(name)

migrate_up:
	migrate -path db/migrations -database "postgresql://root:secret@localhost:5433/video_sharing_system?sslmode=disable" -verbose up $(count)

migrate_down:
	migrate -path db/migrations -database "postgresql://root:secret@localhost:5433/video_sharing_system?sslmode=disable" -verbose down $(count)

sqlc_init:
	docker run --rm -v $(CURDIR):/src -w /src kjconroy/sqlc init

sqlc_generate:
	docker run --rm -v $(CURDIR):/src -w /src kjconroy/sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/urunsiyabend/simple_bank/db/sqlc Store

.PHONY:
	postgres
	create_db
	drop_db
	create_migrations
	migrate_up
	migrate_down
	sqlc_init
	sqlc_generate
	test
	server
	mock
