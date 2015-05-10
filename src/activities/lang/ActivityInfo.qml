import GCompris 1.0

ActivityInfo {
  name: "lang/Lang.qml"
  difficulty: 4
  icon: "lang/lang.svg"
  author: "Siddhesh suthar<siddhesh.it@gmail.com>"
  demo: false
  title: qsTr("Lang activity")
  description: qsTr("List of words in the all categories.")
  goal: qsTr("Enrich your vocabulary in your native language or in a foreign one.")
  prerequisite: qsTr("Reading")
  manual: qsTr("Review a set of words. Each word is shown with a voice a text and an image.")
          + "<br><br>" + qsTr("When done you are suggested an exercise in which, given the voice,")
          + "<br><br>" + qsTr("you must find the right word. In the configuration you can select the language you want to learn.")
  credit: qsTr("The images and voices come from the Art4Apps project: http://www.art4apps.org/.")
          + "<br><br>" +qsTr(" You can also access this activity online on http://gcompris.net/activity/lang.")
  section: "reading"
}
