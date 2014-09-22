import GCompris 1.0

ActivityInfo {
  name: "mining/Mining.qml"
  difficulty: 1
  icon: "mining/mining.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: true
  title: qsTr("Mining for gold")
  description: qsTr("Use the mousewheel to approach the rockwall and look for gold nuggets.")
//  intro: "Looking at the rockwall, you can see a sparkle somewhere. Move the mouse cursor next to this sparkle and use the mousewheel to zoom in."
  goal: qsTr("Learn to use the mousewheel to zoom in and out.")
  prerequisite: qsTr("You should be familiar with moving the mouse and clicking.")
  manual: qsTr("Looking at the rockwall, you can see a sparkle somewhere. Move the mouse cursor next to this sparkle and use the mousewheel to zoom in. If you zoomed in at maximum, a gold nugget will appear at the position of the sparkle. Click on the gold nugget to collect it.

Having collected the nugget, use the mousewheel to zoom out again. If you zoomed out at maximum, another sparkle will appear, showing the next gold nugget to collect. Collect enough nuggets to complete the level.

The truck in the lower, right corner of the screen will tell you the number of already collected nuggets and the total number of nuggets to collect in this level.

To start the tutorial, click on professor Tux (available at level 1) and let him show you, what to do next.

Have fun! :)")
  credit: qsTr("Thanks to the Tuxpaint team for providing the following sounds under GPL:
- realrainbow.ogg - used when a new gold nugget appears
- metalpaint.wav - remixed and used when a gold nugget is collected")
  section: "/computer/mouse"
}
