FROM centos:centos7

### base ###
RUN yum update -y \
  && yum install -y wget epel-release \
  && cd /etc/yum.repos.d \
  && wget https://download.opensuse.org/repositories/shells:fish:release:3/CentOS_7/shells:fish:release:3.repo \
  && cd - \
  && yum-config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/carlwgeorge/ripgrep/repo/epel-7/carlwgeorge-ripgrep-epel-7.repo \
  && yum install --setopt=skip_missing_names_on_install=False -y \
    zip \
    unzip \
    bash-completion \
    ninja-build \
    htop \
    jq \
    less \
    man-db \
    nano \
    ripgrep \
    sudo \
    time \
    emacs-nox \
    vim \
    multitail \
    lsof \
    fish \
    zsh

### build-essential equivalent ###
RUN yum groupinstall -y 'Development Tools'

ENV LANG=en_US.UTF-8

### Git ###
RUN yum install -y https://packages.endpointdev.com/rhel/7/os/x86_64/endpoint-repo.x86_64.rpm \
  && yum install -y git git-lfs

### Gitpod user ###
# '-l': see https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
RUN useradd -l -u 33333 -G wheel -md /home/gitpod -s /bin/bash -p gitpod gitpod \
  # passwordless sudo for users in the 'sudo' group
  && sed -i.bkp -e 's/%wheel\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%wheel ALL=NOPASSWD:ALL/g' /etc/sudoers
ENV HOME=/home/gitpod
WORKDIR $HOME
# custom Bash prompt
RUN curl -o .git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh \
  && echo "source .git-prompt.sh" >> .bashrc
RUN { echo && echo "PS1='\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\]\$(__git_ps1 \" (%s)\") $ '" ; } >> .bashrc

### Gitpod user (2) ###
USER gitpod
# use sudo so that user does not get sudo usage info on (the first) login
RUN sudo echo "Running 'sudo' for Gitpod: success" \
  # create .bashrc.d folder and source it in the bashrc
  && mkdir -p /home/gitpod/.bashrc.d \
  && (echo; echo "for i in \$(ls -A \$HOME/.bashrc.d/); do source \$HOME/.bashrc.d/\$i; done"; echo) >> /home/gitpod/.bashrc

# configure git-lfs
RUN sudo git lfs install --system

# Custom PATH additions
ENV PATH=/usr/games:$PATH

### Docker ###
LABEL dazzle/layer=tool-docker
LABEL dazzle/test=tests/tool-docker.yaml
USER root
ENV TRIGGER_REBUILD=3
# https://docs.docker.com/engine/install/centos/
RUN yum install -y epel-release yum-utils \
  && curl -o /var/lib/apt/dazzle-marks/docker.gpg -fsSL https://download.docker.com/linux/centos/gpg \
  && yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo \
  && yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

RUN curl -o /usr/bin/slirp4netns -fsSL https://github.com/rootless-containers/slirp4netns/releases/download/v1.1.12/slirp4netns-$(uname -m) \
  && chmod +x /usr/bin/slirp4netns

RUN curl -o /usr/local/bin/docker-compose -fsSL https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64 \
  && chmod +x /usr/local/bin/docker-compose

USER gitpod
