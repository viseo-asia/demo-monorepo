docker-compose build --no-cache
docker rm -f demo-rabbits
docker run -p 30000:5000 --name demo-rabbits -d demo-rabbits_server
