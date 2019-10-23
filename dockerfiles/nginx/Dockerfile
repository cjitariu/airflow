FROM nginx:latest
RUN for f in "/var/cache/nginx/" "/etc/passwd" "/etc/group"; do\
          chgrp -R 0 ${f} && \
          chmod -R g+rwX ${f}; \
        done
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx
# users are not allowed to listen on priviliged ports
RUN sed -i.bak 's/listen\(.*\)80;/listen 8081;/' /etc/nginx/conf.d/default.conf
EXPOSE 8081
# comment user directive as master process is run as user in OpenShift anyhow
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf