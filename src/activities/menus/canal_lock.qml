import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "canal_lock"
  dir: "src/activities/canal_lock"
  difficulty: 2
  icon: "menus/canal_lock.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Operate a canal lock")
  description: qsTr("Tux is in trouble, and needs to take his boat through a lock. Help Tux and find out how a canal lock works.")
  goal: ""
  prerequisite: ""
  manual: qsTr("You are in charge of the canal lock. Open the gates and the locks in the right order, so Tux can travel through the gates in both directions.")
  credit: qsTr("Drawing by Stephane Cabaraux.")
}
