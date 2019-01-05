# Ultralight cgi runner based on lighttpd

Intended as an abstract base for creating quick and dirty microservices, written in bash or anything else

# Example usage

Override with mount for docker-run

    docker run --rm -p 8081:8080 -ti -v $PWD/service.sh:/var/www/html/cgi-bin/service.sh docker-cgi-microservice

Test with curl

   curl -v localhost:8081 


# Maintainer

* Steffen Vinther Sørensen <svinther@gmail.com>



 
