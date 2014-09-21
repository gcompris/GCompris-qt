import GCompris 1.0

ActivityInfo {
   function genManual() {
         var out = qsTr("Prime numbers are numbers that are only divisible by themselves and 1. For example, 3 is a prime number, but 4 isn't (because 4 is divisible by 2). You can think of prime numbers as very small families: they only ever have two people in them! Only themselves and 1. You can't fit any other numbers into them with nothing left over. 5 is one of these lonely numbers (only 5 × 1 = 5), but you can see that 6 has 2 and 3 in its family as well (6 × 1 = 6, 2 ×3 = 6). So 6 is not a prime number. <br>")
         out += !ApplicationInfo.isMobile ? qsTr("Use the arrow keys to navigate around the board and to avoid the Troggles. Press the space bar to eat the number") : qsTr("Touch cells to move around the board and to avoid the Troggles. Press the Muncher to eat the number")
         return out
   }

  name: "gnumch-primes/GnumchPrimes.qml"
  difficulty: 6
  icon: "gnumch-primes/gnumch-primes.svg"
  author: "Manuel Tondeur <manueltondeur@gmail.com>"
  demo: false
  title: qsTr("Gnumch Primes")
  description: qsTr("Guide the Number Muncher to all the prime numbers.")
//  intro: "Guide the number eater with the arrow keys to the prime numbers and press space to swallow them."
  goal: qsTr("Learn about prime numbers.")
  prerequisite: qsTr("")
  manual: genManual()
  credit: qsTr("")
  section: "/math/algebramenu"
}
