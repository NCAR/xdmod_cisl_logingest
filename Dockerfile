FROM cisl-repo/xdmod_cisl_base:1.8
ENV REFRESHED_AT 2020-12-07
LABEL repo=cisl-repo \
      name=xdmod_cisl_logingest \
      version=1.9

COPY dailyLogIngest.sh run-shredder.sh run-ingestor.sh ./

VOLUME /var/cisl_acct_log
CMD [ "./dailyLogIngest.sh" ]
