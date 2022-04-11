DB_URL=postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable
FILE_PATH=I:\code\go\simplebank\db\migrations:/database
FILE_PATH2=db:/database

postgres:
	docker run --name postgres14 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:14-alpine

createdb:
	docker exec -it postgres14 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres14 dropdb simple_bank

migrateup:
	docker run -v "$(FILE_PATH)" --network host migrate/migrate -path=/database/ -database "$(DB_URL)" up

migratedown:
	docker run -v "$(FILE_PATH)" --network host migrate/migrate -path=/database/ -database "$(DB_URL)" down -all

server:
	go run main.go

test:
	go test -v -cover ./...

sqlcdocker:
	docker pull kjconroy/sqlc
sqlc:
	docker run --rm -v I:\code\go\simplebank:/src -w /src kjconroy/sqlc generate

.PHONY: postgres createdb dropdb migrateup migratedown server 
