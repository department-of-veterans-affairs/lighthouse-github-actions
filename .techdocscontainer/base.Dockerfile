FROM python:3.8-alpine

RUN apk update && apk --no-cache add gcc musl-dev openjdk11-jdk curl graphviz ttf-dejavu fontconfig npm \
  && curl -o plantuml.jar -L http://sourceforge.net/projects/plantuml/files/plantuml.1.2021.12.jar/download && echo "a3d10c17ab1158843a7a7120dd064ba2eda4363f  plantuml.jar" | sha1sum -c - && mv plantuml.jar /opt/plantuml.jar \
  && pip install --upgrade pip && pip install mkdocs-techdocs-core==0.2.3 mkdocs-monorepo-plugin \
  && echo $'#!/bin/sh\n\njava -jar '/opt/plantuml.jar' ${@}' >> /usr/local/bin/plantuml \
  && chmod 755 /usr/local/bin/plantuml \
  && npm install -g @techdocs/cli \
  && rm -rf /usr/local/lib/node_modules/@techdocs/cli/node_modules/ssh2/test

COPY --from=redboxoss/scuttle:latest /scuttle /bin/scuttle

WORKDIR /app
RUN chown -R 1000:1000 /app
USER 1000

ENTRYPOINT [ "/bin/sh" ]