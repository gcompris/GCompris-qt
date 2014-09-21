import GCompris 1.0

ActivityInfo {
  name: "memory-sound-tux/MemorySoundTux.qml"
  difficulty: 2
  icon: "memory-sound-tux/memory-sound-tux.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: true
  title: qsTr("Audio memory game against Tux")
  description: qsTr("Play the audio memory game against Tux")
//  intro: "Take turns competing against Tux by clicking on a card and finding its double."
  goal: qsTr("Train your audio memory and remove all the violinists Tux.")
  prerequisite: qsTr("Mouse manipulation, Brain.")
  manual: qsTr("A set of violinist Tux is shown. Each Tux has an associated sound, and each sound has a twin exactly the same. Click on a Tux to see its hidden sound, and try to match the twins. You can only activate two Tux at once, so you need to remember where a sound is, while you listen to its twin. When you turn over the twins, they both disappear.")
  credit: ""
  section: "/discovery/memory_group"
}
