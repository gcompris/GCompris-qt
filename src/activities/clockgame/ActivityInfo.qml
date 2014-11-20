import GCompris 1.0

ActivityInfo {
  name: "clockgame/Clockgame.qml"
  difficulty: 2
  icon: "clockgame/clockgame.svg"
  author: "Stephane Mankowski <stephane@mankowski.fr>"
  demo: false
  title: qsTr("Learning Clock")
  description: qsTr("Learn how to tell the time on an analog clock")
//  intro: "Use the mouse to drag and drop the needles of the clock and display the required time"
  goal: qsTr("Distinguish between time-units (hour, minute and second). Set and display time on an analog clock.")
  prerequisite: qsTr("The concept of time.")
  manual: qsTr("Set the clock to the given time, in the time-units shown (hours:minutes or hours:minutes:seconds). Drag the different arrows, to make the respective time unit go up or down.")
  credit: ""
  section: "discovery"
}
