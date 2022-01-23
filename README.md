# Docker image for opam-ocaml

Build the image via:
```
docker build -t opam-ocaml .
```

After the image is built, run the container via
```
docker-compose up
```

To run the commands, enter the shell via
```
docker exec -it opam-ocaml /bin/bash
```
