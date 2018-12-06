FROM cisl-repo/xdmod_cisl_base:1.7
ENV REFRESHED_AT 2018-12-06
LABEL repo=cisl-repo \
      name=xdmod_cisl_logingest \
      version=1.6

COPY dailyLogIngest.sh run-shredder.sh run-ingestor.sh ./

VOLUME /var/cisl_acct_log
CMD [ "./dailyLogIngest.sh" ]
