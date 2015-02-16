import GCompris 1.0

ActivityInfo {
  name: "play_piano/PlayPiano.qml"
  difficulty: 2
  icon: "play_piano/play_piano.svg"
  author: "Beth Hadley <bethmhadley@gmail.com>"
  demo: true
  title: qsTr("Play Piano!")
  description: qsTr("Learn to play melodies on the piano keyboard!")
  goal: qsTr("Understand how the piano keyboard can play music as written on the musical staff.")
  prerequisite: qsTr("Knowledge of musical notation and musical staff. Play the activity named 'Piano Composition' first.")
  manual: qsTr("The notes you see will be played to you. Click on the corresponding keys on the keyboard that match the notes you hear and see. All levels except for the last have the notes colored so you can match the notes to the keyboard colors. Each level increases in difficulty by adding more notes. Levels 1-6 test the treble clef, levels 7-12 test the bass clef. When you get five points, you move onto the next level (incorrect answers deduct points, correct answers add points).

The following keyboard bindings work in this game:
- backspace: erase attempt
- delete: erase attempt
- enter/return: OK button
- space bar: play
- number keys:
  - 1: C
  - 2: D
  - 3: E
  - 4: F
  - 5: G
  - 6: A
  - 7: B
  - 8: C (higher octave)
  - etc.
  - F1: C# / Db
  - F2: D# / Eb
  - F3: F# / Gb
  - F4: G# / Ab
  - F5: A# / Bb
")
  credit: qsTr("Bruno Coudoin for his mentorship.")
  section: "/discovery/sound_group"
}
