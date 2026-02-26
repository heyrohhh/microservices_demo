FROM prom/prometheus

COPY prometheus.yml /etc/prometheus/prometheus.yml
COPY alerts.yml /etc/prometheus/alerts.yml

CMD [ "--config.file=/etc/prometheus/prometheus.yml" ]