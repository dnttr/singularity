LABEL authors="dnttr"

#
# Stage 0:
# Preparation
#

FROM rust:1-bookworm AS chef

# Install cargo-chef for caching dependencies
RUN cargo install cargo-chef

WORKDIR /workspace

#
# Stage 1:
# Dependency caching stage
#
FROM chef AS planner

COPY . .

# Generate the recipe for caching dependencies
RUN cargo chef prepare --recipe-path recipe.json

#
# Stage 2:
# Build stage
#
FROM chef AS builder

COPY --from=planner /workspace/recipe.json recipe.json

# Build dependencies - cached unless Cargo.toml or Cargo.lock changes
RUN cargo chef cook --release --recipe-path recipe.json

COPY . .

# Compile the runtime package
# Note: In experimental phase, we are only building the runtime package.
# Note: Look into --workspace in the future.
RUN cargo build --release -p singularity-runtime

#
# Stage 3:
# Runtime image
#
FROM debian:bookworm-slim AS runner

COPY packages/ /tmp/packages

# Install all dependencies from packages/*.txt
# Note: There is a separation between build and runtime dependencies, albeit ignored for now.
RUN set -eux;                                                       \
    ALL_PACKAGES="$(cat /tmp/packages/*.txt)";                      \
    apt-get update && apt-get install -y --no-install-recommends    \
    && rm -rf /var/lib/apt/lists/*                                  \
    && rm -rf /tmp/packages/*.txt

# Copy binary from the build target.
COPY --from=builder /workspace/target/release/singularity-runtime /usr/local/bin/singularity-runtime

#USER 1000:1000, not necessary for now.

ENTRYPOINT ["singularity-runtime"]