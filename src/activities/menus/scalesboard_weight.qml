import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "scalesboard_weight"
  dir: "src/activities/scalesboard_weight"
  difficulty: 4
  icon: "menus/scalesboard_weight.svg"
  author: "Wolfram Sang <wolfram@iswi.org>"
  demo: true
  title: qsTr("Balance the scales properly")
  description: qsTr("Drag and Drop masses to balance the scales and calculate the weight")
  goal: qsTr("Mental calculation, arithmetic equality, unit conversion")
  prerequisite: ""
  manual: qsTr("To balance the scales, move the masses on the left or the right side. Take care of the weight and the unit of the masses, remember that a kilogram (kg) is 1000 grams (g). They can be arranged in any order.")
  credit: qsTr("The painting is an original painting created by Virginie MOREAU (virginie.moreau@free.fr) in 2001. Its name is 'Spices Seller in Egypt'. It is released under the GPL license.")
}
