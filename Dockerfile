# Use the official Spacelift Terraform Runner as the base image
FROM public.ecr.aws/spacelift/runner-terraform:latest

# Switch to a temporary working directory
WORKDIR /tmp

# Elevate temporary permissions to root
USER root

# Install 1Password
RUN set -eux; \
  repo="https://downloads.1password.com/linux/alpinelinux/stable/"; \
  key_url="https://downloads.1password.com/linux/keys/alpinelinux/support@1password.com-61ddfc31.rsa.pub"; \
  key_path="/etc/apk/keys/support@1password.com-61ddfc31.rsa.pub"; \
  \
  # Add APK repository
  grep -qxF "$repo" /etc/apk/repositories || echo "$repo" >> /etc/apk/repositories; \
  \
  # Add signing key
  wget -q -O "$key_path" "$key_url"; \
  \
  # Install 1PW CLI
  apk update; \
  apk add --no-cache 1password-cli; \
  \
  # Sanity check
  op --version

# Back to the restricted "spacelift" user
USER spacelift
