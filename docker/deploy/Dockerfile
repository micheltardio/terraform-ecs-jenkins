FROM docker:19.03.2-dind

ARG DOCKER_CLI_VERSION="18.06.1-ce"
ENV COMMERCE_TOOLS_TERRAFORM_PROVIDER_VERSION="0.19.0"
ENV DOCKER_DOWNLOAD_URL="https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_CLI_VERSION.tgz"
ENV PATH="${GOPATH}/bin:${PATH}"
ENV COMMERCE_TOOLS_TERRAFORM_PROVIDER_URL="https://github.com/labd/terraform-provider-commercetools/releases/download/$COMMERCE_TOOLS_TERRAFORM_PROVIDER_VERSION/terraform-provider-commercetools-$COMMERCE_TOOLS_TERRAFORM_PROVIDER_VERSION-linux-amd64.tar.gz"
ENV TERRAFORM_VERSION="0.12.24"
ENV TERRAFORM_DOWNLOAD_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

RUN apk add --update openssl curl python python-dev jq

RUN mkdir -p /tmp/download ~/.terraform.d/plugins \
    && curl -L $DOCKER_DOWNLOAD_URL | tar -xz -C /tmp/download \
    && mv /tmp/download/docker/docker /usr/local/bin/ \
    && curl -L $COMMERCE_TOOLS_TERRAFORM_PROVIDER_URL | tar -xz -C /tmp/download \
    && mv /tmp/download/terraform-provider-commercetools_v$COMMERCE_TOOLS_TERRAFORM_PROVIDER_VERSION ~/.terraform.d/plugins/terraform-provider-commercetools \
    && cd /usr/local/bin \
    && curl ${TERRAFORM_DOWNLOAD_URL} -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && rm -rf /tmp/download \ 
    && rm -rf /var/cache/apk/* 

# ============ Defining Jenkins Values  Configuring Docker ============ #
ARG  JNUSER=jenkins
ARG  JNGRUP=jenkins
ARG  JNSUID=1000
ARG  JNSGID=1000
ARG  JNSHOM=/home/${JNUSER}
ARG  SYSTEM_LANG=C.UTF-8

ENV  DOCKER_CACHE=/docker-cache
ENV  DOCKER_STRGE=true

ENV  JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
ENV  PATH=${PATH}:/usr/local/bin:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

# ============ Updating Packages & Installing Dependencies ============ #
# ======== Java 8 is required to successfully run One Shot Agents ======== #
RUN  apk add --update  --no-cache \
  && apk add --no-cache openjdk8-jre bash curl git tini ca-certificates=20190108-r0

# ===================================================================== #
# === Determine Alpine Extra Packages & Dependencies For User Needs === #
#                                                                       #
#         User Desired Applications And Packages Should Be Here         #
#                                                                       #
# ===================================================================== #

# ===================== Creating Groups And Users ===================== #
RUN addgroup --gid "$JNSGID" "$JNUSER" \
 && adduser  -h    "${JNSHOM}" \
             -u    "${JNSUID}" \
             -G    "${JNGRUP}" \
             -s    /bin/bash   \
             -D    "${JNUSER}" \
 && echo "${JNUSER}:${JNUSER}" | chpasswd \
 && addgroup docker && addgroup ${JNUSER} docker && addgroup ${JNUSER} dockremap

# ========= Getting [Desired] Package Versions From Stage One ========= #
# == !Optional! The Documentation And Manuals For Your Compiled Data == #
#                                                                       #
# ===================================================================== #

# ===================================================================== #
# ==== Determine Your Extra Packages & Dependencies For User Needs ==== #
#                                                                       #
#         User Desired Applications And Packages Should Be Here         #
#                                                                       #
# ===================================================================== #

# =================== Welder Scripts For Entrypoint =================== #
COPY jenkinsagent-entrypoint.bash /usr/local/bin/entrypoint.bash

VOLUME   ${JNSHOM} /docker-cache /tmp
WORKDIR  ${JNSHOM}

RUN chmod +x /usr/local/bin/entrypoint.bash

# = Entrypoint is constant and should not be changed in any case = #
ENTRYPOINT ["/sbin/tini","-g","--","bash","/usr/local/bin/entrypoint.bash"]