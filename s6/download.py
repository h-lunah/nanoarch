#!/usr/bin/env python

import os
import re
from urllib.parse import unquote
from http.client import responses

import requests

packages = ["s6", "s6-base", "s6-scripts", "s6-contrib", "s6-linux-init", "device-mapper", "esysusers", "etmpfiles", "dhcpcd", "dhcpcd-s6", "device-mapper-s6"]

print("Filtering packages...")
for package in packages[:]:
    status = requests.get(f"https://archive.artixlinux.org/packages/{package[0]}/{package}").status_code
    print(f"{package}: {responses[status]}")
    if status == 404:
        packages.remove(package)

print("Downloading packages...")
for package in packages:
    html_doc = requests.get(f"https://archive.artixlinux.org/packages/{package[0]}/{package}").text
    try:
        rematch = re.findall(r".+ \d{1,2}-\w{3}-2024", html_doc)[-2]
        package_name = unquote(re.findall(r'"(.*?)".+ \d{1,2}-\w{3}-2024', html_doc)[-2])
        release_date = re.findall(r'\d{1,2}-\w{3}-2024', html_doc)[-2]
        print(f"\nDownloading {package_name}")
        os.system(f"wget https://archive.artixlinux.org/packages/{package[0]}/{package}/{package_name}")
    except IndexError:
        print(f"\n{package} is not a recent package, you may want to get it manually.")
        print(f"Look for: https://archive.artixlinux.org/packages/{package[0]}/{package}/")
