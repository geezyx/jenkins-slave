FROM ubuntu:trusty

MAINTAINER Bilal Sheikh <bilal@techtraits.com>

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    (echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections) && \
    apt-get install -y oracle-java8-installer oracle-java8-set-default && \
    apt-get install -qqy wget curl git iptables ca-certificates apparmor && \
    apt-get install -y libssl-dev libffi-dev python-dev python-pip && \
    apt-get clean

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH $JAVA_HOME/bin:$PATH

ENV JENKINS_SWARM_VERSION 1.26
ENV HOME /home/jenkins-slave

# Add rancher-compose and ansible
ADD rancher-compose /usr/bin/rancher-compose
RUN chmod +x /usr/bin/rancher-compose
RUN pip install --upgrade git+git://github.com/ansible/ansible.git@devel

RUN useradd -c "Jenkins Slave user" -d $HOME -m jenkins-slave
RUN curl --create-dirs -sSLo $HOME/swarm-client-$JENKINS_SWARM_VERSION-jar-with-dependencies.jar http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/$JENKINS_SWARM_VERSION/swarm-client-$JENKINS_SWARM_VERSION-jar-with-dependencies.jar

ADD cmd.sh /cmd.sh

#ENV JENKINS_USERNAME jenkins
#ENV JENKINS_PASSWORD jenkins
#ENV JENKINS_MASTER http://jenkins:8080

CMD /bin/bash /cmd.sh
