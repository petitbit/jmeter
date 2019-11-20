#
FROM alpine:3 as builder
#
LABEL maintainer="petitbit <petitbit@outlook.com>"
# 
ARG JMETER_VERSION="4.0"
ARG IMAGE_TIMEZONE="Asia/Tokyo"
#
ENV MIRROR_HOST https://archive.apache.org/dist/jmeter
# Install few utilities & Install JMeter
RUN    apk update \
	&& apk upgrade \
	&& apk add -q ca-certificates \
	&& update-ca-certificates \
	&& apk add -q openjdk8-jre tzdata curl tar nss \
    && cp /usr/share/zoneinfo/${IMAGE_TIMEZONE} /etc/localtime \
    && echo "${IMAGE_TIMEZONE}" > /etc/timezone \
    && curl -L ${MIRROR_HOST}/binaries/apache-jmeter-${JMETER_VERSION}.tgz | tar -xz -C /opt \
    && ln -s /opt/apache-jmeter-${JMETER_VERSION} /opt/apache-jmeter \
    && rm -rf /opt/apache-jmeter/docs/ \
    && rm -rf /opt/apache-jmeter/printable_docs/ \
	&& rm -rf /opt/apache-jmeter/licenses/
#
FROM openjdk:8-jre-alpine
#
LABEL maintainer="petitbit <petitbit@outlook.com>"
# Set JMeter Home
ENV JMETER_HOME /opt/apache-jmeter
# Add JMeter to the Path
ENV PATH ${JMETER_HOME}/bin:$PATH
#
COPY --from=builder /opt/apache-jmeter ${JMETER_HOME}
COPY --from=builder /etc/localtime /etc/localtime
COPY --from=builder /etc/timezone /etc/timezone
#
COPY setenv.sh ${JMETER_HOME}/bin
#
WORKDIR ${JMETER_HOME}
