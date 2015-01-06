import GCompris 1.0

ActivityInfo {
  name: "click_on_letter_up/ClickOnLetterUp.qml"
  difficulty: 1
  icon: "click_on_letter_up/click_on_letter_up.svg"
  author: "Holger Kaelberer <holger.k@elberer.de>"
  demo: false
  title: qsTr("Click on an uppercase letter")
  description: qsTr("Listen to a letter and click on the right one")
//  intro: "Click on the required letter. You can listen to it again by clicking on the mouth."
  goal: qsTr("Letter-name recognition")
  prerequisite: qsTr("Visual letter-recognition. Can move the mouse.")
  manual: qsTr("A letter is spoken. Click on the matching letter in the main area. You can listen to the letter again, by clicking on the mouth icon in the bottom box.")
  credit: ""
  section: "/reading"
}
