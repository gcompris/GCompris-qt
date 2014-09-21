import GCompris 1.0

ActivityInfo {
   function genManual() {
        var out = qsTr("The multiples of a number are all the numbers that are equal to the original number times another number. For example, 24, 36, 48 and 60 are all multiples of 12. 25 is not a multiple of 12 because there isn't any number that can be multiplied by 12 to get 25. If one number is a factor of a second number, then the second number is a multiple of the first number. Again, you can think of multiples as families, and factors are the people who belong to those families. The factor 5, has parents 10, grandparents 15, great-grandparents 20, great-great-grandparents 25, and every extra step of 5 is another great- in front! But the number 5 does not belong in the 8 or 23 families. You can't fit any number of 5s into 8 or 23 with nothing left over. So '8 isn't a multiple of 5, nor is 23. Only 5, 10, 15, 20, 25 ... are multiples (or families or steps) of 5.<br>")
        out += !ApplicationInfo.isMobile ? qsTr("Use the arrow keys to navigate around the board and to avoid the Troggles. Press the space bar to eat the number") : qsTr("Touch cells to move around the board and to avoid the Troggles. Press the Muncher to eat the number")
        return out
   }

  name: "gnumch-multiples/GnumchMultiples.qml"
  difficulty: 3
  icon: "gnumch-multiples/gnumch-multiples.svg"
  author: "Manuel Tondeur <manueltondeur@gmail.com>"
  demo: false
  title: qsTr("Gnumch Multiples")
  description: qsTr("Guide the Number Muncher to all the multiples of the number at the top of the screen.")
//  intro: "Guide the number eater with the arrow keys to the multiples of the displayed number and press space to swallow them."
  goal: qsTr("Learn about multiples and factors.")
  prerequisite: qsTr("")
  manual: genManual()
  credit: qsTr("")
  section: "/math/algebramenu"
}
