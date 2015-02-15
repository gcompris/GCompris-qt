/*GCompris-Qt Message.qml ... */

import QtQuick 2.1
import "../../core"
import GCompris 1.0

Item{
    id: message

    property alias text: intro_text.text
    property bool displayed: intro_text.text != "" ? true : false
    property string intro2: qsTr("Since the gravitational force is directly proportional to the"
                                 +"\n"+" mass of both interacting objects, more massive objects will"
                                 +"\n"+" attract each other with a greater gravitational force."
                                 +"\n"+" So as the mass of either object increases, the force of"
                                 +"\n"+" gravitational attraction between them also increases but"
                                 +"\n"+" this force is inversely proportional to the square of the"
                                 +"\n"+" separation distance between the two interacting objects,"
                                 +"\n"+" more separation distance will result in weaker gravitational"
                                 +"\n"+" forces.")
    property string intro3: qsTr("Your goal is to let Tux's spaceship move by changing the mass"
                                 +"\n"+" of its surrounding planets. Don't get too close to the planets"
                                 +"\n"+" or you will crash on them."
                                 +"\n"+" The arrow indicates the direction of the force on your ship.")
    property string intro4: qsTr("Avoid the asteroid and join the space"
                           +"\n"+" shuttle to win.")

    Rectangle{
        id: intro_textbg
        x: intro_text.x -4
        y: intro_text.y -4
        width: intro_text.width +8
        height: intro_text.height +8
        color: "#dd1111ff"
        border.color: "#ffffff"
        border.width: 2
        radius: 8
        opacity: message.displayed ? 1 : 0
        MouseArea{
            anchors.fill: parent
            onClicked: message.text = qsTr("")
        }
        Behavior on opacity { NumberAnimation {duration: 100 } }

    }

    GCText{
        id: intro_text
        text: qsTr("Gravity is universal and Newton's law of universal gravitation extends gravity beyond earth."+"\n"+
                   " This force of gravitational attraction is directly dependent upon the masses of both objects"+"\n"+
                   " and inversely proportional to the square of the distance that separates their centers.")
        fontSize: regularSize
        font.weight: Font.DemiBold
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors {
            top: parent.top
            topMargin: 30 *ApplicationInfo.ratio
            right: parent.right
            rightMargin: 30 * ApplicationInfo.ratio
            left: parent.left
            leftMargin: 30 * ApplicationInfo.ratio
        }
        color: "white"
        width: parent.width / 2
        wrapMode: Text.WordWrap
        opacity: message.displayed ? 1 : 0
        Behavior on opacity {  NumberAnimation { duration: 100} }
    }



}

