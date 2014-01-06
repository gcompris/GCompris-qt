import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "erase_2clic"
  dir: "src/activities/erase_2clic"
  difficulty: 2
  icon: "menus/erase_2clic.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Double click the mouse")
  description: qsTr("Double click the mouse to erase the area and discover the background")
  goal: qsTr("Motor-coordination")
  prerequisite: qsTr("Mouse-manipulation")
  manual: qsTr("Double click the mouse on rectangles until all the blocks disappear.")
  credit: qsTr("Animal pictures come from the Animal Photography Page of Ralf Schmode (http://schmode.net/). Ralf has kindly permitted GCompris to include his pictures. Thanks a lot, Ralf.")
}
