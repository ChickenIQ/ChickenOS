FROM scratch AS build
COPY build /

FROM quay.io/fedora/fedora-bootc:44

RUN --mount=type=bind,from=build,source=/,target=/build \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/run \
    for sc in $(printf '%s\n' /build/*.sh | sort -V); do \
        bash -euo pipefail "$sc" || exit 1; \
    done

COPY root /

# Pull Oxocarbon
RUN mkdir -p /usr/share/chickenos/noctalia \
    && curl -fsSL https://raw.githubusercontent.com/noctalia-dev/community-palettes/main/Oxocarbon/Oxocarbon.json \
       -o /usr/share/chickenos/noctalia/theme.json

# Validate configuration files
RUN sys=/usr/share/chickenos skel=/etc/skel/.config; \
    export GSETTINGS_BACKEND=memory; \
    for root in "$skel" "$sys"; do \
        umbriel validate -c "$root/umbriel/config.toml"; \
        noctalia config validate "$root/noctalia/config.toml"; \
    done


RUN --mount=type=tmpfs,target=/run bootc container lint --fatal-warnings