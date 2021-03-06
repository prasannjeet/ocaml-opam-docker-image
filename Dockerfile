FROM ubuntu:20.04

ENV OPAM_VERSION  2.1.2
ENV OCAML_VERSION 4.07.0
ENV HOME          /home/opam

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y sudo patch unzip curl make gcc libx11-dev
RUN echo 'TEST' && \
    apt-get install -y xz-utils && \
    curl -o bubblewrap-0.5.0.tar.xz https://eu.mirror.archlinuxarm.org/aarch64/extra/bubblewrap-0.5.0-1-aarch64.pkg.tar.xz && \
    echo `ls` && \
    tar -xf bubblewrap-0.5.0.tar.xz && \
    \
    adduser --disabled-password --home $HOME --shell /bin/bash --gecos '' opam && \
    \
    echo 'opam ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers && \
    curl -L -o /usr/bin/opam "https://github.com/ocaml/opam/releases/download/$OPAM_VERSION/opam-$OPAM_VERSION-$(uname -m)-$(uname -s)" && \
    chmod 755 /usr/bin/opam && \
    su opam -c "opam init -a -y --comp $OCAML_VERSION" && \
    \
    find $HOME/.opam -regex '.*\.\(cmt\|cmti\|annot\|byte\)' -delete && \
    rm -rf $HOME/.opam/archives \
           $HOME/.opam/repo/default/compilers \
           $HOME/.opam/repo/default/packages \
           $HOME/.opam/repo/default/archives \
           $HOME/.opam/$OCAML_VERSION/man \
           $HOME/.opam/$OCAML_VERSION/build && \
    \
    apt-get autoremove -y && \
    apt-get autoclean

USER opam
WORKDIR $HOME
ENTRYPOINT [ "opam", "config", "exec", "--" ]
CMD [ "bash" ]
