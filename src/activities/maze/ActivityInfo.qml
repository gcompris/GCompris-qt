import GCompris 1.0

ActivityInfo {
  name: "maze/Maze.qml"
  difficulty: 1
  icon: "maze/maze.svg"
  author: "Stephane Mankowski <stephane@mankowski.fr>"
  demo: true
  title: qsTr("Maze")
  description: qsTr("Help Tux get out of this maze")
//  intro: "Use the arrows keys or swipe the touch screen to help Tux find his way out."
  goal: ""
  prerequisite: ""
  manual: qsTr("Use the arrow keys or swipe the touch screen to move Tux up to the door.") + "<br><br>" +
          qsTr("At the first levels, Tux walks comfortably, one step on each move request, through the maze.") + "<br><br>" +
          qsTr("For larger mazes, there is a special walking mode, called \"run-fast-mode\". If this run-fast-mode is enabled, Tux will run all the way automatically until he reaches a fork and you have to decide which way to go further.")  + "<br><br>" +
          qsTr("You can see whether this mode is enabled or not, by looking at Tux's feet: If Tux is barefooted, \"run-fast-mode\" is disabled. And if he wears red sport shoes, \"run-fast-mode\" is enabled.") + "<br><br>" +
          qsTr("At higher levels, run-fast-mode will be enabled automatically. If you want to use this feature in earlier levels or want to disable it in advanced levels, click on the \"barefoot / sportshoe\"-icon in the upper left corner of the screen to toggle the run-fast-mode.
\t")
  credit: ""
  section: "discovery maze"
}
