sal-docker
==========

Dockerfile for Sal

#Sal container
the settings should be configured durin the DB step. The sal container uses the linked db container.

##(original build instructions:)
In the folder with the Dockerfile, run

```docker build -t sal .```


##(original run instructions)

```docker run -p 80:8080 -d --link sal-postgresql:db sal /sbin/my_init```


##build

```sudo docker build -t mikep345678/sal-docker github.com/mikep345678/sal-docker```


##run sal container
(not in daemon mode... HTTP and SSH ports revealed... ctrl-c to close Sal)

```sudo docker run -p 8080:8080 -p 10022:22 --link sal-postgresql:db mikep345678/sal-docker /sbin/my_init```


##run sal container with bash shell
for making changes- provides alternate HTTP and SSH connection ports. ```exit``` to return

```sudo docker run -t -i -p 8082:8080 -p 10222:22 --link sal-postgresql:db mikep345678/sal-docker /bin/bash```


## commit changes made in shell
```sudo docker commit $(sudo docker ps -l -q) mikep345678/sal-docker```


#Run PostgreSQL container

    docker run -d --name="sal-postgresql" \
                 -p 127.0.0.1:5432:5432 \
                 -v /tmp/postgresql:/data \
                 -e USER="saladmin" \
                 -e DB="sal_db" \
                 -e PASS="password" \
                 paintedfox/postgresql



#To Do

* Implement backup to S3
* set admin user and password from environment variables.
* Move sal.conf from container to a volume

