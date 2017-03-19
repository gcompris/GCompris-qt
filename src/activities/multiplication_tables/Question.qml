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
import "multiplicationtables_dataset.js" as Dataset
import "../../core"
import GCompris 1.0

Flow {
    id: questionItem
    property string url: "qrc:/gcompris/src/activities/multiplication_tables/resource/"
    property alias questionText: questionText.text
    property alias answerText: answerText.text
    property alias answerTextReadonly: answerText.readOnly
    property alias questionImage: question_image.source
    property alias questionImageOpacity: question_image.opacity

    GCText {
        id: questionText
        text:qsTr("Question")
        font.pointSize: 20
        font.bold: true
        color: "black"
    }

    TextField {
        id: answerText
        height: bar.height * 0.3
        width: bar.height * 0.9
        validator: IntValidator{bottom: 1; top: 200;}
        activeFocusOnPress: true
        readOnly: true
        horizontalAlignment: TextInput.AlignHCenter
        font.pixelSize: 24
        style: TextFieldStyle {
            textColor: "#006060"
            background: Rectangle {
                radius: 5
                color: "orange"
                implicitWidth: bar.height * 0.9
                implicitHeight: 130/800*parent.width
                border.color: "#333"
                border.width: 2
            }
        }
    }

    Image {
        id: question_image
        width: 130/800*parent.width
        height: 130/800*parent.width
        fillMode: Image.PreserveAspectFit
        source: "qrc:/gcompris/src/activities/multiplication_tables/resource/wrong.svg"
        opacity: 0
    }
}
