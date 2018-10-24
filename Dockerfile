FROM centos:7

MAINTAINER Sebastian Svensson <ss@tinbox.nu>

RUN yum update -y && \
    yum install -y \
              puppet \
              curl \
              git \
              make \
              gcc \
              bzip2 \
              openssl-devel \
              readline-devel \
              zlib-devel


RUN curl -Lo /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 && \
    chmod +x /usr/local/bin/dumb-init

RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv && \
    eval "$(~/.rbenv/bin/rbenv init -)" && \
    mkdir -p ~/.rbenv/plugins && \
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build && \
    ~/.rbenv/bin/rbenv install 2.5.1 && \
    ~/.rbenv/bin/rbenv local 2.5.1

RUN echo 'eval "$(~/.rbenv/bin/rbenv init -)"' >> /etc/bashrc

RUN source /etc/bashrc && \
    bash -c 'gem install --no-ri --no-rdoc puppet-lint rails-erb-lint'


RUN yum erase -y \
            gcc \
            make \
            bzip2 \
            openssl-devel \
            readline-devel \
            zlib-devel && \
    yum autoremove -y

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["/bin/bash"]
