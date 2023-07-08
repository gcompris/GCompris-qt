<?php
// Convert Guess24-difficulty.csv and Guess24-solutions.csv into a json file with required informations
// Usage from guess24 directory: $ php build-datas.php
// Output a report on stdout and a json file for the activity.

$outputFile = "../resource/guess24.json";
$difficultyFile = "Guess24-difficulty.csv";
$solutionFile = "Guess24-solutions.csv";
$limitRate = 80.0;
$verbose = false;
$noSolutions = false;

$short_options = "vschr:";
$long_options = ["verbose", "solutions", "help", "rate:"];
$options = getopt($short_options, $long_options);

if(isset($options["v"]) || isset($options["verbose"])) {
    $verbose = true;
}
if(isset($options["s"]) || isset($options["solutions"])) {
    $noSolutions = true;
}
if(isset($options["r"]) || isset($options["rate"])) {
    $limitRate = isset($options["r"]) ? $options["r"] : $options["rate"];
    if (is_numeric($limitRate))
        $limitRate = (float) $limitRate;
    else {
        print("Rate parameter should be numeric.\n");
        exit(1);
    }
}

if(isset($options["h"]) || isset($options["help"])) {
    print("Usage: php build-datas.php [OPTIONS]\n");
    print("Create file `$outputFile` from `$difficultyFile` and `$solutionFile`.\nPrint a report on stdout.\n\n");
    print("Options\n");
    print("  -v, --verbose              print informations on rejected formulas.\n");
    print("  -s, --solutions            no solutions in output file.\n");
    print("  -r, --rate [LIMITRATE]     set minimum solved rate required (default 80).\n");
    print("  -h, --help                 display this help and exit.\n");
    exit(0);
}

// First line contains csv headers
function stripFirstLine($text) {
    return substr($text, strpos($text, "\n") + 1);
}

$solutions = array();
$problems = array();
$rejected = 0;
// Load files, remove non-breaking spaces and split into an array
$ranked   = preg_split("/\n/", stripFirstLine(trim(preg_replace("/\xc2\xa0/", '', file_get_contents($difficultyFile)))));
$solutext = preg_split("/\n/", stripFirstLine(trim(preg_replace("/\xc2\xa0/", '', file_get_contents($solutionFile)))));

foreach($solutext as $sol) {
    $sols = preg_split("/,/", $sol);
    array_shift($sols);
    $puz = trim(array_shift($sols));
    while (trim($sols[array_key_last($sols)]) === "") {   // Remove empty solutions
        array_pop($sols);
    }
    $translatedSols = Array();
    foreach($sols as $idx => $val) {
        $val = preg_replace(array("/×/", "/÷/"), array("*", "/"), trim($val));
        $val = trim($val);
        $result = 0;
        $sols[$idx] = $val;
        if (preg_match_all("/\([^\)]+\)/", $val, $matches)) {    // Check for rational intermediate result
            foreach($matches[0] as $formula) {
                $formula = substr($formula, 1, strlen($formula) - 2);
                eval("\$result = $formula;");
                if ($result != floor($result)) {
                    if ($verbose)
                        print("$puz solution $val rejected: ($formula) = $result\n");
                    array_splice($sols, $idx, 1);
                    $rejected++;
                    continue 2;
                }
            }
        }
        $translatedSols[] = $val;
    }
    $solutions[$puz] = $translatedSols;
}
foreach($ranked as $line) {
    list($rank, $puzzle, $amt, $solvedRate, $sigmaMean, $sigmaSTD) = preg_split("/,/", $line);
    $puzzle = trim($puzzle);
    $solvedRate = (double) substr($solvedRate, 0, strlen($solvedRate) - 1);
    if (($solvedRate > $limitRate) && count($solutions[$puzzle])) {
        $problems[] = array(
            'puzzle' => $puzzle,
            'solutions' => $solutions[$puzzle]
        );
    }
}

$difficount = array(0, 0, 0);
foreach($problems as $num => $problem) {
    $complexity = 3;
    foreach($problem['solutions'] as $solution) {
        if (preg_match("/\//", $solution)) {    // if one solution has divide
            $complexity = min($complexity, 3);
            continue;
        }
        if (preg_match("/\*/", $solution)) {    // if one solution has multiply
            $complexity = min($complexity, 2);
            continue;
        }
        $complexity = min($complexity, 1);      // if one solution has no multiply nor divide
    }
    $problems[$num]['complexity'] = $complexity;
    if ($noSolutions)
        unset($problems[$num]['solutions']);
    $difficount[$complexity - 1]++;
}

file_put_contents($outputFile, json_encode($problems, JSON_PRETTY_PRINT));

// Statistics on stdout
$total = $difficount[0] + $difficount[1] + $difficount[2];
print("Problems with a solved rate greater than $limitRate%\n");
print(str_repeat("-", 20)."\n");
print("Complexity 1: {$difficount[0]} problems\n");
print("Complexity 2: {$difficount[1]} problems\n");
print("Complexity 3: {$difficount[2]} problems\n");
print("Total: $total problems\n");
print(str_repeat("-", 20)."\n");
print("Output file: $outputFile\n");
print("Output file size: ".filesize($outputFile)." bytes\n");
print("$rejected solutions rejected for a rational intermediate result\n");

?>
