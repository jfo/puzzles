<?
$world = [];
for ($i=0; $i < 100; $i++) {
    $world[] = 0;
};

$world[] =  1;

$thingy = [
    "111" => 0,
    "110" => 1,
    "101" => 1,
    "100" => 0,
    "011" => 1,
    "010" => 1,
    "001" => 1,
    "000" => 0
];

function tick($world) {
    global $thingy;
    $next_generation =  [];
    for ($i = 0; $i < count($world) ; $i++) {
        if ($i == count($world) - 1) {
            $next_generation[$i] = $thingy[ $world[$i-1 ] . $world[$i] . $world[0] ];
        } else if ($i == 0) {
            $next_generation[$i] = $thingy[ $world[count($world) - 1] . $world[$i] . $world[$i+1] ];
        } else {
            $next_generation[$i] = $thingy[ $world[$i-1] . $world[$i] . $world[$i+1] ];
        }
    }

    // var_dump($world);
    // var_dump($next_generation);

    return $next_generation;
}


while(true) {
    for($z=0; $z < count($world) ; $z++) {
        if ($world[$z] == 1) {
            echo "# ";
        } else {
            echo "  ";
        }
    }
    $world = tick($world);
    echo "\n";
    usleep(50000);
}
