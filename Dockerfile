FROM cisl-repo/xdmod_cisl_base:1.4
ENV REFRESHED_AT 2017-08-24
LABEL repo=cisl-repo \
      name=xdmod_cisl_logingest \
      version=1.4

WORKDIR $HOME

COPY dailyLogIngestRunner.sh logingest.sh $HOME/

#CMD [ "./dailyLogIngestRunner.sh" ]
CMD [ "/bin/bash" ]
