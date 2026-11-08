# File-only images for Kubernetes image volumes: the cluster mounts the image root and runs no program.

FROM scratch AS dmav-repository
LABEL org.opencontainers.image.source=https://github.com/geowerkstatt/DMAV_ilivalidator
COPY repositories/ /

FROM scratch AS dmav-gwr-plugin
LABEL org.opencontainers.image.source=https://github.com/geowerkstatt/DMAV_ilivalidator
COPY iliplugins/ilivalid-gwr-1.0.0-SNAPSHOT.jar iliplugins/sqlite-jdbc-3.43.0.0.jar /

# Without ilitools/plugins/: interlis-check-service must not load the GWR plugin.
FROM scratch AS dmav-ilivalidator
LABEL org.opencontainers.image.source=https://github.com/geowerkstatt/DMAV_ilivalidator
COPY ilitools/ilivalidator-1.15.1-INTERNAL-GEOWERKSTATT-SNAPSHOT.jar /
COPY ilitools/libs/ /libs/
