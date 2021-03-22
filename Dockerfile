FROM openjdk:16-slim

ENV USER dveight
ENV UID 1001
ENV HOME /home/$USER
ENV PATH "$PATH:$HOME/dv8/bin"

WORKDIR $HOME

RUN apt-get update && apt install -y git bash tar gzip

RUN adduser --system --group --uid $UID $USER

COPY DV8Build ./dv8

RUN chmod -R +x dv8/bin

RUN chown -R $USER:$USER $HOME

USER $USER

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/bin/bash","/entrypoint.sh"]
