from prometheus_client import start_http_server, Gauge
import time
import psutil
import platform

disk_free_bytes = Gauge("node_disk_free_bytes", "total_free_space", ['device','mountpoint','os_type'])

os_name = platform.system()
def collect_metric():

  for part in psutil.disk_partitions():
     
     try:
        usage = psutil.disk_usage(part.mountpoint).free
        disk_free_bytes.labels(device=part.device,mountpoint=part.mountpoint, os_type=os_name).set(usage)
     except PermissionError:
           continue


if __name__ == "__main__":
    psutil.cpu_percent(interval=None)
    start_http_server(8000)

    while True:
        collect_metric()
        time.sleep(10)
     