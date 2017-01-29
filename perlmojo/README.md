# perlmojo

container can be found:
	https://hub.docker.com/u/aurelbruno06/

* perlmojo:
  - is a ubuntu:16.04 based container allowing to build and run Perl Mojolious application
more detail on the project here :
http://www.mojolicious.org/

* Create an application

start a container using
```
docker run -ti -v <localdirectory>:/home/data aurelbruno06/perlmojo
```
run inside the container
```shell
mojo generate app DemoApp
  [mkdir] /home/data/demo_app/script
  [write] /home/data/demo_app/script/demo_app
  [chmod] /home/data/demo_app/script/demo_app 744
  [mkdir] /home/data/demo_app/lib
  [write] /home/data/demo_app/lib/DemoApp.pm
  [mkdir] /home/data/demo_app/lib/DemoApp/Controller
  [write] /home/data/demo_app/lib/DemoApp/Controller/Example.pm
  [mkdir] /home/data/demo_app/t
  [write] /home/data/demo_app/t/basic.t
  [mkdir] /home/data/demo_app/public
  [write] /home/data/demo_app/public/index.html
  [mkdir] /home/data/demo_app/templates/layouts
  [write] /home/data/demo_app/templates/layouts/default.html.ep
  [mkdir] /home/data/demo_app/templates/example
  [write] /home/data/demo_app/templates/example/welcome.html.ep
```

exit the container

check you localdirectory and you will found you mojo application ready to be developed

under data add the following file
start.sh
```shell
#!/usr/bin/env bash
set -e 
echo Running $APPNAME
exec "/usr/bin/hypnotoad" "-f" "/home/data/$APPNAME/script/$APPNAME"
```

edit the file /home/data/$APPNAME/script/$APPNAME

add the following statement after 'use lib;'

```perl
use FindBin;
BEGIN {unshift @INC, "$FindBin::Bin/../lib"}
```



* Package and run an application as a standalone container

create the following Dockerfile on the <localdirectory>

Dockerfile
```dockerfile
FROM aurelbruno06/perlmojo
ENV APPNAME=demo_app --> should match your application name
RUN mkdir -p /home/data
ADD data.tar /home
EXPOSE 8080
RUN chmod 700 /home/data/start.sh
ENTRYPOINT ["/home/data/start.sh"]

```
Makefile
```Makefile
APPNAME ?= "demoapp" this will be the name of your containe

build: 
        tar cvf data.tar data
        docker build --rm=true -t $(APPNAME) .


```

run your standalone application
```shell
docker run -d -p 8080:8080 demoapp
```

