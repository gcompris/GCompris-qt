import GCompris 1.0

ActivityInfo {
  name: "connect4/Connect4.qml"
  difficulty: 2
  icon: "connect4/connect4.svgz"
  author: "Laurent Lacheny <laurent.lacheny@wanadoo.fr>"
  demo: true
  title: qsTr("Connect 4")
  description: qsTr("Arrange four coins in a row")
  goal: qsTr("Create a line of 4 pieces either horizontally (lying down), vertically (standing up) or diagonally.")
  prerequisite: qsTr("Mouse-manipulation")
  manual: qsTr("Click the position in the line where you want to drop a piece. You can also use the arrow keys to move the piece left or right, and the down or space key to drop a piece.")
  credit: qsTr("Laurent Lacheny. Images and Artificial Intelligence taken from project 4stattack by Jeroen Vloothuis. The original project can be found on &lt;http://forcedattack.sourceforge.net&gt;")
  section: "/strategy"
}
