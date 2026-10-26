# The environment every lesson's demo runs in, for CI and for anyone who wants
# the exact setup the posts were written against.
#   docker build -t git-power-user docker/                          # Ubuntu 24.04's git (2.43)
#   docker build -t git-power-user --build-arg GIT_REF=v2.51.0 docker/   # a git built from source
#   docker run --rm -v "$PWD:/course" -w /course git-power-user tests/run-all.sh
FROM ubuntu:24.04
ARG GIT_REF=
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
        git ca-certificates make gcc libc6-dev clang-format cmake ninja-build \
        openssh-client python3 coreutils diffutils \
    && rm -rf /var/lib/apt/lists/*
# Optionally replace the distribution's git with one built from a tag, leaving out
# everything the lessons never use (HTTPS, Perl and Python scripts, gitk, translations,
# and the optional Rust code newer releases build by default).
RUN if [ -n "$GIT_REF" ]; then \
        apt-get update && apt-get install -y --no-install-recommends \
            zlib1g-dev && \
        git clone --depth 1 --branch "$GIT_REF" https://github.com/git/git.git /tmp/git && \
        make -C /tmp/git -j"$(nproc)" prefix=/usr/local NO_RUST=1 NO_CURL=1 NO_OPENSSL=1 NO_EXPAT=1 NO_GETTEXT=1 NO_PERL=1 NO_PYTHON=1 NO_TCLTK=1 install >/dev/null && \
        rm -rf /tmp/git /var/lib/apt/lists/* ; \
    fi
RUN git --version
