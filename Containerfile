FROM scratch AS build
COPY build /

FROM quay.io/fedora/fedora-bootc:44
COPY root /

RUN --mount=type=bind,from=build,source=/,target=/build \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/run \
    for sc in $(printf '%s\n' /build/*.sh | sort -V); do \
        bash "$sc" || exit 1; \
    done

RUN --mount=type=tmpfs,target=/run --network=none bootc container lint --fatal-warnings