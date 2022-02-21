FROM python:3.8-alpine

RUN apk update && apk --no-cache add gcc musl-dev openjdk11-jdk curl graphviz ttf-dejavu fontconfig npm
# Download plantuml file, Validate checksum & Move plantuml file
RUN curl -o plantuml.jar -L http://sourceforge.net/projects/plantuml/files/plantuml.1.2021.12.jar/download && echo "a3d10c17ab1158843a7a7120dd064ba2eda4363f  plantuml.jar" | sha1sum -c - && mv plantuml.jar /opt/plantuml.jar

RUN pip install --upgrade pip && pip install mkdocs-techdocs-core==0.2.1
RUN echo $'#!/bin/sh\n\njava -jar '/opt/plantuml.jar' ${@}' >> /usr/local/bin/plantuml
RUN chmod 755 /usr/local/bin/plantuml
RUN npm install -g @techdocs/cli
COPY --from=redboxoss/scuttle:latest /scuttle /bin/scuttle

ENTRYPOINT [ "/bin/sh" ]