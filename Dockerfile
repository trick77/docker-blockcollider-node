FROM node:8.11

RUN apt-get update && apt-get install -y \
    git  \
    unzip

# Add non-privileged user
RUN adduser --disabled-password --gecos '' bc

# Drop privileges
USER bc

WORKDIR /home/bc

ENV YARN_VERSION=1.5.1
ENV PROTOBUF_VERSION=3.5.1

# Install yarn
RUN curl -o- -L https://yarnpkg.com/install.sh | bash -s -- --version ${YARN_VERSION} \
    && export PATH=/home/bc/.yarn/bin:$PATH
ENV PATH "/home/bc/.yarn/bin:$PATH"

# Install protobuf
RUN curl -OL https://github.com/google/protobuf/releases/download/v${PROTOBUF_VERSION}/protoc-${PROTOBUF_VERSION}-linux-x86_64.zip \
    && unzip protoc-${PROTOBUF_VERSION}-linux-x86_64.zip -d /home/bc/protoc \
    && export PATH=/home/bc/protoc/bin:$PATH
ENV PATH "/home/bc/protoc/bin:$PATH"

# Install nightly rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain nightly \
    && export PATH=/home/bc/.cargo/bin:$PATH \
    && rustup component add rust-src
ENV PATH "/home/bc/.cargo/bin:$PATH"

# Install neon-bindings
RUN npm install -g neon-cli --prefix /home/bc/.npm
ENV PATH "/home/bc/.npm/bin:$PATH"

ARG BUILD_FROM_HERE

ENV BCNODE_BRANCH=master
# Dummy user data which is required to be able to pull PR for some reason
#RUN git config --global user.email "me@example.com" && \
#    git config --global user.name "username"

# Clone Block Collider repository
RUN git clone https://github.com/blockcollider/bcnode /home/bc/bcnode && \
    cd /home/bc/bcnode && \
    git checkout ${BCNODE_BRANCH} && \
    mkdir _logs && \
    mkdir _data

WORKDIR /home/bc/bcnode

# Experimental bugfix https://github.com/libp2p/js-libp2p-switch/pull/249
RUN sed -i 's/"libp2p": "^0.19.2"/"libp2p": "^0.20.0"/' package.json
RUN sed -i 's/"bitcore-p2p": "akloboucnik\/bitcore-p2p#fix-unknown-message-or-malformed-payload"/"bitcore-p2p": "^1.1.2"/' package.json

# Reduce number of required blocks to start mining
RUN sed -i 's/numCollected >= 2/numCollected >= 1/' src/engine/index.es6

RUN yarn && \
    yarn run proto && \
    yarn run build-native && \
    yarn run build && \
    yarn run nsp check --threshold 7 && \
    rm -rf src

VOLUME /home/bc/bcnode/config
VOLUME /home/bc/bcnode/_data

EXPOSE 3000

ENTRYPOINT [ "node", "./bin/cli" ]
