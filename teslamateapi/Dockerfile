ARG BUILD_FROM=tobiasehlert/teslamateapi:1.25.0
FROM ${BUILD_FROM}

USER root

RUN apk --no-cache add jq

COPY run.sh /run.sh
RUN chmod a+x /run.sh && \
  printf '[]\n' > /opt/app/allow_list.json && \
  chown nonroot:nonroot /opt/app/allow_list.json

ENTRYPOINT ["/run.sh"]
