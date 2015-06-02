import GCompris 1.0

ActivityInfo {
  name: "color_mix_light/ColorMixLight.qml"
  difficulty: 4
  icon: "color_mix_light/colormixlight.svg"
  author: "Stephane Mankowski <stephane@mankowski.fr>"
  demo: true
  title: qsTr("Mixing colors of light")
  description: qsTr("Discover light color mixing.")
//  intro: "Match the colour by moving the sliders on the torches"
  goal: qsTr("Mix the primary colors to match to the given color.")
  prerequisite: ""
  manual: qsTr("
The activity deals with mixing primary colors of light (additive mixing).

In case of light it is just the opposite of mixing color with paints! The more light you add the lighter the resultant color will get. Primary colors of light are red, green and blue.
        ")
  credit: "http://openclipart.org"
  section: "experiment color"
}
