import GCompris 1.0

ActivityInfo {
  name: "connect4-2players/Connect4-2players.qml"
  difficulty: 2
  icon: "connect4-2players/connect4.svgz"
  author: "Laurent Lacheny <laurent.lacheny@wanadoo.fr> / Miguel de Izarra <miguel2i@free.fr>"
  demo: true
  title: qsTr("Connect 4 (2 Players)")
  description: qsTr("Arrange four coins in a row")
  goal: qsTr("Create a line of 4 pieces either horizontally (lying down) or vertically (standing up) or diagonally.")
  prerequisite: qsTr("Mouse-manipulation")
  manual: qsTr("Click the position in the line where you want to drop a piece. You can also use the arrow keys to move the piece left or right, and the down or space key to drop a piece.")
  credit: qsTr("The original code was written in 2005 by Laurent Lacheny. In 2006, Miguel de Izarra made the two players game. Images and Artificial Intelligence taken from project 4stattack by Jeroen Vloothuis. The original project can be found on &lt;http://forcedattack.sourceforge.net&gt;")
  section: "/strategy"
}
