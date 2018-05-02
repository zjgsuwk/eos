FROM eosio/builder

RUN git clone -b master --depth 1 https://github.com/EOSIO/eos.git --recursive \
    && cd eos \
    && cmake -H. -B"/tmp/build" -GNinja -DCMAKE_BUILD_TYPE=Release -DWASM_ROOT=/opt/wasm -DCMAKE_CXX_COMPILER=clang++ \
       -DCMAKE_C_COMPILER=clang -DCMAKE_INSTALL_PREFIX=/tmp/build  -DSecp256k1_ROOT_DIR=/usr/local -DBUILD_MONGO_DB_PLUGIN=true \
    && cmake --build /tmp/build --target install

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install openssl && rm -rf /var/lib/apt/lists/*
RUN cp -r /usr/local/lib/* /usr/local/lib/ & \
    cp -r  /tmp/build/bin /opt/eosio/bin & \
    cp -r  /tmp/build/contracts /contracts & \
    cp -r /eos/Docker/config.ini / & \
    cp  nodeosd.sh /opt/eosio/bin/nodeosd.sh 
ENV EOSIO_ROOT=/opt/eosio
RUN chmod +x /opt/eosio/bin/nodeosd.sh
ENV LD_LIBRARY_PATH /usr/local/lib
VOLUME /opt/eosio/bin/data-dir
ENV PATH /opt/eosio/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
