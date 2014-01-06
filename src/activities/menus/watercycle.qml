import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "watercycle"
  dir: "src/activities/watercycle"
  difficulty: 3
  icon: "menus/watercycle.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Learn about the water cycle")
  description: qsTr("Tux has come back from a long fishing party on his boat. Bring the water system back up so he can take a shower.")
  goal: qsTr("Learn the water cycle")
  prerequisite: ""
  manual: qsTr("Click on different active elements : sun, cloud, water pump station, and water cleanup station, in order to reactivate the entire water system. When the system is back up and Tux is in the shower, push the shower button for him.")
  credit: qsTr("Drawing by Stephane Cabaraux.")
}
