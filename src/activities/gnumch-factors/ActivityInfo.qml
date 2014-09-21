import GCompris 1.0

ActivityInfo {
   function genManual() {
        var out = qsTr("The factors of a number are all the numbers that divide that number evenly. For example, the factors of 6 are 1, 2, 3 and 6. 4 is not a factor of 6 because 6 cannot be divided into 4 equal pieces. If one number is a multiple of a second number, then the second number is a factor of the first number. You can think of multiples as families, and factors are the people in those families. So 1, 2, 3 and 6 all fit into the 6 family, but 4 belongs to another family.<br>")
        out += !ApplicationInfo.isMobile ? qsTr("Use the arrow keys to navigate around the board and to avoid the Troggles. Press the space bar to eat the number") : qsTr("Touch cells to move around the board and to avoid the Troggles. Press the Muncher to eat the number")
        return out
   }

  name: "gnumch-factors/GnumchFactors.qml"
  difficulty: 5
  icon: "gnumch-factors/gnumch-factors.svg"
  author: "Manuel Tondeur <manueltondeur@gmail.com>"
  demo: false
  title: qsTr("Gnumch Factors")
  description: qsTr("Guide the Number Muncher to all the factors of the number at the top of the screen.")
//  intro: "Guide the number eater with the arrow keys to the factors of the displayed number and press space to swallow them."
  goal: qsTr("Learn about multiples and factors.")
  prerequisite: qsTr("")
  manual: genManual()
  credit: qsTr("")
  section: "/math/algebramenu"
}
