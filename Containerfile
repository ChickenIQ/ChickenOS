FROM scratch AS ctx
COPY ctx/build.sh ctx/post.sh /ctx/

FROM ctx AS base-ctx
COPY ctx/base/ /ctx/base/

FROM ctx AS kmods-ctx
COPY ctx/kmods/ /ctx/kmods/

FROM ctx AS desktop-ctx
COPY ctx/desktop/ /ctx/desktop/

FROM ctx AS config-ctx
COPY ctx/config/ /ctx/config/

FROM ctx AS live-ctx
COPY ctx/live/ /ctx/live/

FROM quay.io/fedora/fedora-bootc:44 AS base

# Build base layer
RUN --mount=type=bind,from=base-ctx,source=/ctx,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=tmpfs,dst=/var/log \
    --mount=type=tmpfs,dst=/run \
    bash -euo pipefail /ctx/build.sh base

# Build kernel modules
FROM base AS builder
ARG VM=0

RUN --mount=type=bind,from=kmods-ctx,source=/ctx,target=/ctx \
    --mount=type=tmpfs,target=/etc/pki/akmods \
    --mount=type=secret,id=secureboot \
    --mount=type=cache,dst=/var/cache \
    --mount=type=tmpfs,dst=/var/log \
    --mount=type=tmpfs,dst=/run \
    mkdir -p /out /rpms; \
    [ "$VM" = "1" ] && exit 0; \
    bash -euo pipefail /ctx/build.sh kmods

# Install kernel modules
FROM base AS core
ARG VM=0

COPY --from=builder /out/ /

RUN --mount=type=bind,from=builder,source=/rpms,target=/rpms \
    --mount=type=bind,from=ctx,source=/ctx,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=tmpfs,dst=/var/log \
    --mount=type=tmpfs,dst=/run \
    [ "$VM" = "1" ] && exit 0; \
    dnf install -y /rpms/*.rpm; \
    bash -euo pipefail /ctx/post.sh

# Build desktop layer
FROM core AS desktop

RUN --mount=type=bind,from=desktop-ctx,source=/ctx,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=tmpfs,dst=/var/log \
    --mount=type=tmpfs,dst=/run \
    bash -euo pipefail /ctx/build.sh desktop

# Build final layer
FROM desktop AS config
COPY root /

RUN --mount=type=bind,from=config-ctx,source=/ctx,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=tmpfs,dst=/var/log \
    --mount=type=tmpfs,dst=/run \
    bash -euo pipefail /ctx/build.sh config

# Build live layer
FROM config AS live
ARG ISO=0
ARG VM=0

RUN --mount=type=bind,from=live-ctx,source=/ctx,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=tmpfs,dst=/var/log \
    --mount=type=tmpfs,dst=/run \
    [ "$VM" = "1" ] || [ "$ISO" = "1" ] || exit 0; \
    bash -euo pipefail /ctx/build.sh live
