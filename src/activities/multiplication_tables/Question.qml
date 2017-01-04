/* GCompris
 *
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1

import "multiplication_tables.js" as Activity

import QtGraphicalEffects 1.0
import "../../core"
import GCompris 1.0




Row {

   id: row1

   property string url: "qrc:/gcompris/src/activities/multiplication_tables/resource/"

   property alias questionText: tabletext_1.text
   property alias answerText: ans_1.text
   property alias questionImage: question_image.source
   property alias questionImage_visible: question_image.opacity




    // 10 questions
    GCText {
      id: tabletext_1
      text:"Question"
      font.pointSize: 20
      font.bold: true
      color: "black"

    }



  TextField {

      id: ans_1
      height: 35
      font.pixelSize: 20


      style: TextFieldStyle {
        textColor: "red"
        background: Rectangle {
          radius: 5
          color: "orange"
          implicitWidth: 100
          implicitHeight: 24
          border.color: "#333"
          border.width: 1
        }
      }

    }

  Image {
       id: question_image
       width: 70;height: 50
       fillMode: Image.PreserveAspectFit
       source: "qrc:/gcompris/src/activities/multiplication_tables/resource/wrong.svg"
       opacity: 0
     }



}



    
