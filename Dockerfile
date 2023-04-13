FROM ubuntu:jammy
# jammy is the code name of 22.04 LTS

ARG password=<password>

ENV PA_SERVER_PASSWORD=$password

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yy install \
    build-essential \
    libcurl4-openssl-dev \
    libcurl3-gnutls \
    libgl1-mesa-dev \
    libgtk-3-bin \
    libosmesa-dev \
    libpython3.10 \
    xorg

### Install PAServer
ADD https://altd.embarcadero.com/releases/studio/22.0/113/LinuxPAServer22.0.tar.gz ./paserver.tar.gz

RUN tar xvzf paserver.tar.gz
RUN mv PAServer-22.0/* .

# link to installed libpython3.10
RUN mv lldb/lib/libpython3.so lldb/lib/libpython3.so_
RUN ln -s /lib/x86_64-linux-gnu/libpython3.10.so.1 lldb/lib/libpython3.so

COPY paserver_docker.sh ./paserver_docker.sh
RUN chmod +x paserver_docker.sh

# Copy SSL Library to usr/lib for Indy OpenSSL connections
# In Delphi Source before connection: Uses IdSSLOpenSSLHeaders and IdOpenSSLSetCanLoadSymLinks(False);
COPY libcrypto.so /usr/lib/x86_64-linux-gnu/libcrypto.so
COPY libcrypto.so.1.0.0 /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.0
COPY libssl.so /usr/lib/x86_64-linux-gnu/libssl.so
COPY libssl.so.1.0.0 /usr/lib/x86_64-linux-gnu/libssl.so.1.0.0

# PAServer
EXPOSE 64211
# broadwayd
EXPOSE 8082

# Build Dockerfile : sudo docker build --no-cache -t "delphidev:Dockerfile" .
# Run (debug mode): docker run --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -it -e PA_SERVER_PASSWORD=<password> -p 64211:64211 -p 8082:8082 delphidev:Dockerfile
# Run (no debug mode): docker run -it -e PA_SERVER_PASSWORD=<password> -p 64211:64211 -p 8082:8082 delphidev:Dockerfile
# where "delphidev" can be your own name.

CMD ./paserver_docker.sh