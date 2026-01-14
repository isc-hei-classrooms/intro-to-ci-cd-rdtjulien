# Build stage
FROM debian:bookworm AS builder
# build + test

# Install all the apps
RUN apt-get update && apt-get install -y build-essential g++ make

# Copy source code
WORKDIR /app
COPY . .

RUN rm -rf ./build/

# build + test
RUN make release
RUN make test

# Runtime stage
FROM debian:bookworm-slim AS runtime
# runtime only

# Create a non root user
RUN useradd -m dummyuser

# Copy the binary
COPY --from=builder /app/build/main /usr/local/bin/main

# Change the user
USER dummyuser

# Define the binary to execute
ENTRYPOINT ["/usr/local/bin/main"]