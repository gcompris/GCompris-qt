import GCompris 1.0

ActivityInfo {
  name: "clickgame/Clickgame.qml"
  difficulty: 1
  icon: "clickgame/clickgame.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Click On Me")
  description: qsTr("Left-Click with the mouse on all the swimming fish before they leave the fishtank")
//  intro: "Click on the fish with the left mouse button before they leave the aquarium."
  goal: qsTr("Motor coordination: moving and clicking the mouse.")
  prerequisite: qsTr("Mouse-manipulation")
  manual: qsTr("Use the left mouse button to click on the moving fish. A level 5 and after, a double click is mandatory.")
  credit: qsTr("Fish are taken from the Unix utility xfishtank. All image credits belong to Guillaume Rousse.")
  section: "/computer/mouse"
}
