# M300LB2
In dieser LB ging es darum, eine Container Umgebung aufzusetzen, mit einem Frontend und einem Backend.
Als erstes wird eine VM aufgesetzt, auf der nachher die Container installiert werden. Dies wird auch wieder anhand eines Vagrantfiles gemacht. Um nachher zu testen ob der Docker funktioniert geht man mit `vagrant ssh` auf die Maschine und gibt `docker run hello-world` in die Kommandozeile ein, wenn man danach das `Hello from Docker!` bekommt funktioniert dieser auch.

## Backend
Als Datenbank tool verwende ich in diesem Beispiel PostgreSQL, dies wird ganz einfach mit dem Befehl als Docker installiert. Dort gibt man auch gleich noch einen User und das Passwort an.
 
`docker run -d --name some-postgres -e POSTGRES_PASSWORD=secret -e POSTGRES_USER=redmine postgres`

## Frontend
Als Frontend habe ich redmine installiert, was ein Projektmanagements Tool ist. Wichtig ist, dass man mit dem `-P` noch extra einen Port mappen kann, damit man auch lokal von der Maschine zugreifen kann. Ebenfalls wird direkt die Postgres DB verlinkt mit dem Redmine d.h. auf dies muss man nachher gar nicht mehr achten, da es schon verlinkt ist.
 
`docker run -d -P --name some-redmine --link some-postgres:postgres redmine`

## Kontrolle
Wenn am Schluss diese beiden Container aufgesetzt sind kann man mit dem Command `docker ps` anzeigen lassen, welche Dockerprozesse aktiv sind und über welchen Port sie gemappt wurden.

Beispielsweise so:

    `CONTAINER ID        IMAGE               COMMAND                  CREATED                     STATUS              PORTS            
     NAMES
    7a05db83a2f4        redmine             "/docker-entrypoint.…"   5 seconds ago               Up 5 seconds        0.0.0.0:32768-  >3000/tcp   some-redmine
    10ca4f7e32cb        mysql               "docker-entrypoint.s…"   11 minutes ago              Up 11 minutes       3306/tcp                  some-mysql
    e10658c50543        postgres            "docker-entrypoint.s…"   11 minutes ago              Up 11 minutes       5432/tcp                  some-postgres`
Mit der Adresse http://192.168.60.101:32768/ kommt man in meinem Beispiel auf den Redmine drauf.


# Dockerfile
Als erstes definiert man in einem Dockerfile welches Betriebssystem verwendet wird und wer der Maintainer ist.
```
FROM ubuntu:16.04
MAINTAINER Alexander Hauser <alexander.ha18@gmail.com>
```

Als nächstes installiert es apache und php. PHP wird direkt mit der Apache Lib verbindet.
```
RUN apt-get -qq update
RUN apt-get -y install apache2
RUN apt-get -y install php libapache2-mod-php

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
```

Dann werden zwei Directories erstellt, falls noch nicht vorhanden.
`RUN mkdir -p /var/lock/apache2 /var/run/apache2`

Zuletzt wird der Port 80 freigegeben und der Ordner wird gemountet.
```
EXPOSE 80

VOLUME /var/www/html

CMD /bin/bash -c "source /etc/apache2/envvars && exec /usr/sbin/apache2 -DFOREGROUND"
```

## Aufsetzen
Um nachher mit diesem File aufsetzen zu können muss man zuerst den Docker aufbauen. Mit dem `.` wird vorgegeben, dass das Dockerfile verwendet werden soll.
`docker build -t apache .`
Zunächst wird der Port gemapt und das Laufwerk m300lb2 wird auf das /var Verzeichnis gemountet.
`docker run -d -p 1100:80 -v /home/vagrant/m300lb2:/var/www/html --name apache apache`
