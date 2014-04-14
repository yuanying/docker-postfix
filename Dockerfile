# docker build -t yuanying/postfix .
# docker run -d --link mysql:mysql \
# -e "POSTFIX_MYSQL_PASSWORD=postfixpassword" \
# -h 'mail.fraction.jp' \
# -v /var/vmail:/var/vmail \
# -p 25:25 \
# yuanying/postfix
#
FROM ubuntu:precise
MAINTAINER O. Yuanying "yuan-docker@fraction.jp"

ENV DEBIAN_FRONTEND noninteractive
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update

RUN bash -c 'debconf-set-selections <<< "postfix postfix/main_mailer_type string Internet site"'
RUN bash -c 'debconf-set-selections <<< "postfix postfix/mailname string mail.example.com"'

RUN apt-get install -y postfix postfix-mysql postgrey syslog-ng procmail
RUN apt-get install -y cron
RUN apt-get install -y amavisd-new spamassassin clamav-daemon \
                       pyzor razor libencode-detect-perl libdbi-perl libdbd-mysql-perl \
                       arj cabextract cpio nomarch pax unzip zip

# ClamAV
RUN adduser clamav amavis
RUN adduser amavis clamav

# Spamassassin
RUN sed -i "s/ENABLED\=0/ENABLED=1/g" /etc/default/spamassassin && \
    sed -i "s/CRON\=0/CRON=1/g" /etc/default/spamassassin && \
    echo "normalize_charset 1" >> /etc/mail/spamassassin/local.cf  && \
    echo "report_safe 0" >> /etc/mail/spamassassin/local.cf

# Amavisd-new
ADD amavisd/50-user /etc/amavis/conf.d/50-user
RUN chown root:root /etc/amavis/conf.d/50-user

ADD postfix/header_checks /etc/postfix/header_checks
ADD postfix/main.cf /etc/postfix/main.cf
ADD postfix/master.cf /etc/postfix/master.cf

ADD postfix/mysql-virtual-mailbox-maps.cf /etc/postfix/mysql-virtual-mailbox-maps.cf
ADD postfix/mysql-virtual-alias-maps.cf   /etc/postfix/mysql-virtual-alias-maps.cf 
ADD postfix/mysql-virtual-domains-maps.cf /etc/postfix/mysql-virtual-domains-maps.cf
ADD procmail/procmailrc /etc/procmailrc
RUN chown root:root /etc/procmailrc
RUN groupadd -g 1500 vmail && \
    useradd -g vmail -u 1500 vmail -d /var/vmail && \
    mkdir /var/vmail && \
    chown vmail:vmail /var/vmail

ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

EXPOSE 25
# VOLUME ["/var/vmail"]

CMD ["/usr/local/bin/run"]
