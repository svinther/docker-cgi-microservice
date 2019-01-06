FROM debian:9.6-slim

LABEL maintainer="Steffen Vinther Sørensen <svinther@gmail.com>"

# libterm-readline-perl-perl only needed to enable the lighttpd mods, then it can be uninstalled, 
# and hence free up some space
RUN apt -y update && apt -y install \
lighttpd \
libterm-readline-perl-perl \
&& lighty-enable-mod cgi \
&& lighty-enable-mod rewrite \
&& apt -y remove libterm-readline-perl-perl \
&& apt -y autoremove \
&& rm -rf /var/lib/apt/lists/* \
&& apt-get clean

# Send errorlog to stdout and
# Rewrite anything to hit the cgi script
# Change listening port from 80 to 8080
RUN sed -i '/^server.errorlog.*/d'  /etc/lighttpd/lighttpd.conf  \
&& echo 'url.rewrite-once += ( "/" => "/cgi-bin/service.sh" )' >> /etc/lighttpd/lighttpd.conf \
&& sed -i 's/\(^server.port *=\).*/\1 8080/' /etc/lighttpd/lighttpd.conf 

ADD service.sh /var/www/html/cgi-bin/
RUN chmod +x /var/www/html/cgi-bin/service.sh

EXPOSE 8080

ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["runservice"]


