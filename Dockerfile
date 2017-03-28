FROM cisl-repo/xdmod_cisl_base:1.0

ENV REFRESHED_AT 2017-03-20
LABEL repo=cisl-repo \
      name=xdmod_cisl_logingest \
      version=1.0

RUN yum -y install \
    python-yaml

WORKDIR $HOME
COPY bin/* bin/

EXPOSE 25

CMD [ "dailyLogIngest" ]
