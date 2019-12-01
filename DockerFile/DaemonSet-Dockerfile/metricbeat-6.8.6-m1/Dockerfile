FROM	byteedu/metricbeat:6.8.5
SHELL	["/bin/bash","-c"]
ADD	--chown=root:metricbeat metricbeat.yml /usr/share/metricbeat/
ENTRYPOINT ["metricbeat"]
