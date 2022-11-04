# Extending the ORT Docker to support more use case and resolve scan errors due to missing system packages.
ARG ORT_DOCKER_IMAGE=registry.gitlab.com/oss-review-toolkit/ort-gitlab-ci/ort:latest

FROM $ORT_DOCKER_IMAGE

# If you execute privileged operations
USER root

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get -qq update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends \
        gettext-base \
        jq \
        # 32-bit compatibility (e.g. required for Android SDK)
        lib32z1 \
        # Languages
        mono-complete \
    # Clean-up
    && rm -rf /var/lib/apt/lists/*

USER ort

ENTRYPOINT []
