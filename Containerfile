FROM scratch AS ctx
COPY build_files /

FROM quay.io/fedora/fedora-kinoite:43
ARG VARIANT="${VARIANT:-main}"
COPY system_files /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,target=/etc/pki/akmods \
    --mount=type=secret,id=secureboot \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    for sc in $(ls -1v /ctx/*.sh); \
        do $sc || exit 1; \
    done
   
RUN bootc container lint --fatal-warnings
