<?php
header('Content-Type: text/plain; charset=utf-8');

function calculateTotal($price, $quantity) {
    $subtotal = $price * $quantity;
    $discount = $subtotal * 0.10;
    $total = $subtotal - $discount; // BREAKPOINT: subtotal=50 and discount=5
    return $total;
}

$runtime = PHP_VERSION;
$price = 12.50;
$quantity = 4;
$total = calculateTotal($price, $quantity);
echo 'PHP: ' . $runtime . "\n";
echo 'Xdebug: ' . phpversion('xdebug') . "\n";
echo 'Total: ' . $total . "\n";
