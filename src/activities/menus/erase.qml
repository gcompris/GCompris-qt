import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "erase"
  dir: "src/activities/erase"
  difficulty: 1
  icon: "menus/erase.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Move the mouse")
  description: qsTr("Move the mouse to erase the area and discover the background")
  goal: qsTr("Motor-coordination")
  prerequisite: qsTr("Mouse-manipulation")
  manual: qsTr("Move the mouse until all the blocks disappear. You can add you own images under the directory '~/My GCompris/erase'.")
  credit: qsTr("Animal pictures are taken from the Animal Photography Page of Ralf Schmode (&lt;http://schmode.net/&gt;) and from LE BERRE Daniel. These people kindly gave GCompris the authorization to include their pictures. Thanks a lot, both of you.")
}
