import GCompris 1.0

ActivityInfo {
  name: "maze/Maze.qml"
  difficulty: 1
  icon: "maze/maze.svg"
  author: "Stephane Mankowski <stephane@mankowski.fr>"
  demo: false
  title: qsTr("Maze")
  description: qsTr("Find your way out of the maze")
//  intro: "Use the arrows on your keyboard to find your way out."
  goal: qsTr("Help Tux get out of this maze.")
  prerequisite: qsTr("Can use the keyboard arrow to move an object.")
  manual: qsTr("Use the keyboard arrows to move Tux up to the door.

At the first levels, Tux walks comfortably, one step on each keypress, through the labyrinth.

For larger labyrinths, there is a special walking mode, called \"run-fast-mode\". If this run-fast-mode is enabled, Tux will run all the way automatically until he reaches a fork and you have to decide which way to go further.

You can see whether this mode is enabled or not, by looking at Tux's feet: If Tux is barefooted, \"run-fast-mode\" is disabled. And if he wears red sport shoes, \"run-fast-mode\" is enabled.

From level 14 on, run-fast-mode will be enabled automatically. If you want to use this feature in earlier levels or want to disable it in advanced levels, click on Tux or the \"barefoot / sportshoe\"-icon in the upper left corner of the screen to toggle the run-fast-mode.
\t")
  credit: ""
  section: "/discovery/mazeMenu"
}
