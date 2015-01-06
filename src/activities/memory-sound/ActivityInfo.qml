import GCompris 1.0

ActivityInfo {
  name: "memory-sound/MemorySound.qml"
  difficulty: 2
  icon: "memory-sound/memory-sound.svg"
  author: "JB BUTET <ashashiwa@gmail.com>"
  demo: true
  title: qsTr("Audio memory game")
  description: qsTr("Click on Tux the violinist and listen to find the matching sounds")
//  intro: "Click on an audio card and find its double."
  goal: qsTr("Train your audio memory and remove all the violinists Tux.")
  prerequisite: qsTr("Mouse manipulation, Brain.")
  manual: qsTr("A set of violinist Tux is shown. Each Tux has an associated sound, and each sound has a twin exactly the same. Click on a Tux to see its hidden sound, and try to match the twins. You can only activate two Tux at once, so you need to remember where a sound is, while you listen to its twin. When you turn over the twins, they both disappear.")
  credit: ""
  section: "/discovery/memory_group"
}
