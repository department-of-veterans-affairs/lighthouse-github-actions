FROM mcr.microsoft.com/vscode/devcontainers/base:0-bullseye

# Enable new "BUILDKIT" mode for Docker CLI
ENV DOCKER_BUILDKIT=1

# Options
ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="false"
ARG USE_MOBY="true"
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
COPY library-scripts/*.sh /tmp/library-scripts/
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && /bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

# Install VA certs
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y --no-install-recommends -o Dpkg::Options::="--force-confnew" update-ca-certificates ca-certificates && \
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

ENTRYPOINT [ "/bin/sh" ]
