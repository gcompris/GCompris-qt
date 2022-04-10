/* GCompris - lang.qml
*
* Copyright (C) Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
*
* Authors:
*   Pascal Georges (pascal.georges1@free.fr) (GTK+ version)
*   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port of imageid)
*   Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
*   Bruno Coudoin <bruno.coudoin@gcompris.net> (Integration Lang dataset)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import GCompris 1.0

ActivityInfo {
  name: "lang/Lang.qml"
  difficulty: 4
  icon: "lang/lang.svg"
  author: "siddhesh suthar &lt;siddhesh.it@gmail.com&gt;"
  //: Activity title
  title: qsTr("Enrich your vocabulary")
  //: Help title
  description: qsTr("Complete language learning activities.")
  // intro: "Select the language you want to learn then review the words before doing the exercises."
  //: Help goal
  goal: qsTr("Enrich your vocabulary in your native language or in a foreign one.")
  //: Help prerequisite
  prerequisite: qsTr("Reading.")
  //: Help manual
  manual: qsTr("Review a set of words. Each word is shown with a voice, a text and an image.<br/>"
           + "When done, you will have some exercises to recognize the text from the voice and the image, then only from the voice, and finally an exercise to type the text.") + ("<br><br>") +
          qsTr("In the configuration, you can select the language you want to learn.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate") + ("</li><li>") +
          qsTr("Space or Enter: select an item from the list") + ("</li><li>") +
          qsTr("Enter: validate your answer when the OK button is visible") + ("</li><li>") +
          qsTr("Tab: repeat the word") + ("</li></ul>")
  credit: "Images originally released by the Art4Apps project (https://web.archive.org/web/20120908214126/http://www.art4apps.org/) under CC BY-SA 3.0 license. Upscaled and smoothed derivative images."
  section: "reading vocabulary"
  createdInVersion: 5000
}
