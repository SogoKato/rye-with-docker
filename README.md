# rye-with-docker

Sample project to use rye with docker

https://sogo.dev/posts/2023/11/rye-with-docker

## build

```sh
docker build . --build-arg PYTHON_VERSION=$(cat .python-version)
```
