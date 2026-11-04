<?php
header('Content-Type: text/plain; charset=utf-8');

function calcularTotal($preco, $quantidade) {
    $subtotal = $preco * $quantidade;
    $desconto = $subtotal * 0.10;
    $total = $subtotal - $desconto; // BREAKPOINT: subtotal=50 e desconto=5
    return $total;
}

$runtime = PHP_VERSION;
$preco = 12.50;
$quantidade = 4;
$total = calcularTotal($preco, $quantidade);
echo 'PHP: ' . $runtime . "\n";
echo 'Xdebug: ' . phpversion('xdebug') . "\n";
echo 'Total: ' . $total . "\n";
