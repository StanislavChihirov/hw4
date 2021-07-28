#!/bin/bash
sudo apt update
sudo apt install apache2 -y
echo "<h1>Hello byurkovskiy ! :-)</h1><h2>Check please homework )))</h2>" > /var/www/html/index.html
sudo service apache2 start
