import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "clockgame"
  dir: "src/activities/clockgame"
  difficulty: 2
  icon: "menus/clockgame.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Learning Clock")
  description: qsTr("Learn how to tell the time")
  goal: qsTr("Distinguish between time-units (hour, minute and second). Set and display time on a clock.")
  prerequisite: qsTr("The concept of time. Reading the time.")
  manual: qsTr("Set the clock to the time given, in the time-units shown (hours:minutes or hours:minutes:seconds). Click on the different arrows, and move the mouse, to make the numbers go up or down.")
  credit: ""
}
