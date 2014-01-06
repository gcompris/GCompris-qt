import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "colors"
  dir: "src/activities/colors"
  difficulty: 1
  icon: "menus/colors.svg"
  author: "Pascal Georges <pascal.georges1@free.fr>"
  demo: true
  title: qsTr("Colors")
  description: qsTr("Click on the right color")
  goal: qsTr("This board teaches you to recognize different colors. When you hear the name of the color, click on the duck wearing it.")
  prerequisite: qsTr("Can move the mouse.")
  manual: qsTr("Listen to the color and click on the matching duck.")
  credit: ""
}
