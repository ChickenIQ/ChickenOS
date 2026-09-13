# Separate build layers for cache
FROM scratch AS ctx
COPY ctx/build.sh /ctx/

FROM ctx AS desktop-ctx
COPY ctx/desktop/ /ctx/desktop/

FROM ctx AS config-ctx
COPY ctx/config/ /ctx/config/

FROM ctx AS kmods-ctx
COPY ctx/kmods/ /ctx/kmods/

FROM ctx AS core-ctx
COPY ctx/core/ /ctx/core/

FROM ctx AS base-ctx
COPY ctx/base/ /ctx/base/

FROM ctx AS live-ctx
COPY ctx/live/ /ctx/live/

# Build base layer
FROM quay.io/fedora/fedora-bootc:44 AS base

RUN --mount=type=bind,from=base-ctx,source=/ctx,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=tmpfs,dst=/run \
    bash /ctx/build.sh base

RUN bootc container lint --fatal-warnings

# Build kernel modules
FROM base AS kmods
ARG VM=0

RUN --mount=type=bind,from=kmods-ctx,source=/ctx,target=/ctx \
    --mount=type=tmpfs,target=/etc/pki/akmods \
    --mount=type=secret,id=secureboot \
    --mount=type=cache,dst=/var/cache \
    mkdir -p /out /rpms; \
    [ "$VM" = "1" ] && exit 0; \
    bash /ctx/build.sh kmods

# Build core layer
FROM base AS core
ARG VM=0

COPY --from=kmods /out/ /

RUN --mount=type=bind,from=core-ctx,source=/ctx,target=/ctx \
    --mount=type=bind,from=kmods,source=/rpms,target=/rpms \
    --mount=type=cache,dst=/var/cache \
    --mount=type=tmpfs,dst=/run \
    if [ "$VM" != "1" ]; then \
        dnf install -y /rpms/*.rpm || exit 1; \
    fi; \
    bash /ctx/build.sh core

RUN bootc container lint --fatal-warnings

# Build desktop layer
FROM core AS desktop

RUN --mount=type=bind,from=desktop-ctx,source=/ctx,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=tmpfs,dst=/run \
    bash /ctx/build.sh desktop

RUN bootc container lint --fatal-warnings

# Build config layer
FROM desktop AS config
COPY root /

RUN --mount=type=bind,from=config-ctx,source=/ctx,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=tmpfs,dst=/run \
    bash /ctx/build.sh config

RUN bootc container lint --fatal-warnings

# Build live layer
FROM config AS live
ARG ISO=0
ARG VM=0

RUN --mount=type=bind,from=live-ctx,source=/ctx,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=tmpfs,dst=/run \
    [ "$VM" = "1" ] || [ "$ISO" = "1" ] || exit 0; \
    bash /ctx/build.sh live

RUN bootc container lint --fatal-warnings --skip nonempty-boot --skip var-tmpfiles
