REPO="benlichtman/rust-musl-builder"
docker build . -t $REPO
docker push $REPO
