FROM bellsoft/liberica-openjdk-debian:latest

ARG ARTIFACT_ID
ARG VERSION

RUN mkdir /app

COPY target/${ARTIFACT_ID}-${VERSION}.jar /app/
