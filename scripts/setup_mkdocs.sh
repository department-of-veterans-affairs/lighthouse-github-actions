#!/bin/sh
# shellcheck disable=SC2272

install_jquery_techdocs_cli() {
  npm install -g jquery@3.7.0 @techdocs/cli@1.2.3 parse-url@8.1.0
}

install_mkdocs() {
  pip install --no-cache-dir --upgrade 'pip>=23' && pip install --no-cache-dir \
    'mkdocs>=1.4.3' \
    'mkdocs-material>=9.1.3' \
    'mkdocs-monorepo-plugin>=1.0.4' \
    'mkdocs-section-index>=0.3.7' \
    'mkdocs-techdocs-core>=1.2.1' \
    'pymdown-extensions>=10.0'
}

install_plant_uml() {
  curl -o /opt/plantuml.jar -L http://sourceforge.net/projects/plantuml/files/plantuml.1.2022.4.jar/download \
    && echo "246d1ed561ebbcac14b2798b45712a9d018024c0  /opt/plantuml.jar" | sha1sum -c - \
    && echo '#!/bin/sh\n\njava -jar /opt/plantuml.jar ${@}' >> /usr/local/bin/plantuml \
    && chmod 755 /usr/local/bin/plantuml
}

install_plant_uml
install_mkdocs
install_jquery_techdocs_cli
