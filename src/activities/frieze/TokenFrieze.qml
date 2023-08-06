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

import "../../core"
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
    width: Activity.tokenSize
    height: Activity.tokenSize
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        radius: 10
        border.color: (animated) ? "transparent" : "burlywood"
        Image {
            id: image
            visible: shown
            anchors.fill: parent
            sourceSize.width: width
            sourceSize.height: height
        }
        Text {
            id: colorChar
            visible: shown
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 24
        }
    }
    states: [
        State {
            name: "fade"
            PropertyChanges {
                target: image
                opacity: 0.0
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
