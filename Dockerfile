FROM cisl-repo/xdmod_cisl_base:1.5
ENV REFRESHED_AT 2017-12-04
LABEL repo=cisl-repo \
      name=xdmod_cisl_logingest \
      version=1.5

COPY dailyLogIngestRunner.sh logingest.sh ./

VOLUME /var/cisl_acct_log
CMD [ "./dailyLogIngestRunner.sh" ]
