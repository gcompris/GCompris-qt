/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitgenius@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "details/Details.qml"
  difficulty: 1
  icon: "details/details.svg"
  author: "Pulkit Gupta &lt;pulkitgenius@gmail.com&gt;"
  //: Activity title
  title: qsTr("Find the details")
  //: Help title
  description: qsTr("Drag and Drop the shapes on their respective targets.")
//  intro: "Slide the images on their respective targets"
  goal: ""
  prerequisite: ""
  //: Help manual
  manual: qsTr("Complete the puzzle by dragging each piece on the side to the matching space in the puzzle.")
  credit: qsTr("The images are from Wikimedia Commons.") + ("<ul><li>") +
          ('"Chateau de Chenonceau 2008" by Ra-smit (https://commons.wikimedia.org/wiki/File:Chateau_de_Chenonceau_2008.jpg), CC BY-SA 3.0') + ("</li><li>") +
          ('"Egeskov Slot spejling" by Malene Thyssen (https://commons.wikimedia.org/wiki/File:Egeskov_Slot_spejling.jpg), CC BY-SA 3.0') + ("</li><li>") +
          ('"Eilean Donan castle - 95mm" by Guillaume Piolle (https://commons.wikimedia.org/wiki/File:Eilean_Donan_castle_-_95mm.jpg), CC BY 3.0') + ("</li><li>") +
          ('"DK Fanoe Windmill01" by Cnyborg (https://commons.wikimedia.org/wiki/File:DK_Fanoe_Windmill01.JPG), CC BY-SA 3.0') + ("</li><li>") +
          ('"Pyramids at Gizah" by Ricardo Liberato (https://commons.wikimedia.org/wiki/File:Pyramids_at_Gizah.jpg), CC BY-SA 2.0') + ("</li><li>") +
          ('"Louvre 2007 02 24 c" by Benh LIEU SONG (https://commons.wikimedia.org/wiki/File:Louvre_2007_02_24_c.jpg), CC BY-SA 3.0') + ("</li><li>") +
          ('"Nagoya Castle(Edit2)" by Base64 (https://commons.wikimedia.org/wiki/File:Nagoya_Castle(Edit2).jpg), CC BY-SA 3.0') + ("</li><li>") +
          ('"NotreDameDeParis" by Sanchezn (https://commons.wikimedia.org/wiki/File:NotreDameDeParis.jpg), CC BY-SA 3.0') + ("</li><li>") +
          ('"Castle Neuschwanstein" by Softeis (https://commons.wikimedia.org/wiki/File:Castle_Neuschwanstein.jpg), CC BY-SA 3.0') + ("</li><li>") +
          ('"Sydney Opera House - Dec_2008" by David Iliff (https://commons.wikimedia.org/wiki/File:Sydney_Opera_House_-_Dec_2008.jpg), CC BY-SA 3.0') + ("</li><li>") +
          ('"Taj Mahal in March 2004" by Dhirad (https://commons.wikimedia.org/wiki/File:Taj_Mahal_in_March_2004.jpg), CC BY-SA 3.0') + ("</li><li>") +
          ('"Tour Eiffel Wikimedia Commons" by Benh LIEU SONG (https://commons.wikimedia.org/wiki/File:Tour_Eiffel_Wikimedia_Commons.jpg), CC BY-SA 3.0') + ("</li><li>") +
          ('"Tower Bridge London Feb 2006" by David Iliff (https://commons.wikimedia.org/wiki/File:Tower_Bridge_London_Feb_2006.jpg), CC BY-SA 4.0') + ("</li></ul>")
  section: "discovery arts"
  createdInVersion: 4000
  levels: "1,2,3"
}
