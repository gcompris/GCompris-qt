import GCompris 1.0

ActivityInfo {
  name: "searace1player/Searace1player.qml"
  difficulty: 6
  icon: "searace1player/searace1player.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Sea race (Single Player)")
  description: qsTr("Give good instructions to your ship in order to be first in the race.")
  goal: qsTr("In this activity, you will learn how to enter commands into a computer. Even if the language is extremely basic, you learn here how to think ahead and construct a program. This activity can be used to introduce the programming concept to children.")
  prerequisite: ""
  manual: qsTr("In the text entry, enter one command per line, to control your boat. Commands supported are displayed between the two entry areas. The 'left' and 'right' commands must be followed by an angle in degrees. The angle value is also called a 'parameter' to the left or right command. By default 45 degrees is used. The 'forward' command accepts a distance parameter. By default 1 is used.
For example:
- left 90: Make a perpendicular left turn
- forward 10: Go forward for 10 units (as displayed on the ruler).
The goal is to reach the right of the screen (the red line). When done, you can try to improve your program and start a new race with the same weather conditions by using the retry button. You can click and drag your mouse anywhere on the map to get a measurement in distance and angle. Going to the next level will give you more complex weather conditions.")
  credit: ""
  section: "/experience"
}
