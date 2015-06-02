import GCompris 1.0

ActivityInfo {
  name: "memory-sound-tux/MemorySoundTux.qml"
  difficulty: 2
  icon: "memory-sound-tux/memory-sound-tux.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Audio memory game against Tux")
  description: qsTr("Play the audio memory game against Tux")
//  intro: "Take turns competing against Tux by clicking on a card and finding its double."
  goal: qsTr("Train your audio memory and remove all the cards.")
  prerequisite: ""
  manual: qsTr("A set of cards is shown. Each card has an associated sound, and each sound has a twin exactly the same. Click on a card to hear its hidden sound, and try to match the twins. You can only activate two cards at once, so you need to remember where a sound is, while you listen to its twin. When you turn over the twins, they both disappear.")
  credit: ""
  section: "discovery memory music"
}
