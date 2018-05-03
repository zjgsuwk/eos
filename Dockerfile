FROM r.cfcr.io/zjgsuwk/zjgsuwk/eos:first

RUN  cd eos \
     && cmake --build /tmp/build --target install

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install openssl && rm -rf /var/lib/apt/lists/*

RUN cp -r  /tmp/build/bin /opt/eosio/bin & \
    cp -r  /tmp/build/contracts /contracts & \
    cp -r /eos/Docker/config.ini / & \
    cp  nodeosd.sh /opt/eosio/bin/nodeosd.sh 
ENV EOSIO_ROOT=/opt/eosio
RUN chmod +x /opt/eosio/bin/nodeosd.sh
ENV LD_LIBRARY_PATH /usr/local/lib
VOLUME /opt/eosio/bin/data-dir
ENV PATH /opt/eosio/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
