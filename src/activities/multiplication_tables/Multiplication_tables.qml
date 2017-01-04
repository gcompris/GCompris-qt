/* GCompris - multiplication_tables.qml
 *
 * Copyright (C) 2016 Nitish Chauhan <nitish.nc18@gmail.com>
 *
 * Authors:
 *
 *   Nitish Chauhan <nitish.nc18@gmail.com> (Qt Quick port)
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

import "../../core"
import "multiplication_tables.js"
as Activity
import "multiplicationtables_dataset.js"
as Dataset


ActivityBase {
  id: activity

  property string url: "qrc:/gcompris/src/activities/multiplication_tables/resource/"
  property double startTime: 0
  property int flag: 0
  property var dataset: Dataset
  property string mode: "multiplicationtables"

  onStart: focus = true
  onStop: {}

  pageComponent: Rectangle {
    id: background
    anchors.fill: parent
    color: "#ABCDEF"
    signal start
    signal stop

    Component.onCompleted: {
      activity.start.connect(start)
      activity.stop.connect(stop)
    }

    // Add here the QML items you need to access in javascript
    QtObject {

      id: items
      property Item main: activity.main
      property alias background: background
      property alias bar: bar
      property alias bonus: bonus
      property alias heading_text: heading_text
      property alias start_button: start_button
      property alias stop_button: stop_button
      property alias time: time
      property alias score: score

      property alias questionGrid: questionGrid
      property alias repeater: repeater


    }

    onStart: {
      Activity.start(items, mode, dataset, url)

    }
    onStop: {
      Activity.stop()
    }

    //...........................................................................


    // main heading
    GCText {
      id: heading_text
      text:"Heading Text"
      font.pointSize: 30
      color: "red"
      anchors.top: parent.top;
      anchors.margins: 20
      anchors.horizontalCenter: parent.horizontalCenter

    }



    Grid {

        id: questionGrid

        spacing: 40


        anchors {

            left: parent.left
            right: parent.rigth
            top: heading_text.bottom
            margins: 20

        }


          Repeater {

                id: repeater
                model: 10

                Question {


                         }

          }


    }



//}


    Button {
      id: stop_button
      text: qsTr(" FINISH ")
      anchors.bottom: parent.bottom
      anchors.right: parent.right
      anchors {
        bottomMargin: 50
        rightMargin: 120
      }



      style: ButtonStyle {
        background: Rectangle {
          implicitWidth: 100
          implicitHeight: 40
          border.width: control.activeFocus ? 2 : 1
          border.color: "blue"
          radius: 4
          gradient: Gradient {
            GradientStop {
              position: 0;color: control.pressed ? "#729fcf" : "#729fcf"
            }
            GradientStop {
              position: 1;color: control.pressed ? "#3465a4" : "#3465a4"
            }
          }
        }
      }


        onClicked: {


        if (flag == 1) {


          score.visible = true
          var str1 = new Date().getTime() - startTime

          time.text = qsTr("Your time: %1 ms").arg(str1)


          startTime = 0
          flag = 0
          start_button.text = qsTr("Start again")
          Activity.verifyAnswer()


        }
      }
    }




    Button {
      id: start_button
      text: qsTr(" START ")
      anchors.bottom: parent.bottom
      anchors.right: stop_button.left
      anchors {
        bottomMargin: 50
        rightMargin: 30
      }

      style: ButtonStyle {
        background: Rectangle {
          implicitWidth: 100
          implicitHeight: 40
          border.width: control.activeFocus ? 2 : 1
          border.color: "blue"
          radius: 4
          gradient: Gradient {
            GradientStop {
              position: 0;color: control.pressed ? "#729fcf" : "#729fcf"
            }
            GradientStop {
              position: 1;color: control.pressed ? "#3465a4" : "#3465a4"
            }
          }
        }
      }


        onClicked: {

        if (startTime == 0 && flag == 0) {

          Activity.resetvalue()
          start_button.text = qsTr(" START ")
          time.text = qsTr(" Your timer started...")
          startTime = new Date().getTime()
          flag = 1

        }

      }

    }


    GCText {
      id: score
      font.pointSize: 20

        color: "#cc0000"
      font.bold: true

        anchors.bottom: time.top
      anchors.right: parent.right

        anchors {
        bottomMargin: 15
        rightMargin: 150


      }

        Layout.alignment: Qt.AlignCenter
    }




    //........implementing timer..............


    GCText {
      id: time
      font.pixelSize: 23
      font.bold: true
      color: '#cc0000'
      anchors.bottom: start_button.top
      anchors.right: parent.right
      anchors {
        bottomMargin: 30
        rightMargin: 130
      }
      text: qsTr("--")
      Layout.alignment: Qt.AlignCenter
    }



    //........timerend..........................................................




    //...........................................................................

    DialogActivityConfig {
      id: dialogActivityConfig
      currentActivity: activity
      content: Component {
        Item {
          height: column.height

            Column {
            id: column
            spacing: 10
            width: parent.width

              GCDialogCheckBox {
              id: easyModeBox1
              width: 250 * ApplicationInfo.ratio
              text: qsTr("School Mode")
              checked: background.easyMode
              onCheckedChanged: {
                background.easyMode = checked
                Activity.reloadRandom()
              }
            }

          }

        }
      }

        onLoadData: {
        if (dataToSave && dataToSave["mode"]) {
          background.easyMode = (dataToSave["mode"] === "true");
        }
      }

        onSaveData: {
        dataToSave = {
          "mode": "" + background.easyMode
        }
      }

        onClose: home()
    }



    DialogHelp {
      id: dialogHelp
      onClose: home()
    }




    Bar {
      id: bar
      content: BarEnumContent {
        value: help | home | level | config
      }
      onHelpClicked: {
        displayDialog(dialogHelp)
      }
      onPreviousLevelClicked: Activity.previousLevel()
      onNextLevelClicked: Activity.nextLevel()
      onHomeClicked: activity.home()
      onReloadClicked: Activity.reloadRandom()
      onConfigClicked: {
        dialogActivityConfig.active = true
        displayDialog(dialogActivityConfig)
      }
    }


    Bonus {
      id: bonus
      Component.onCompleted: win.connect(Activity.nextLevel)
    }
  }

}
