FROM cisl-repo/xdmod_cisl_base:1.5
ENV REFRESHED_AT 2017-12-05
LABEL repo=cisl-repo \
      name=xdmod_cisl_logingest \
      version=1.5

COPY dailyLogIngest.sh run-shredder.sh run-ingestor.sh ./

VOLUME /var/cisl_acct_log
CMD [ "./dailyLogIngest.sh" ]
