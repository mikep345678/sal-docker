# Use phusion/passenger-full as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/passenger-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/passenger-full:0.9.9

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

RUN apt-get update && apt-get install -y \
  python-pip \
  python-dev \
  libpq-dev 

RUN git clone https://github.com/grahamgilbert/sal.git /home/app/sal

RUN pip install -r /home/app/sal/setup/requirements.txt
RUN easy_install psycopg2
RUN mkdir -p /etc/my_init.d
ADD initial_data.json /home/app/sal/
ADD settings.py /home/app/sal/sal/
ADD passenger_wsgi.py /home/app/sal/
ADD run.sh /etc/my_init.d/run.sh
RUN chown -R app:app /home/app/

# enable sshd password authentication
RUN echo "   PasswordAuthentication yes" >> /etc/ssh/sshd_config

# add tsadmin user
RUN adduser tsadmin
RUN usermod -aG sudo tsadmin
RUN echo tsadmin:password | chpasswd
#RUN echo "password" | passwd "tsadmin" --stdin

ADD sal.conf /etc/nginx/sites-enabled/sal.conf
RUN rm -f /etc/nginx/sites-enabled/default
RUN rm -f /etc/service/nginx/down
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
EXPOSE 8080
EXPOSE 22
