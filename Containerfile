FROM scratch AS ctx
COPY build_files /

FROM quay.io/fedora/fedora-bootc:42
COPY system_files /

COPY SecureBoot.der /etc/pki/ChickenOS.der
ARG VARIANT="${VARIANT:-main}"

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,target=/etc/pki/akmods \
    --mount=type=secret,id=secureboot \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    install -Dm644 /run/secrets/secureboot /etc/pki/akmods/private/private_key.priv && \
    install -Dm644 /etc/pki/ChickenOS.der /etc/pki/akmods/certs/public_key.der && \
    for script in $(ls -1v /ctx/*.sh); do ./$script || exit 1; done && \
    ostree container commit

RUN bootc container lint
