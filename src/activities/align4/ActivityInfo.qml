import GCompris 1.0

ActivityInfo {
  name: "align4/Align4.qml"
  difficulty: 2
  icon: "align4/align4.svg"
  author: "Bharath M S <brat.197@gmail.com>"
  demo: false
  title: qsTr("align4 activity")
  description: qsTr("Arrange four coins in a row")
//  intro: "Click on the column where you wish your token to fall and try and make a line of 4 tokens before Tux."
  goal: qsTr("Create a line of 4 pieces either horizontally (lying down), vertically (standing up) or diagonally.")
  prerequisite: qsTr("Mouse-manipulation")
  manual: qsTr("Click the position in the line where you want to drop a piece. You can also use the arrow keys to move the piece left or right, and the down or space key to drop a piece.")
  credit: qsTr("")
  section: "/strategy"
}
