/* GCompris - multiplication_tables.qml
 *
 * Copyright (C) 2016 YOUR NAME <xx@yy.org>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   YOUR NAME <YOUR EMAIL> (Qt Quick port)
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
import "multiplication_tables.js" as Activity
import "drawnumber_dataset.js" as Dataset

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


            property alias tabletext_1: tabletext_1
            property alias tabletext_2: tabletext_2
            property alias tabletext_3: tabletext_3
            property alias tabletext_4: tabletext_4
            property alias tabletext_5: tabletext_5
            property alias tabletext_6: tabletext_6
            property alias tabletext_7: tabletext_7
            property alias tabletext_8: tabletext_8
            property alias tabletext_9: tabletext_9
            property alias tabletext_10: tabletext_10

            property alias ans_1: ans_1
            property alias ans_2: ans_2
            property alias ans_3: ans_3
            property alias ans_4: ans_4
            property alias ans_5: ans_5
            property alias ans_6: ans_6
            property alias ans_7: ans_7
            property alias ans_8: ans_8
            property alias ans_9: ans_9
            property alias ans_10: ans_10

            property alias img_1: img_1
            property alias img_2: img_2
            property alias img_3: img_3
            property alias img_4: img_4
            property alias img_5: img_5
            property alias img_6: img_6
            property alias img_7: img_7
            property alias img_8: img_8
            property alias img_9: img_9
            property alias img_10: img_10

            property alias heading_text:heading_text

            property alias start_button: start_button
            property alias stop_button: stop_button
            property alias time: time
            property alias score: score


        }

        onStart: { Activity.start(items,mode,dataset,url) }
        onStop: { Activity.stop() }

//...........................................................................




// main heading
Text {
    id: heading_text

    font.family: "Helvetica"
    font.pointSize: 30
    color: "red"
    anchors.top: parent.top;
    anchors.margins: 20
    anchors.horizontalCenter: parent.horizontalCenter

}


// 10 questions
Text {
    id: tabletext_1
    font.family: "Helvetica"
    font.pointSize: 25
    font.bold: true
    color: "black"
    anchors.right : divider_img.left;
    anchors.top: heading_text.bottom

        anchors {
                        topMargin: 65
                        rightMargin: 360
                }
}


TextField {

            id:ans_1
            width: main.width - units.gu(25)
            height: 35
            font.pixelSize: 20
            anchors.left : tabletext_1.right
            anchors.top: heading_text.bottom
            anchors {
                            topMargin: 65
                            leftMargin: 40
                        }

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
    id:img_1
    visible: false
    width: 80; height: 60
    fillMode: Image.PreserveAspectFit
    anchors.left : ans_1.right
    anchors.top: heading_text.bottom
    anchors {
                    topMargin: 45
                    leftMargin: 40
                }

}





Text {
    id: tabletext_2
    font.family: "Helvetica"
    font.pointSize: 25
    color: "black"
    font.bold: true
    anchors.right : divider_img.left;
    anchors.top: tabletext_1.bottom
    anchors.margins: 20
    anchors {
                    topMargin: 40
                    rightMargin: 360
                }


}

TextField {

            id:ans_2
            width: main.width - units.gu(25)
            height: 35
            font.pixelSize: 20
            anchors.left : tabletext_2.right
            anchors.top: ans_1.bottom
            anchors {
                            topMargin: 50
                            leftMargin: 40
                        }

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
    id:img_2
    visible: false
    width: 80; height: 60
    fillMode: Image.PreserveAspectFit
    source: activity.url + "wrong.svg"
    anchors.left : ans_1.right
    anchors.top: ans_1.bottom
    anchors {
                    topMargin: 35
                    leftMargin: 40
                }

}





Text {
    id: tabletext_3
    font.family: "Helvetica"
    font.pointSize: 25
    color: "black"
    font.bold: true
    anchors.right : divider_img.left;
    anchors.top: tabletext_2.bottom
    anchors.margins: 20
    anchors {
                    topMargin: 40
                    rightMargin: 360
                }

}

TextField {

            id:ans_3
            width: main.width - units.gu(25)
            height: 35
            font.pixelSize: 20
            anchors.left : tabletext_3.right
            anchors.top: ans_2.bottom
            anchors {
                            topMargin: 50
                            leftMargin: 40
                        }

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
    id:img_3
    visible: false
    width: 80; height: 60
    fillMode: Image.PreserveAspectFit
    source: activity.url + "wrong.svg"
    anchors.left : ans_2.right
    anchors.top: ans_2.bottom
    anchors {
                    topMargin: 35
                    leftMargin: 40
                }

}




Text {
    id: tabletext_4
    font.family: "Helvetica"
    font.pointSize: 25
    color: "black"
    font.bold: true
    anchors.right : divider_img.left;
    anchors.top: tabletext_3.bottom
    anchors.margins: 20
    anchors {
                    topMargin: 40
                    rightMargin: 360
                }
}
TextField {

            id:ans_4
            width: main.width - units.gu(25)
            height: 35
            font.pixelSize: 20
            anchors.left : tabletext_4.right
            anchors.top: ans_3.bottom
            anchors {
                            topMargin: 50
                            leftMargin: 40
                        }

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
    id:img_4
    visible: false
    width: 80; height: 60
    fillMode: Image.PreserveAspectFit
    source: activity.url + "wrong.svg"
    anchors.left : ans_3.right
    anchors.top: ans_3.bottom
    anchors {
                    topMargin: 35
                    leftMargin: 40
                }

}






Text {
    id: tabletext_5
    font.family: "Helvetica"
    font.pointSize: 25
    color: "black"
    font.bold: true
    anchors.right : divider_img.left;
    anchors.top: tabletext_4.bottom
    anchors.margins: 20
    anchors {
                    topMargin: 40
                    rightMargin: 360
                }

}

TextField {

            id:ans_5
            width: main.width - units.gu(25)
            height: 35
            font.pixelSize: 20
            anchors.left : tabletext_5.right
            anchors.top: ans_4.bottom
            anchors {
                            topMargin: 50
                            leftMargin: 40
                        }

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
    id:img_5
    visible: false
    width: 80; height: 60
    fillMode: Image.PreserveAspectFit
    source: activity.url + "wrong.svg"
    anchors.left : ans_4.right
    anchors.top: ans_4.bottom
    anchors {
                    topMargin: 35
                    leftMargin: 40
                }

}





Image {
           id: divider_img

           anchors.horizontalCenter: parent.horizontalCenter
           anchors.top:heading_text.bottom
           source: activity.url + "divider_img.svg"
           sourceSize: width = parent.width/14,height = parent.height/1.6

           anchors {
                           topMargin: 15

                       }

       }



Text {
    id: tabletext_6
    font.family: "Helvetica"
    font.pointSize: 25
    color: "black"
    font.bold: true
    anchors.left : divider_img.right;
    anchors.top: heading_text.bottom
    anchors.margins: 20
    anchors {
                    topMargin: 65
                    leftMargin:160
                }

}

TextField {

            id:ans_6
            width: main.width - units.gu(25)
            height: 35
            font.pixelSize: 20
            anchors.left : tabletext_6.right
            anchors.top: heading_text.bottom
            anchors {
                            topMargin: 65
                            leftMargin: 40
                        }

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
    id:img_6
    visible: false
    width: 80; height: 60
    fillMode: Image.PreserveAspectFit
    source: activity.url + "wrong.svg"
    anchors.left : ans_6.right
    anchors.top: heading_text.bottom
    anchors {
                    topMargin: 50
                    leftMargin: 40
                }

}






Text {
    id: tabletext_7
    font.family: "Helvetica"
    font.pointSize: 25
    color: "black"
    font.bold: true
    anchors.left : divider_img.right;
    anchors.top: tabletext_6.bottom
    anchors.margins: 20
    anchors {
                    topMargin: 40
                    leftMargin: 160
                }

}

TextField {

            id:ans_7
            width: main.width - units.gu(25)
            height: 35
            font.pixelSize: 20
            anchors.left : tabletext_7.right
            anchors.top: ans_6.bottom
            anchors {
                            topMargin: 50
                            leftMargin: 40
                        }

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
    id:img_7
    visible: false
    width: 80; height: 60
    fillMode: Image.PreserveAspectFit
    source: activity.url + "wrong.svg"
    anchors.left : ans_7.right
    anchors.top: ans_6.bottom
    anchors {
                    topMargin: 40
                    leftMargin: 40
                }

}







Text {
    id: tabletext_8
    font.family: "Helvetica"
    font.pointSize: 25
    color: "black"
    font.bold: true
    anchors.left : divider_img.right;
    anchors.top: tabletext_7.bottom
    anchors.margins: 20
    anchors {
                    topMargin: 40
                    leftMargin: 160
                }

}

TextField {

            id:ans_8
            width: main.width - units.gu(25)
            height: 35
            font.pixelSize: 20
            anchors.left : tabletext_8.right
            anchors.top: ans_7.bottom
            anchors {
                            topMargin: 50
                            leftMargin: 40
                        }

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
    id:img_8
    visible: false
    width: 80; height: 60
    fillMode: Image.PreserveAspectFit
    source: activity.url + "wrong.svg"
    anchors.left : ans_8.right
    anchors.top: ans_7.bottom
    anchors {
                    topMargin: 40
                    leftMargin: 40
                }

}







Text {
    id: tabletext_9
    font.family: "Helvetica"
    font.pointSize: 25
    color: "black"
    font.bold: true
    anchors.left : divider_img.right;
    anchors.top: tabletext_8.bottom
    anchors.margins: 20
    anchors {
                    topMargin: 40
                    leftMargin: 160
                }

}

TextField {

            id:ans_9
            width: main.width - units.gu(25)
            height: 35
            font.pixelSize: 20
            anchors.left : tabletext_9.right
            anchors.top: ans_8.bottom
            anchors {
                            topMargin: 50
                            leftMargin: 40
                        }

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
    id:img_9
    visible: false
    width: 80; height: 60
    fillMode: Image.PreserveAspectFit
    source: activity.url + "wrong.svg"
    anchors.left : ans_9.right
    anchors.top: ans_8.bottom
    anchors {
                    topMargin: 40
                    leftMargin: 40
                }

}






Text {
    id: tabletext_10
    font.family: "Helvetica"
    font.pointSize: 25
    color: "black"
    font.bold: true
    anchors.left : divider_img.right;
    anchors.top: tabletext_9.bottom
    anchors.margins: 20
    anchors {
                    topMargin: 40
                    leftMargin: 160
                }

}

TextField {

            id:ans_10
            width: main.width - units.gu(25)
            height: 35
            font.pixelSize: 20
            anchors.left : tabletext_10.right
            anchors.top: ans_9.bottom
            anchors {
                            topMargin: 50
                            leftMargin: 23
                        }

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
    id:img_10
    visible: false
    width: 80; height: 60
    fillMode: Image.PreserveAspectFit
    anchors.left : ans_10.right
    anchors.top: ans_9.bottom
    anchors {
                    topMargin: 40
                    leftMargin: 40
                }

}


Button {
    id: stop_button
    text: " FINISH "
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
                GradientStop { position: 0 ; color: control.pressed ? "#729fcf" : "#729fcf" }
                GradientStop { position: 1 ; color: control.pressed ? "#3465a4" : "#3465a4" }
            }
        }
    }


    onClicked: {


        if(flag==1){


            score.visible = true
            var str1 = new Date().getTime() - startTime
            time.text = " Your time :- " + str1 + " ms"
            startTime = 0
            flag = 0
            start_button.text = "Start again"
            Activity.verifyAnswer()


        }
    }
}




Button {
    id: start_button
    text: " START "
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
                GradientStop { position: 0 ; color: control.pressed ? "#729fcf" : "#729fcf" }
                GradientStop { position: 1 ; color: control.pressed ? "#3465a4" : "#3465a4" }
            }
        }
    }


    onClicked: {

        if(startTime == 0 && flag==0){

            Activity.resetvalue()
            start_button.text = " START "
            time.text = " Your timer started..."
            startTime = new Date().getTime()
            flag = 1

        }

    }

}


Text {
    id: score
    font.pointSize: 25

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


       Text {
           id: time
           font.pixelSize: 27
           font.bold: true
           color: '#cc0000'
           anchors.bottom: start_button.top
           anchors.right: parent.right
           anchors {
                           bottomMargin: 30
                           rightMargin: 130
                       }
           text: "--"
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
                if(dataToSave && dataToSave["mode"]) {
                    background.easyMode = (dataToSave["mode"] === "true");
                }
            }

            onSaveData: {
                dataToSave = { "mode": "" + background.easyMode }
            }

            onClose: home()
        }



        DialogHelp {
            id: dialogHelp
            onClose: home()
        }




        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | config}
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
