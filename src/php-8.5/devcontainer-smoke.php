<?php
header("Content-Type: text/plain");
$version = PHP_VERSION; // Coloque um breakpoint nesta linha.
echo "PHP " . $version . "\n";
echo "Xdebug " . (extension_loaded("xdebug") ? phpversion("xdebug") : "ausente") . "\n";
