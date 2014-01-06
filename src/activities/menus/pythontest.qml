import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "pythontest"
  dir: "src/activities/pythontest"
  difficulty: 1
  icon: "menus/python.svg"
  author: "Olivier Samyn <osamyn@ulb.ac.be>"
  demo: true
  title: qsTr("Python Test")
  description: qsTr("Test board for the Python plugin")
  goal: qsTr("Add a language-binding to GCompris.")
  prerequisite: qsTr("Advanced Python Programmer :)")
  manual: ""
  credit: qsTr("Thanks to Guido van Rossum and the Python team for this powerful language!")
}
