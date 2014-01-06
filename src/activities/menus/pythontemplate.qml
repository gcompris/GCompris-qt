import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "pythontemplate"
  dir: "src/activities/pythontemplate"
  difficulty: 1
  icon: "menus/python.svg"
  author: "Bruno Coudoin"
  demo: false
  title: qsTr("Python Template")
  description: qsTr("An empty Python activity to use as a starting point")
  goal: qsTr("Add a language-binding to GCompris.")
  prerequisite: qsTr("Advanced Python Programmer :)")
  manual: ""
  credit: qsTr("Thanks to Guido van Rossum and the Python team for this powerful language!")
}
