FROM node:9.11

RUN apt-get update && apt-get install -y \
    git \
    libboost-dev \
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
    && rustup update \
    && rustc -Vv \
    && cargo -V \
    && rustup component add rust-src
ENV PATH "/home/bc/.cargo/bin:$PATH"

# Install neon-bindings
RUN npm install -g neon-cli --prefix /home/bc/.npm
ENV PATH "/home/bc/.npm/bin:$PATH"

ENV BCNODE_BRANCH=master

# Clone Block Collider repository
RUN git clone https://github.com/blockcollider/bcnode /home/bc/src && \
    cd /home/bc/src && \
    git checkout ${BCNODE_BRANCH} && \
    mkdir logs && \
    mkdir _data

WORKDIR /home/bc/src

RUN yarn && \
    yarn run proto && \
    yarn run build-native && \
    yarn run build && \
    #yarn test --ci --coverage && \
    #yarn run outdated && \
    yarn run nsp check --threshold 7

VOLUME /home/bc/src/_data

EXPOSE 3000 9090

ENTRYPOINT [ "node", "./bin/cli" ]
