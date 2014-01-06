import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "tuxpaint"
  dir: "src/activities/tuxpaint"
  difficulty: 1
  icon: "menus/tuxpaint.svg"
  author: "Bill Kendrick <Tuxpaint>"
  demo: true
  title: qsTr("Tuxpaint")
  description: qsTr("Launch Tuxpaint")
  goal: qsTr("Drawing activity (pixmap)")
  prerequisite: qsTr("mouse and keyboard manipulation")
  manual: qsTr("Use Tuxpaint to draw. When Tuxpaint is finished this board will end.")
  credit: ""
}
