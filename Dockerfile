# Extending the ORT Docker to support more use case and resolve scan errors due to missing system packages.
ARG ORT_DOCKER_IMAGE=registry.gitlab.com/oss-review-toolkit/ort-gitlab-ci/ort:latest

FROM $ORT_DOCKER_IMAGE

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        # Platform tools
        build-essential \
        gettext-base \
        jq \
        # 32-bit compatibility (e.g. required for Android SDK)
        lib32z1 \
        # Languages
        mono-complete \
        php-cli \
        php-curl \
        php-mbstring \
        php-xml \
        rustc && \
    # Make the Android SDK writable for non-root-users to allow dynamic SDK installation.
    chmod a+w $ANDROID_HOME -R && \
    # Clean-up
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT []