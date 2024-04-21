/* GCompris - TokenFrieze.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno ANSELME <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * References : https://del-en-maternelle.fr/les-domaines/maths/les-algorithmes/
 *              https://irem.univ-nantes.fr/wp-content/uploads/2019/12/Algorithmes.pdf
 */
import QtQuick 2.12
import GCompris 1.0

import "qrc:/gcompris/src/core/core.js" as Core
import "frieze.js" as Activity

Item {
    id: token
    property string content: content_
    property bool clickable: clickable_
    property bool shown: shown_
    property bool animated: animated_
    property alias image: image
    property alias colorChar: colorChar
    width: 1
    height: width

    Rectangle {
        visible: !token.shown || token.content === Activity.emptyToken
        color: "#40373737"
        anchors.centerIn: parent
        width: image.width
        height: width
        radius: parent.height * 0.1
    }

    Image {
        id: image
        visible: shown
        anchors.centerIn: parent
        width: parent.width * 0.9
        height: width
        sourceSize.width: width
        sourceSize.height: height
        Image {
            id: colorChar
            visible: shown
            anchors.centerIn: parent
            width: parent.width * 0.5
            height: width
            sourceSize.width: width
            sourceSize.height: height
        }
    }
    states: [
        State {
            name: "fade"
            PropertyChanges {
                image {
                    opacity: 0.0
                }
            }
        }
    ]
    transitions: [
        Transition {
            to: "fade"
            SequentialAnimation {
                alwaysRunToEnd: true
                NumberAnimation { target: image; property: "opacity"; to: 0.0; duration: 200 }
                ScriptAction {  // End of cancelDrop
                    script: {
                        token.state = ""
                        answerModel.setProperty(items.currentAnswer, "content_", Activity.emptyToken)
                        Activity.initShape(answer.children[items.currentAnswer])
                        items.buttonsBlocked = false
                    }
                }
            }
        }
    ]
    MouseArea {
        anchors.fill: parent
        enabled: clickable
        onClicked: Activity.tokenClicked(index, content)
    }
    onContentChanged: if (Activity.started) Activity.initShape(token)
}
