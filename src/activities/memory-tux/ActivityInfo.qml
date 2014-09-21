import GCompris 1.0

ActivityInfo {
  name: "memory-tux/MemoryTux.qml"
  difficulty: 1
  icon: "memory-tux/memory-tux.svg"
  author: "JB BUTET <ashashiwa@gmail.com>"
  demo: false
  title: qsTr("Memory Game with images against Tux")
  description: qsTr("Flip the cards to find the matching pairs against Tux")
//  intro: "Take turns competing against Tux by clicking on a card and finding its double."
  goal: qsTr("Train your memory and remove all the cards")
  prerequisite: qsTr("Mouse-manipulation")
  manual: qsTr("A set of blank cards is shown. Each card has a picture on the other side, and each picture card has a twin exactly the same. Click on a card to see its hidden picture, and try to match the twins. You can only turn over two cards at once, so you need to remember where a picture is, while you look for its twin. When you turn over the twins, they both disappear. Tux teacher do the same.")
  credit: qsTr("")
  section: "/discovery/memory_group"
}
