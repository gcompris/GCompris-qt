/* GCompris - FoldDownRadio.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls.Basic

import "../singletons"

Column {
    id: foldDown
    required property ListModel foldModel
    required property string indexKey
    required property string nameKey
    required property string checkKey
    required property string title

    property int lineHeight: Style.lineHeight // TODO: remove once all instances have been updated to not use it.
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
        height: Style.lineHeight
        color: Style.selectedPalette.base
        border.width: Style.defaultBorderWidth
        border.color: Style.selectedPalette.accent

        SmallButton {
            id: clearButton
            anchors.left: parent.left
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

        DefaultLabel {
            anchors.left: clearButton.right
            anchors.right: counter.left
            anchors.margins: Style.margins
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignLeft
            font.bold: true
            text: (!collapseButton.checked) && (childGroup.checkedButton != null) ? childGroup.checkedButton.text : foldDown.title
        }

        DefaultLabel {
            id: counter
            anchors.right: collapseButton.left
            anchors.rightMargin: Style.margins
            anchors.verticalCenter: parent.verticalCenter
            font.bold: true
            text: foldDown.foldModel.count
        }

        SmallButton {
            id: collapseButton
            width: visible ? height : 0
            anchors.right: parent.right
            visible: foldDown.collapsable
            checkable: true
            checked: true
            font.pixelSize: Style.textSize
            text: checked ? "\uf0d7" : "\uf0d9"
            onCheckedChanged: {
                if(checked) {
                    foldDown.SplitView.maximumHeight = Infinity;
                } else {
                    foldDown.SplitView.maximumHeight = Style.lineHeight;
                }
            }
        }
    }

    // Folddown lines
    Rectangle {
        id: elements
        width: parent.width
        height: parent.height
        color: Style.selectedPalette.alternateBase
        ScrollView {
            id: scrollLines
            anchors.fill: parent
            anchors.bottomMargin: Style.lineHeight
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy: ScrollBar.AlwaysOn

            Column {
                id: boxes

                Repeater {
                    model: foldDown.foldModel
                    delegate: Loader {
                        width: elements.width
                        height: Style.lineHeight
                        source: {
                            switch(foldDown.delegateName) {
                            case "radio":
                                return "RadioSimpleDelegate.qml"
                            case "radioActivity":
                                return "RadioActivityDelegate.qml"
                            case "radioGroupEdit":
                                return "RadioGroupEditDelegate.qml"
                            case "checkUserStatus":
                                return "CheckUserStatusDelegate.qml"
                            case "checkUserEdit":
                                return "CheckUserEditDelegate.qml"
                            default:
                                return ""
                            }
                        }
/* Replaced with direct url in Loader source...
                        Component {     // Delegate for wrong delegateName
                            id: emptyDelegate
                            Control {
                                id: lineBox
                                font.pixelSize: Style.textSize
                                hoverEnabled: true
                                Rectangle {
                                    anchors.fill: parent
                                    color: lineBox.hovered ? Style.selectedPalette.base : "transparent"
                                }
                                Text {
                                    text: eval(nameKey)
                                    color: Style.selectedPalette.text
                                }
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
                        }*/
                    }
                }
            }
        }
    }
}
