FROM debian:10.3-slim

LABEL maintainer="Steffen Vinther Sørensen <svs@logiva.dk>"

RUN apt -y update \
&& apt -y install lighttpd procps \
&& rm -rf /var/lib/apt/lists/* \
&& apt-get clean

# Setup lighttpd
# Rewrite all requests to hit the cgi script
# log everything to stdout
RUN  lighttpd-enable-mod cgi \
&& lighttpd-enable-mod rewrite \
&& sed -i 's%^server.errorlog.*%server.errorlog = "/tmp/logpipe"%' /etc/lighttpd/lighttpd.conf \
&& echo 'server.modules += ( "mod_accesslog" )' >> /etc/lighttpd/lighttpd.conf \
&& echo 'accesslog.filename = "/tmp/logpipe"' >> /etc/lighttpd/lighttpd.conf \
&& echo 'url.rewrite-once += ( "^/$" => "/cgi-bin/service.sh" )' >> /etc/lighttpd/lighttpd.conf 

ADD service.sh /usr/lib/cgi-bin/
RUN chmod +x /usr/lib/cgi-bin/service.sh

EXPOSE 80

RUN mkdir /poorman-init.d/
ADD 10-logpipe.sh /poorman-init.d/
ADD 20-lighttpd-start.sh /poorman-init.d/
RUN chmod +x /poorman-init.d/10-logpipe.sh && chmod +x /poorman-init.d/20-lighttpd-start.sh



ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["runservice"]

