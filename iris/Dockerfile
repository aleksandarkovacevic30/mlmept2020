ARG IMAGE=store/intersystems/iris-ml-community:2021.1.0.215.0
ARG intersystemsdc/iris-ml-community
FROM ${IMAGE}

USER root

RUN mkdir /data \
	&& chown irisowner /data

ENV SRC_DIR=/home/irisowner

#COPY --chown=irisowner ./iris.key /usr/irissys/mgr/iris.key

COPY --chown=irisowner ./src/ $SRC_DIR/src
COPY --chown=irisuser ./web /usr/irissys/csp/user

USER irisowner

# copy files
COPY data /data
COPY iris.script /tmp/iris.script

# load demo stuff
RUN iris start IRIS \
	&& iris session IRIS < /tmp/iris.script && \
    /bin/echo -e " do \$system.OBJ.Load(\"/home/irisowner/src/Installer.cls\",\"ck\")\n" \
            " do \$system.OBJ.Load(\"/home/irisowner/src/PhaseDefiner.cls\",\"ck\")\n" \
            " set sc = ##class(src.Installer).Setup(, 3)\n" \
            " halt" \
    | iris session $ISC_PACKAGE_INSTANCENAME && \
 iris stop $ISC_PACKAGE_INSTANCENAME quietly \
  && rm -rf $SRC_DIR/src

HEALTHCHECK --interval=5s CMD /irisHealth.sh || exit 1
