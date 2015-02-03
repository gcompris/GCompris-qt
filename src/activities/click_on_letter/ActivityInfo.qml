import GCompris 1.0

ActivityInfo {
  name: "click_on_letter/ClickOnLetter.qml"
  difficulty: 2
  icon: "click_on_letter/click_on_letter.svg"
  author: "Holger Kaelberer <holger.k@elberer.de>"
  demo: true
  title: qsTr("Click on a lowercase letter")
  description: qsTr("Listen to a letter and click on the right one")
//  intro: "Click on the required letter. You can listen to it again by clicking on the mouth."
  goal: qsTr("Letter-name recognition")
  prerequisite: qsTr("Visual letter-recognition.")
  manual: qsTr("A letter is spoken. Click on the matching letter in the main area. You can listen to the letter again, by clicking on the mouth icon in the bottom box.")
  credit: ""
  section: "reading"
}
