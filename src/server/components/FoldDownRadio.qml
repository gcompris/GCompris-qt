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
import QtQuick.Layouts 1.15
import "../singletons"
import "../dialogs"

Column {
    id: foldDown
    property int lineHeight: Style.defaultLineHeight
    property string title: "Nom du truc"
    property bool activated: true
    property bool collapsable: true
    property var foldModel: null
    property int currentChecked: -1
    property string indexKey: ""
    property string nameKey: ""
    property string checkKey: ""
    property string delegateName: "radio"

    enabled: activated
    visible: activated
    spacing: 0
    clip: true

    signal selectionClicked(int modelId)

    ButtonGroup {
        id: childGroup
        exclusive: delegateName.includes("radio")
    }

    // Folddown header
    Rectangle {
        width: parent.width
        height: lineHeight
        color: Style.colorHeaderPane
        radius: 5
        Button {
            id: clearButton
            width: lineHeight
            height: lineHeight
            anchors.left: parent.left
            font.pixelSize: Style.defaultPixelSize
            text: "\uf068"
            enabled: collapseButton.checked && ((childGroup.checkedButton != null) || (!childGroup.exclusive))
            onClicked: {    // Uncheck all buttons
                if (childGroup.exclusive) {
                    childGroup.checkedButton = null
                    currentChecked = -1
                    selectionClicked( -1)
                }
                for (var i = 0; i < childGroup.buttons.length; i++)
                    foldModel.setProperty(i, checkKey, false)
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
            text: (!collapseButton.checked) && (childGroup.checkedButton != null) ? childGroup.checkedButton.text : title
            color: enabled ? "black": "gray"
        }

        Text {
            id: counter
            anchors.right: collapsable ? collapseButton.left: parent.right
            anchors.rightMargin: 10
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            font.pixelSize: Style.defaultPixelSize
            font.bold: true
            text: foldModel.count
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
        }

        SmallButton {
            id: collapseButton
            width: lineHeight
            height: lineHeight
            anchors.right: parent.right
            visible: collapsable
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
            anchors.bottomMargin: lineHeight
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy: ScrollBar.AlwaysOn
            Column {
                id: boxes
                spacing: 2
                Repeater {
                    model: foldModel
                    delegate: Loader {
                        width: elements.width
                        height: lineHeight
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
                        RadioSimpleDelegate {       // Basic radio button
                            id: radioSimpleDelegate
                        }

                        RadioActivityDelegate {     // Need to pick up the activity's title in allActivities
                            id: radioActivityDelegate
                        }

                        RadioGroupEditDelegate {    // Editions buttons for groups
                            id: radioGroupEditDelegate
                        }

                        CheckUserStatusDelegate {   // Add user's connection status
                            id: checkUserStatusDelegate
                        }

                        CheckUserEditDelegate {     // Add user's connection status
                            id: checkUserEditDelegate
                        }
                    }
                }
            }
        }
    }
}
