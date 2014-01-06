import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "scalesboard"
  dir: "src/activities/scalesboard"
  difficulty: 2
  icon: "menus/scalesicon.svg"
  author: "miguel DE IZARRA <miguel2i@free.fr>"
  demo: true
  title: qsTr("Balance the scales properly")
  description: qsTr("Drag and Drop weights to balance the scales")
  goal: qsTr("Mental calculation, arithmetic equality")
  prerequisite: ""
  manual: qsTr("To balance the scales, move the weights on the left or the right side. The weights can be arranged in any order.")
  credit: qsTr("The painting is an original painting created by Virginie MOREAU (virginie.moreau@free.fr) in 2001. Its name is 'Spices Seller in Egypt'. It is released under the GPL license.")
}
