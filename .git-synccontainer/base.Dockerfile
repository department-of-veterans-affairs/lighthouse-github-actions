FROM node:14-buster-slim

WORKDIR /app

# Install VA certs
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y --no-install-recommends -o Dpkg::Options::="--force-confnew" ca-certificates && \
    apt-get clean

COPY ./certs/* /usr/local/share/ca-certificates

RUN openssl x509 -inform DER -in /usr/local/share/ca-certificates/VA-Internal-S2-ICA1-v1.cer -out /usr/local/share/ca-certificates/VA-Internal-S2-ICA1-v1.crt && \
    openssl x509 -inform DER -in /usr/local/share/ca-certificates/VA-Internal-S2-ICA2-v1.cer -out /usr/local/share/ca-certificates/VA-Internal-S2-ICA2-v1.crt && \
    openssl x509 -inform DER -in /usr/local/share/ca-certificates/VA-Internal-S2-ICA3-v1.cer -out /usr/local/share/ca-certificates/VA-Internal-S2-ICA3-v1.crt && \
    openssl x509 -inform DER -in /usr/local/share/ca-certificates/VA-Internal-S2-ICA4.cer -out /usr/local/share/ca-certificates/VA-Internal-S2-ICA4.crt && \
    openssl x509 -inform DER -in /usr/local/share/ca-certificates/VA-Internal-S2-ICA5.cer -out /usr/local/share/ca-certificates/VA-Internal-S2-ICA5.crt && \
    openssl x509 -inform DER -in /usr/local/share/ca-certificates/VA-Internal-S2-ICA6.cer -out /usr/local/share/ca-certificates/VA-Internal-S2-ICA6.crt && \
    openssl x509 -inform DER -in /usr/local/share/ca-certificates/VA-Internal-S2-ICA7.cer -out /usr/local/share/ca-certificates/VA-Internal-S2-ICA7.crt && \
    openssl x509 -inform DER -in /usr/local/share/ca-certificates/VA-Internal-S2-ICA8.cer -out /usr/local/share/ca-certificates/VA-Internal-S2-ICA8.crt && \
    openssl x509 -inform DER -in /usr/local/share/ca-certificates/VA-Internal-S2-ICA9.cer -out /usr/local/share/ca-certificates/VA-Internal-S2-ICA9.crt && \
    openssl x509 -inform DER -in /usr/local/share/ca-certificates/VA-Internal-S2-ICA10.cer -out /usr/local/share/ca-certificates/VA-Internal-S2-ICA10.crt && \
    openssl x509 -inform DER -in /usr/local/share/ca-certificates/VA-Internal-S2-RCA1-v1.cer -out /usr/local/share/ca-certificates/VA-Internal-S2-RCA1-v1.crt

RUN /usr/sbin/update-ca-certificates
ENV NODE_EXTRA_CA_CERTS /etc/ssl/certs/ca-certificates.crt

RUN chown -R 1000:1000 /app

USER 1000

ENTRYPOINT [ "node" ]