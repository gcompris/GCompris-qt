import GCompris 1.0

ActivityInfo {
  name: "mazeinvisible/Mazeinvisible.qml"
  difficulty: 4
  icon: "mazeinvisible/mazeinvisible.svg"
  author: "Stephane Mankowski <stephane@mankowski.fr>"
  demo: false
  title: qsTr("Invisible Maze")
  description: qsTr("Find your way out of the invisible maze")
//  intro: "Use the arrow keys to guide Tux out. Use the space key to see the map."
  goal: qsTr("Help Tux get out of this maze.")
  prerequisite: qsTr("Can use the keyboard arrow to move an object.")
  manual: qsTr("Use the keyboard arrows to move Tux up to the door. Use the spacebar to switch between invisible and visible modes. Visible mode just gives you an indication of your position, like a map. You cannot move Tux in visible mode.

At the first levels, Tux walks comfortably, one step on each keypress, through the labyrinth.

For larger labyrinths, there is a special walking mode, called \"run-fast-mode\". If this run-fast-mode is enabled, Tux will run all the way automatically until he reaches a fork and you have to decide which way to go further.

You can see whether this mode is enabled or not, by looking at Tux's feet: If Tux is barefooted, \"run-fast-mode\" is disabled. And if he wears red sport shoes, \"run-fast-mode\" is enabled.

From level 14 on, run-fast-mode will be enabled automatically. If you want to use this feature in earlier levels or want to disable it in advanced levels, click on Tux or the \"barefoot / sportshoe\"-icon in the upper left corner of the screen to toggle the run-fast-mode.
")
  credit: ""
  section: "/discovery/mazeMenu"
}
