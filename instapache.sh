#!/bin/bash
sudo apt update
sudo apt install apache2 -y
echo "<h1>This Web Server run with IP: $myip</h1> <h2>Hello byurkovskiy ! :-)</h2><h3>Check please homework )))))</h3>" > /var/www/html/index.html
sudo service apache2 start
