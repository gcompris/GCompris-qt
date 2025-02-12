/* GCompris - FoldDownRadio.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.15
import QtQuick.Controls.Basic

import "."
import "../singletons"

Column {
    id: foldDown
    required property ListModel foldModel
    required property string indexKey
    required property string nameKey
    required property string checkKey
    required property string title

    property int lineHeight: Style.defaultLineHeight
    property bool activated: true
    property bool collapsable: true
    property int currentChecked: -1
    property string delegateName: "radio"

    enabled: activated
    visible: activated
    spacing: 0
    clip: true

    signal selectionClicked(int modelId, bool checked)

    ButtonGroup {
        id: childGroup
        exclusive: foldDown.delegateName.includes("radio")
    }

    // Folddown header
    Rectangle {
        width: parent.width
        height: foldDown.lineHeight
        color: Style.colorHeaderPane
        radius: 5

        SmallButton {
            id: clearButton
            width: foldDown.lineHeight
            height: foldDown.lineHeight
            anchors.left: parent.left
            font.pixelSize: Style.defaultPixelSize
            text: "\uf068"
            enabled: collapseButton.checked && ((childGroup.checkedButton != null) || (!childGroup.exclusive))
            onClicked: {    // Uncheck all buttons
                if (childGroup.exclusive) {
                    childGroup.checkedButton = null
                    foldDown.currentChecked = -1
                    foldDown.selectionClicked( -1, checked)
                }
                for (var i = 0; i < childGroup.buttons.length; i++)
                    foldDown.foldModel.setProperty(i, foldDown.checkKey, false)
            }
        }

        Text {
            anchors.left: clearButton.right
            anchors.right: counter.left
            anchors.leftMargin: 5
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Style.defaultPixelSize
            font.bold: true
            text: (!collapseButton.checked) && (childGroup.checkedButton != null) ? childGroup.checkedButton.text : foldDown.title
            color: enabled ? "black": "gray"
        }

        Text {
            id: counter
            anchors.right: foldDown.collapsable ? collapseButton.left: parent.right
            anchors.rightMargin: 10
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            font.pixelSize: Style.defaultPixelSize
            font.bold: true
            text: foldDown.foldModel.count
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
        }

        SmallButton {
            id: collapseButton
            width: foldDown.lineHeight
            height: foldDown.lineHeight
            anchors.right: parent.right
            visible: foldDown.collapsable
            checkable: true
            checked: true
            font.pixelSize: Style.defaultPixelSize
            text: checked ? "\uf0d7" : "\uf0d9"
            onCheckedChanged: foldDown.SplitView.maximumHeight = (foldDown.SplitView.maximumHeight === Infinity) ? 25 : Infinity
        }
    }

    // Folddown lines
    Rectangle {
        id: elements
        width: parent.width
        height: parent.height
        radius: 5
        color: Style.colorBackgroundPane
        ScrollView {
            id: scrollLines
            anchors.fill: parent
            anchors.bottomMargin: foldDown.lineHeight
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy: ScrollBar.AlwaysOn

            Column {
                id: boxes
                spacing: 2

                Repeater {
                    model: foldDown.foldModel
                    delegate: Loader {
                        width: elements.width
                        height: foldDown.lineHeight
                        sourceComponent: {
                            switch(foldDown.delegateName) {
                            case "radio":
                                return radioSimpleDelegate
                            case "radioActivity":
                                return radioActivityDelegate
                            case "radioGroupEdit":
                                return radioGroupEditDelegate
                            case "checkUserStatus":
                                return checkUserStatusDelegate
                            case "checkUserEdit":
                                return checkUserEditDelegate
                            default:
                                return emptyDelegate
                            }
                        }

                        Component {     // Delegate for wrong delegateName
                            id: emptyDelegate
                            Control {
                                id: lineBox
                                font.pixelSize: Style.defaultPixelSize
                                hoverEnabled: true
                                Rectangle {
                                    anchors.fill: parent
                                    color: lineBox.hovered ? Style.colorHeaderPane : "transparent"
                                }
                                Text { text: eval(nameKey) }
                            }
                        }

                        // Externals delegates
                        Component {
                            id: radioSimpleDelegate
                            RadioSimpleDelegate {}      // Basic radio button
                        }

                        Component {
                            id: radioActivityDelegate
                            RadioActivityDelegate {}    // Need to pick up the activity's title in allActivities
                        }

                        Component {
                            id: radioGroupEditDelegate
                            RadioGroupEditDelegate {}   // Editions buttons for groups
                        }

                        Component {
                            id: checkUserStatusDelegate
                            CheckUserStatusDelegate {}  // Add user's connection status
                        }

                        Component {
                            id: checkUserEditDelegate
                            CheckUserEditDelegate {}    // Add user's connection status
                        }
                    }
                }
            }
        }
    }
}
