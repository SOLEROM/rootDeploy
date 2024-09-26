
PYTHON_VERSION=3.8
GCC_VERSION=9


docker build -f Dockerfile.base -t my-base-image:latest .

docker build --progress=plain  --build-arg PYTHON_VERSION=$PYTHON_VERSION \
             --build-arg GCC_VERSION=$GCC_VERSION \
             -f Dockerfile \
             -t myapp:python${PYTHON_VERSION}-gcc${GCC_VERSION} .

echo "Built image myapp:python${PYTHON_VERSION}-gcc${GCC_VERSION}"

docker run -it --rm myapp:python${PYTHON_VERSION}-gcc${GCC_VERSION} /bin/bash