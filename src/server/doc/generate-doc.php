<?php
/* GCompris - generate-doc.php
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 *
 * Usage :
 *    $ php generate-doc.php
 * Build GCompris-Teachers.md documentation file
 */
  $dirs        = Array(".", "components", "dialogs", "panels", "views", "singletons", "activities");
  $classes     = Array();
  $baseDir     = "../";
  $filePattern = "*";
  $outputFile  = "GCompris-Teachers.md";

  function readAndClean($file) {
    $content = file_get_contents($file);
    $content = preg_replace("/\/\*.*\*\//s","",$content);     // Remove result_ /* */ comments
    $content = preg_replace("/\/\/.*$/m","",$content);        // Remove // comments
    return $content;
  }

  // Find qml objects names inside qml files
  function inspectClass($parentClassName, $parentFileName, $depth) {
    global $classes, $output;
    $content = readAndClean($parentFileName);                 // Read qml file
    foreach ($classes as $className => $fileName) {           // Loop on each class
      $pos = 0;
      $count = 0;
      while (!($pos === false)) {                             // === is mandatory here. pos is either false, either an integer
        $pos = strpos($content, "$className {", $pos + 1);
        if (!($pos === false))
          $count++;
      }
      if (($count) && ($parentClassName != $className)) {
        $output .= str_repeat("    ",$depth)." * [$className]($fileName) ($count)\n";
        inspectClass($className, $fileName, $depth + 1);      // Recursive call to inspect this included class
      }
    }
  }

  // Read directories tree and delete some chars
  function readTree() {
    global $baseDir;
    $out = shell_exec("tree -d --charset unicode $baseDir");
    $out = preg_replace("/[\|\-\ `]{4}/","  ", $out);         // Remove tree chars
    $out = preg_replace("/ (\w)/"," * $1", $out);             // Add * before directory name
    $out = preg_replace("/\d+ \* directories\n/s","", $out);  // Remove last line from tree command
    $out = preg_replace("/\.\.\//","**teachers/**", $out);      // Bold main directory
    return $out;
  }

  // Program starts here
  foreach ($dirs as $dir) {                                   // Build classes list from directories file's names (ending with .qml)
    foreach (glob("$baseDir$dir/$filePattern") as $file) {    // For each file in dir
      if ($file == '.' || $file == '..') continue;
      $classes[basename($file, ".qml")] = $file;              // Keep class name and file name in $classes array
    }
  }
  foreach ($dirs as $dir) {                                   // Build classes list from directories file's names (ending with .qml)
    foreach (glob("$baseDir$dir/*/$filePattern") as $file) {  // For each file in subdir
      if ($file == '.' || $file == '..') continue;
      $classes[basename($file, ".qml")] = $file;              // Keep class name and file name in $classes array
    }
  }

  $output = "";
  $output .= "# GCompris teachers - Generated documentation.\n";
  $output .= "## Qml object nesting hierarchy.\n";
  $output .= "  * [Main](".$classes["Main"].")\n";
  $depth = 1;                                                 // Depth controls indentation
  inspectClass("Main", $classes["Main"], $depth);             // Enter inspectClass from Main object in Main.qml

  // $output .= "\n## Teachers directory hierarchy.\n";
  // $output .= readTree();

  $output .= "\nFile generated on ".date('Y/m/d H:i:s e', time())." with ".basename(__FILE__)."\n";

  file_put_contents($outputFile, $output);
  print("Generate file: $outputFile\n");
?>
