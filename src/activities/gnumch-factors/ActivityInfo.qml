import GCompris 1.0

// Must be updated once GnumchEquality is reviewed
ActivityInfo {
  name: "gnumch-factors/GnumchFactors.qml"
  difficulty: 5
  icon: "gnumch-factors/gnumch-factors.svg"
  author: "Manuel Tondeur <manueltondeur@gmail.com>"
  demo: true
  title: qsTr("Gnumch Factors")
  description: qsTr("Guide the Number Muncher to all the factors of the number at the top of the screen.")
//  intro: "Guide the number eater to the required numbers and press on it to swallow them."
  goal: qsTr("Learn about multiples and factors.")
  prerequisite: ""
  manual: qsTr("The factors of a number are all the numbers that divide that number evenly. For example, the factors of 6 are 1, 2, 3 and 6. 4 is not a factor of 6 because 6 cannot be divided into 4 equal pieces. If one number is a multiple of a second number, then the second number is a factor of the first number. You can think of multiples as families, and factors are the people in those families. So 1, 2, 3 and 6 all fit into the 6 family, but 4 belongs to another family.") +
          "<br><br>" +
          qsTr("If you have a keyboard you can use the arrow keys to move and hit space to swallow a number. With a mouse you can click on the block next to your position to move and click again to swallow the number. With a touch screen you can do like with a mouse or swipe anywhere in the direction you want to move and tap to swallow the number.") +
          "<br><br>" +
          qsTr("Take care to avoid the Troggles.")
  credit: ""
  section: "math"
}
