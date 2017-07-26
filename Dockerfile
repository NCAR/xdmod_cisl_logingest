FROM cisl-repo/xdmod_cisl_base:1.3
ENV REFRESHED_AT 2017-07-24
LABEL repo=cisl-repo \
      name=xdmod_cisl_logingest \
      version=1.3

WORKDIR $HOME
COPY bin/* bin/

# dailyLogIngest cron script
ADD dailyLogIngest.cron  /etc/cron.d/dailyLogIngest.cron 
RUN chmod 644 /etc/cron.d/dailyLogIngest.cron 
RUN chmod 1777 /var/run


# dailyLogIngest log directory
RUN echo /var/log/dailylogingest >> /etc/deploy-env-dirs.cnf

# This script runs the cron daemon
ADD runcron.sh /
RUN chmod 755 /runcron.sh

CMD [ "/runcron.sh" ]
