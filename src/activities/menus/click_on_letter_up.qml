import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "click_on_letter_up"
  dir: "src/activities/click_on_letter_up"
  difficulty: 1
  icon: "menus/click_on_letter_up.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Click on an uppercase letter")
  description: qsTr("Listen to a letter and click on the right one")
  goal: qsTr("Letter-name recognition")
  prerequisite: qsTr("Visual letter-recognition. Can move the mouse.")
  manual: qsTr("A letter is spoken. Click on the matching letter in the main area. You can listen to the letter again, by clicking on the mouth icon in the bottom box.")
  credit: ""
}
