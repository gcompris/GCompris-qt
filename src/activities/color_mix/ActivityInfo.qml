import GCompris 1.0

ActivityInfo {
  name: "color_mix/ColorMix.qml"
  difficulty: 4
  icon: "color_mix/colormix.svg"
  author: "Stephane Mankowski <stephane@mankowski.fr>"
  demo: true
  title: qsTr("Mixing color of paint")
  description: qsTr("To understand color mixing.")
//  intro: "Match the colour by moving the sliders on the tubes of paint"
  goal: qsTr("Mix the primary colors to match to the given color")
  prerequisite: ""
  manual: qsTr("
The activity deals with mixing primary colors of paint (subtractive mixing).

In case of paints the inks absorb different colors of light falling on it, subtracting it from what you see. The more ink you add, the more light is absorbed, and the darker the combined color gets. We can mix just three primary colors to make many new colors. The primary colors for paint/ink are Cyan (a special shade of blue), Magenta (a special shade of pink), and Yellow.
        ")
  credit: "Images from http://openclipart.org"
  section: "experiment color"
}
