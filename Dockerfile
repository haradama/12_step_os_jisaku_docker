FROM ubuntu:20.04 as build

WORKDIR /tmp

ADD h8write.c /tmp/h8write.c

RUN apt-get update && \
    apt-get install -y wget build-essential unzip

RUN gcc h8write.c -o h8write -Wall && \
    mv h8write /usr/local/bin && \
    chmod +x /usr/local/bin/h8write

RUN wget http://kozos.jp/books/makeos/download.sh && \
    chmod +x download.sh && \
    ./download.sh && \
    chmod +x build-binutils.sh && \
    chmod +x build-gcc.sh

RUN ./build-binutils.sh && \
    cd binutils-2.19.1 && \
    make install && \
    cd ..

ADD patch-gcc-3.4.6-config-h8300.txt /tmp/patch-gcc-3.4.6-config-h8300.txt

RUN tar xvzf gcc-3.4.6.tar.gz && \
    cd gcc-3.4.6 && \
    patch -p0 < ../patch-gcc-3.4.6-gcc4.txt && \
    patch gcc/config/h8300/h8300.c ../patch-gcc-3.4.6-config-h8300.txt && \
    ./configure --target=h8300-elf --disable-nls --disable-threads --disable-shared --disable-werror --enable-languages=c && \
    make && \
    make install

FROM ubuntu:20.04 as runtime

COPY --from=build /usr/local /usr/local
COPY --from=build /usr/bin/make /usr/bin/make

ENV PATH /usr/local/bin:$PATH
ENV LD_LIBRARY_PATH /usr/local/lib:$LD_LIBRARY_PATH

WORKDIR /work