import GCompris 1.0

ActivityInfo {
  name: "memory_sound_tux/MemorySoundTux.qml"
  difficulty: 2
  icon: "memory_sound_tux/memory_sound_tux.svg"
  author: "Yves Combe <yves@ycombe.net>"
  demo: true
  title: qsTr("Audio memory game against Tux")
  description: qsTr("Play the audio memory game against Tux")
  goal: qsTr("Train your audio memory and remove all the violinists Tux.")
  prerequisite: qsTr("Mouse manipulation, Brain.")
  manual: qsTr("A set of violinist Tux is shown. Each Tux has an associated sound, and each sound has a twin exactly the same. Click on a Tux to see its hidden sound, and try to match the twins. You can only activate two Tux at once, so you need to remember where a sound is, while you listen to its twin. When you turn over the twins, they both disappear.")
  credit: ""
  section: "/discovery/memory_group"
}
