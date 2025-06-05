/* GCompris - FoldDownCheck.qml
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

import "."
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
    property string titleKey: nameKey
    property string delegateName: "check"
    property alias foldDownFilter: foldDownFilter
    property alias filterButton: filterButton

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

        StyledCheckBox {
            id: parentBox
            anchors.left: parent.left
            anchors.margins: Style.margins + Style.smallMargins
            enabled: foldDownFilter.text === ""
            linkedGroup: childGroup
            onClicked: {
                foldDown.currentChecked = checked ? -2 : -1 // -2 = all checked, -1 = none
                foldDown.selectionClicked(foldDown.currentChecked, checked)
            }
        }

        DefaultLabel {
            id: columnTitle
            anchors.left: parentBox.right
            anchors.right: filterButton.left
            anchors.margins: Style.margins
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignLeft
            font.bold: true
            text: foldDown.title
        }

        Rectangle {
            id: filterRect
            width: filterButton.checked ? 100 : 0
            height: parent.height
            anchors.right: filterButton.left
            color: Style.selectedPalette.alternateBase
            border.width: Style.defaultBorderWidth
            border.color: focus ? Style.selectedPalette.highlight : Style.selectedPalette.accent
            TextInput {
                id: foldDownFilter
                anchors.fill: parent
                anchors.leftMargin: Style.margins
                anchors.rightMargin: Style.margins
                verticalAlignment: Text.AlignVCenter
                clip: true
                font.pixelSize: Style.textSize
                color: Style.selectedPalette.text
                selectedTextColor: Style.selectedPalette.highlightedText
                selectionColor: Style.selectedPalette.highlight
            }
        }

        SmallButton {
            id: filterButton
            anchors.right: counter.left
            anchors.rightMargin: Style.smallMargins
            checkable: true
            text: "\uf0b0"
            onCheckedChanged: {
                if(!checked) {
                    foldDownFilter.text = "";
                } else {
                    foldDownFilter.focus = true
                }
            }
            toolTipOnHover: true
            toolTipText: qsTr("Filter list")
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
            anchors.bottomMargin: foldDown.lineHeight
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy: ScrollBar.AlwaysOn
            Column {
                id: boxes

                Repeater {
                    model: foldDown.foldModel
                    delegate: Loader {
                        width: elements.width
                        height: Style.lineHeight
                        visible: String(eval(titleKey)).toUpperCase().includes(foldDownFilter.text.toUpperCase())

                        source: {
                            switch(foldDown.delegateName) {
                            case "radio":
                                return "RadioSimpleDelegate.qml"
                            case "check":
                                return "CheckSimpleDelegate.qml"
                            case "checkUserEdit":
                                return "CheckUserEditDelegate.qml"
                            case "checkUserStatus":
                                return "CheckUserStatusDelegate.qml"
                            case "checkActivity":
                                return "CheckActivityDelegate.qml"
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
                            id: checkSimpleDelegate
                            CheckSimpleDelegate {}      // Basic checkbox
                        }

                        Component {
                            id: checkActivityDelegate
                            CheckActivityDelegate {}    // Need to pick up the activity's title in allActivities
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
