#!/bin/sh
set -eu
php -v
php -m
php -l /checks/devcontainer-smoke.php
cp /checks/devcontainer-smoke.php /var/www/html/devcontainer-smoke.php
apache2ctl -t
apache2ctl -D FOREGROUND &
sleep 2
php -r '$result = file_get_contents("http://127.0.0.1/devcontainer-smoke.php"); if ($result === false || strpos($result, "PHP " . PHP_VERSION) === false || strpos($result, "Xdebug ausente") !== false || strpos($result, "<?php") !== false) { exit(1); } echo $result;'
