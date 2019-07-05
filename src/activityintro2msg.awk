match($0, /intro:[[:blank:]]+/) {
  split(FILENAME, paths, "/")
  printf "// i18n: file: %s:%d\n", FILENAME, NR
  printf "//i18n: intro voices, see GCompris-voices/README.md - activity: \"%s\"\n", paths[3]
  printf "i18n(%s);\n", substr($0, RSTART+RLENGTH)
}
