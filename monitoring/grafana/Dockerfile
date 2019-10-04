FROM grafana/grafana:5.0.0

ADD provisioning/dashboards /etc/grafana/provisioning/dashboards
ADD provisioning/datasources /etc/grafana/provisioning/datasources
RUN mkdir /var/lib/grafana/dashboards
ADD dashboards /var/lib/grafana/dashboards
