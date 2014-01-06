import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "memory_minus"
  dir: "src/activities/memory_minus"
  difficulty: 1
  icon: "menus/mem_solo_minus.svg"
  author: "Yves Combe <yves@ycombe.net>"
  demo: true
  title: qsTr("Subtraction memory game")
  description: qsTr("Turn the cards over to find two numbers which subtract the same, until all the cards are gone.")
  goal: qsTr("Practise subtraction, until all the cards are gone.")
  prerequisite: qsTr("Subtraction")
  manual: qsTr("You can see some cards, but you can't see what's on the other side of them. Each card is hiding a subtraction, or the answer to it.
A subtraction looks like this: 3 - 1 = 2
The numbers on one side of the equals sign (=) have to be the same as the number on the other side. So 3 (1, 2, 3) less 1 (1) makes 2. Count aloud when you work this out, and count on your fingers, because the more ways you do something, the better you remember it. You can also use blocks, or buttons, or anything you can count. If you have lots of brothers and sisters, you can count them! Or the kids in your class at school. Sing counting songs. Count lots of things, for practice, and you'll be very good at subtracting numbers!

In this game, these cards are hiding the two parts of a subtraction. You need to find the two parts of the subtraction, and bring them together again. Click on a card to see what number it's hiding, then try to find the other card that goes with it, to make a whole difference. You can only turn over two cards in one go, so you need to remember where the numbers are hiding, then you can match them when you find their other half. You're doing the job of the equals sign, and the numbers need you to put them together and make a proper difference. When you do that, both those cards disappear! When you've made them all disappear, found all the subtracts, you've won the game! :)")
  credit: ""
}
