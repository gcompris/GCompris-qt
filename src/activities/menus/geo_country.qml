import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "geo_country"
  dir: "src/activities/geo_country"
  difficulty: 2
  icon: "menus/france_region.svg"
  author: "Jean-Philippe Ayanides <jp.ayanides@free.fr>"
  demo: true
  title: qsTr("Locate the region")
  description: qsTr("Drag and Drop the regions to redraw the whole country")
  goal: ""
  prerequisite: qsTr("Mouse manipulation: movement, drag and drop")
  manual: ""
  credit: qsTr("The map of Germany comes from Wikipedia and is released under the GNU Free Documentation License. Olaf Ronneberger and his children Lina and Julia Ronneberger created the German level.")
}
