# FunkyDarts api
Backend for FunkyDarts web-app

## local testing:
run mongo docker instance:
`docker run --rm -it -d -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=secret --name mongo mongo`

exec into container:
`docker exec -it mongo sh`

start mongosh as admin:
`mongosh -u admin -p secret`
`use funkyDarts`
`db.games.insert(sample-data)`
