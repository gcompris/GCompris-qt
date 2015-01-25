import GCompris 1.0

ActivityInfo {
  name: "hanoi_real/HanoiReal.qml"
  difficulty: 5
  icon: "hanoi_real/hanoi_real.svg"
  author: "Amit Tomar <a.tomar@outlook.com>"
  demo: false
  title: qsTr("The Tower of Hanoi")
  description: qsTr("Reproduce the tower on the right side")
  goal: qsTr("Objective of the game is to move the entire stack to another peg, follwing these rules : 1 . Only one disc is moves at a time. 2. No disc may be places atop a smaller disc.")
  prerequisite: ""
  manual: qsTr("Drag and drop the top pieces only from one peg to another, to reproduce the tower on the left side in the empty space on right.")
  credit: qsTr("The puzzle was invented by the French mathematician Edouard Lucas in 1883. There is a legend about a Hindu temple whose priests were constantly engaged in moving a set of 64 discs according to the rules of the Tower of Hanoi puzzle. According to the legend, the world would end when the priests finished their work. The puzzle is therefore also known as the Tower of Brahma puzzle. It is not clear whether Lucas invented this legend or was inspired by it. (source Wikipedia <http://en.wikipedia.org/wiki/Tower_of_hanoi>)")
  section: "puzzle"
}
