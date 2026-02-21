from prometheus_client import start_http_server, Gauge, Counter
import time
import psutil
import logging

cpu_usage = Gauge("my_app_cpu_usage_percent", "CPU usage percent")
cpu_count = Gauge("my_app_cpu_count_total", "Total CPU cores")

mem_available_mb = Gauge("my_app_memory_available_mb", "Available memory in MB")
mem_used_percent = Gauge("my_app_memory_used_percent", "Memory used percent")

disk_used_percent = Gauge("my_app_disk_used_percent", "Disk used percent")
disk_read_bytes = Counter("my_app_disk_read_bytes_total", "Disk read bytes")
disk_write_bytes = Counter("my_app_disk_write_bytes_total", "Disk write bytes")

last_read = 0
last_write = 0

logging.basicConfig(level=logging.ERROR)

def collect_metrics():
    global last_read, last_write

    cpu_usage.set(psutil.cpu_percent(interval=None))
    cpu_count.set(psutil.cpu_count())

    mem = psutil.virtual_memory()
    mem_available_mb.set(mem.available / (1024 * 1024))
    mem_used_percent.set(mem.percent)

    disk = psutil.disk_usage("/")
    disk_used_percent.set(disk.percent)

    disk_io = psutil.disk_io_counters()
    if last_read != 0:
        disk_read_bytes.inc(disk_io.read_bytes - last_read)
        disk_write_bytes.inc(disk_io.write_bytes - last_write)

    last_read = disk_io.read_bytes
    last_write = disk_io.write_bytes

if __name__ == "__main__":
    psutil.cpu_percent(interval=None)
    start_http_server(8000)

    while True:
        collect_metrics()
        time.sleep(10)
