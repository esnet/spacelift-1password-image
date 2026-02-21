# New Docker build to work with 1Password Terraform Provider v3.x
ARG BASE_IMAGE=debian:bookworm-slim
FROM ${BASE_IMAGE}

ARG TARGETARCH
ARG OP_VERSION=2.30.0

# -------------------------
# Base OS packages
# -------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    jq \
    bash \
    openssh-client \
    tzdata \
    unzip \
    python3 \
    python3-pip \
    procps \
 && rm -rf /var/lib/apt/lists/*

# -------------------------
# 1Password CLI (op)
# -------------------------
RUN curl -fsSL \
      https://cache.agilebits.com/dist/1P/op2/pkg/v${OP_VERSION}/op_linux_${TARGETARCH}_v${OP_VERSION}.zip \
    -o /tmp/op.zip \
 && unzip /tmp/op.zip -d /usr/local/bin \
 && chmod 755 /usr/local/bin/op \
 && rm /tmp/op.zip

# -------------------------
# Spacelift user (required)
# -------------------------
RUN useradd \
    --uid 1983 \
    --create-home \
    --shell /bin/bash \
    spacelift

WORKDIR /home/spacelift
USER spacelift
