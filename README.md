# Environmental setup

## Install Docker
See: [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)

## Add User to docker group
```bash
cat /etc/group | grep docker
# docker:x:***:

sudo usermod -aG docker $USER

cat /etc/group | grep docker
# docker:x:***:<username>
```

## Run docker without root permission
```bash
docker run hello-world
# Hello from Docker!
```

## Access from external device on your network
* [Windows](Scripts/win/README.md)

# Run App
```bash
docker compose up
```

## Preview on your browser
Open: http://localhost/
