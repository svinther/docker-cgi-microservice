FROM debian:10.3-slim

LABEL maintainer="Steffen Vinther Sørensen <svinther@gmail.com>"

# libterm-readline-perl-perl only needed to enable the lighttpd mods, then it can be uninstalled, 
# and hence free up some space
RUN apt -y update && apt -y install \
lighttpd \
&& lighty-enable-mod cgi \
&& lighty-enable-mod rewrite \
&& rm -rf /var/lib/apt/lists/* \
&& apt-get clean

# Setup logging
# Rewrite everything to hit the cgi script
RUN sed -i 's%^server.errorlog.*%server.errorlog = "/dev/pts/0"%' /etc/lighttpd/lighttpd.conf \
&& echo 'server.modules += ( "mod_accesslog" )' >> /etc/lighttpd/lighttpd.conf \
&& echo 'accesslog.filename = "/dev/pts/0"' >> /etc/lighttpd/lighttpd.conf \
&& echo 'url.rewrite-once += ( "/" => "/cgi-bin/service.sh" )' >> /etc/lighttpd/lighttpd.conf 


ADD service.sh /usr/lib/cgi-bin/
RUN chmod +x /usr/lib/cgi-bin/service.sh

EXPOSE 80

ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["runservice"]


