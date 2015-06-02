import GCompris 1.0

ActivityInfo {
  name: "mazeinvisible/Mazeinvisible.qml"
  difficulty: 4
  icon: "mazeinvisible/mazeinvisible.svg"
  author: "Stephane Mankowski <stephane@mankowski.fr>"
  demo: true
  title: qsTr("Invisible Maze")
  description: qsTr("Guide Tux out of the invisible maze")
//  intro: "Use the arrow keys or swipe the touch screen to guide Tux out. Use the maze icon or the space key to see the map."
  goal: ""
  prerequisite: ""
  manual: qsTr("Use the arrow keys to move Tux up to the door. Use the maze icon or the spacebar to switch between invisible and visible modes. Visible mode just gives you an indication of your position, like a map. You cannot move Tux in visible mode.") + "<br><br>" +
          qsTr("At the first levels, Tux walks comfortably, one step on each move request, through the maze.") + "<br><br>" +
          qsTr("For larger mazes, there is a special walking mode, called \"run-fast-mode\". If this run-fast-mode is enabled, Tux will run all the way automatically until he reaches a fork and you have to decide which way to go further.")  + "<br><br>" +
          qsTr("You can see whether this mode is enabled or not, by looking at Tux's feet: If Tux is barefooted, \"run-fast-mode\" is disabled. And if he wears red sport shoes, \"run-fast-mode\" is enabled.") + "<br><br>" +
          qsTr("At higher levels, run-fast-mode will be enabled automatically. If you want to use this feature in earlier levels or want to disable it in advanced levels, click on the \"barefoot / sportshoe\"-icon in the upper left corner of the screen to toggle the run-fast-mode.
\t")
  credit: ""
  section: "discovery maze"
}
