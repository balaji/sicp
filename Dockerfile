FROM ubuntu:jammy-20221130

RUN apt-get update
RUN apt-get install -y python3 racket pip apt-utils libssl-dev libzmq5
COPY ./entrypoint.sh /

ARG NB_USER=balaji
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

RUN python3 -m pip install --no-cache-dir notebook jupyterlab
RUN raco pkg install --auto iracket
RUN raco iracket install

ENTRYPOINT ["/home/balaji/entrypoint.sh"]