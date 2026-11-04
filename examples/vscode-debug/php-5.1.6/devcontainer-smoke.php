<?php
header("Content-Type: text/plain");
$version = PHP_VERSION; // Set a breakpoint on this line.
echo "PHP " . $version . "\n";
echo "Xdebug " . (extension_loaded("xdebug") ? phpversion("xdebug") : "not loaded") . "\n";
