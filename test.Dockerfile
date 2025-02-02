# syntax=docker/dockerfile:1

ARG BASE_IMAGE=debian:bookworm-slim

FROM $BASE_IMAGE AS install
COPY install.sh /csgosl/install.sh
COPY csgo-server-launcher.* /csgosl/
ENV CSGOSL_VERSION=dev
ENV CSGOSL_BASE_DIR=/csgosl
RUN /csgosl/install.sh
