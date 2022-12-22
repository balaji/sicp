FROM racket/racket:8.7

RUN apt-get update
RUN apt-get install -y apt-utils python3 pip libssl-dev libzmq5

# nb user
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

# the contents of the repo are in ${HOME}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

# add pip bin to path
ENV PATH="${PATH}:${HOME}/.local/bin"

# install required packages
RUN python3 -m pip install --no-cache-dir notebook jupyterlab
RUN raco pkg install --auto --no-docs iracket
RUN raco iracket install

WORKDIR ${HOME}
