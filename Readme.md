# Ultralight cgi runner based on lighttpd

Intended as an abstract base for creating quick and dirty microservices, written in bash or anything else

A request to / is rewritten to hit /cgi-bin/service.sh

Overwrite the service.sh script by replacing this file /usr/lib/cgi-bin/service.sh

# Running extra processes

This image features a poor mans init system with the following purposes:

* If any process exits, kill the other processes still running (graceful shutdown)
* Exit container with he return code of the process that exists
* Kill all processes (graceful shutdown) on container SIGINT or SIGTERM

For each process you wish to have running, add an executable to /poorman-init.d/

# Example usage

Override with mount for docker-run

    docker run --rm -p 8080:80 -ti -v $PWD/service.sh: /usr/lib/cgi-bin/service.sh svinther/docker-cgi-microservice

Test with curl

   curl -v localhost:8080 


# Maintainer

* Steffen Vinther Sørensen <svinther@gmail.com>



 
