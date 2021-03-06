# Vagrant PHP7 

A simple Vagrant LAMP setup running PHP7.

## What's inside?

- Ubuntu 16.04.3 LTS (xenial)
- Vim, Git, Curl, etc.
- Apache
- PHP7 with some extensions
- MySQL 5.7
- Node.js with NPM
- RabbitMQ
- Redis
- Composer
- phpMyAdmin

## How to use

- Clone this repository into your project
- Run ``vagrant up``
- Add the following lines to your hosts file:
````
192.168.100.100 app.dev
192.168.100.100 phpmyadmin.dev
````
- Navigate to ``http://app.dev/`` 
- Navigate to ``http://phpmyadmin.dev/`` (both **username** and **password** are '**root**')

* You can change the script in bootstrap.sh, Run for update with scripts
`` vagrant provision``