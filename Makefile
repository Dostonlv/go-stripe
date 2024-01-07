STRIPE_SECRET=sk_test_51KHRiBE8NBTTWoLqwjCrEIVCcndkFgWRYFdYgnBfrEiDeLxlUOaRoWnX9uglUV5FCnz8ufoqzF5Nk6ef2mjD2aHu00DExgCQqN
STRIPE_KEY=pk_test_51KHRiBE8NBTTWoLqY6yTrfGZXM7qxnm9gjA2O95ksAzcOefjxcHKwakXiVhHSrCbz5ZLISWdhqhkIDi0mEQAsmdP00843e5Xjo
GOSTRIPE_PORT=4000
API_PORT=4001


## build: builds all binaries
build: clean build_front build_back
	@printf "All binaries built!\n"

## clean: cleans all binaries and runs go clean
clean:
	@echo "Cleaning..."
	@- rm -f dist/*
	@go clean
	@echo "Cleaned!"

## build_front: builds the front end
build_front:
	@echo "Building front end..."
	@go build -o dist/gostripe ./cmd/web
	@echo "Front end built!"

## build_back: builds the back end
build_back:
	@echo "Building back end..."
	@go build -o dist/gostripe_api ./cmd/api
	@echo "Back end built!"

## start: starts front and back end
start: start_front start_back
## make front and start back  build command\

## go build -o ./dist/gostripe ./cmd/web && go build -o ./dist/gostripe_api ./cmd/api
##go build  -tags netgo -ldflags '-s -w' -o app ./cmd/web && go build  -tags netgo -ldflags '-s -w' -o app_api ./cmd/api
## go build -o ./dist/gostripe ./cmd/web && go build -o ./dist/gostripe_api ./cmd/api

## start_front: starts the front end
start_front: build_front
	@echo "Starting the front end..."
	@env STRIPE_KEY=${STRIPE_KEY} STRIPE_SECRET=${STRIPE_SECRET} ./dist/gostripe -port=${GOSTRIPE_PORT} &
	@echo "Front end running!"

## start_back: starts the back end
start_back: build_back
	@echo "Starting the back end..."
	@env STRIPE_KEY=${STRIPE_KEY} STRIPE_SECRET=${STRIPE_SECRET} ./dist/gostripe_api -port=${API_PORT} &
	@echo "Back end running!"

## stop: stops the front and back end
stop: stop_front stop_back
	@echo "All applications stopped"

## stop_front: stops the front end
stop_front:
	@echo "Stopping the front end..."
	@-pkill -SIGTERM -f "gostripe -port=${GOSTRIPE_PORT}"
	@echo "Stopped front end"

## stop_back: stops the back end
stop_back:
	@echo "Stopping the back end..."
	@-pkill -SIGTERM -f "gostripe_api -port=${API_PORT}"
	@echo "Stopped back end"