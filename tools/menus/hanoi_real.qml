import GCompris 1.0

ActivityInfo {
  name: "hanoi_real/HanoiReal.qml"
  difficulty: 3
  icon: "hanoi_real/hanoi_real.svgz"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("The Tower of Hanoi")
  description: qsTr("Reproduce the tower on the right side")
  goal: qsTr("The object of the game is to move the entire stack to another peg, obeying the following rules:
* only one disc may be moved at a time
* no disc may be placed atop a smaller disc")
  prerequisite: qsTr("Mouse manipulation")
  manual: qsTr("Drag and Drop the top pieces only from one peg to another, to reproduce the tower on the right in the empty space on the left.")
  credit: qsTr("The puzzle was invented by the French mathematician Edouard Lucas in 1883. There is a legend about a Hindu temple whose priests were constantly engaged in moving a set of 64 discs according to the rules of the Tower of Hanoi puzzle. According to the legend, the world would end when the priests finished their work. The puzzle is therefore also known as the Tower of Brahma puzzle. It is not clear whether Lucas invented this legend or was inspired by it. (source Wikipedia &lt;http://en.wikipedia.org/wiki/Tower_of_hanoi&gt;)")
  section: "/puzzle"
}
