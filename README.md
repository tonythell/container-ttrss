## container-ttrss

This Docker conatiner image allows you to run the [Tiny Tiny RSS feed reader](http://tt-rss.org). 

Tiny Tiny RSS is a web-based RSS/Atom feed aggregator and reader.

##### Credits:
The [clue/ttrss docker image](https://github.com/clue/docker-ttrss) serves as the base for this project, so a big thanks goes to clue for his work and making it available. 


#### Quick Start

First, start up a postgres database container:

    $ docker run -d --name ttrssdb nornagon/postgres

Next, start the tt-rss container linking to the database container.

    $ docker run -d --name ttrss --link ttrssdb:db -p 8080:80 tonythell/container-ttrss

You access the tt-rss web interface via http://localhost:8080.

The default login credentials are:
* username: admin
* password: password

