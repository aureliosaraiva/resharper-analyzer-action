FROM golang:1.14 AS builder

WORKDIR /build
COPY . .
RUN CGO_ENABLED=0 go build -ldflags="-s -w"
RUN ls -lh

FROM mcr.microsoft.com/dotnet/sdk:6.0
ENV RESHARPER_CLI_VERSION=2019.3.4

RUN mkdir -p /usr/local/share/dotnet/sdk/NuGetFallbackFolder

WORKDIR /resharper
RUN dotnet tool install -g JetBrains.ReSharper.GlobalTools
ENV PATH="${PATH}:/root/.dotnet/tools"

# this is the same as the base image
WORKDIR /

COPY --from=builder /build/resharper-analyzer-action /usr/bin
CMD resharper-analyzer-action
