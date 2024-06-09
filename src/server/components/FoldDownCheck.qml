/* GCompris - FoldDownCheck.qml
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
    property string titleKey: nameKey
    property string delegateName: "check"

    enabled: activated
    visible: activated
    spacing: 0
    clip: true

    signal selectionClicked(int modelId, bool checked)

    ButtonGroup {
        id: childGroup
        exclusive: delegateName.includes("radio")
        checkState: parentBox.checkState
    }

    // Folddown header
    Rectangle {
        width: parent.width
        height: lineHeight
        color: Style.colorHeaderPane
        radius: 5
        CheckBox {
            id: parentBox
            anchors.fill: parent
            anchors.leftMargin: 2
            font.pixelSize: Style.defaultPixelSize
            font.bold: true
            text: title
            enabled: foldDownFilter.text === ""
            checkState: childGroup.checkState
            onClicked: {
                currentChecked = checked ? -2 : -1          // -2 = all checked, -1 = none
                selectionClicked(currentChecked, checked)
            }
        }

        SmallButton {
            id: filterButton
            width: lineHeight
            height: lineHeight
            anchors.right: filterRect.left
            checkable: true
            font.pixelSize: Style.defaultPixelSize
            text: "\uf0b0"
            onCheckedChanged: {
                if (!checked) foldDownFilter.text = ""
                else foldDownFilter.focus = true
            }

            ToolTip.visible: hovered
            ToolTip.text: qsTr("Filter list")
        }

        Rectangle {
            id: filterRect
            width: filterButton.checked ? 60 : 0
            height: lineHeight - 6
            anchors.right: counter.left
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            border.width: 1
            border.color: focus ? "black" : Style.colorBackgroundPane
            TextInput {
                id: foldDownFilter
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                clip: true
                font.pixelSize: Style.defaultPixelSize
            }
        }


        Text {
            id: counter
            anchors.right: collapsable ? collapseButton.left: parent.right
            anchors.rightMargin: 5
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
            font.pixelSize: Style.defaultPixelSize
            visible: collapsable
            checkable: true
            checked: true
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
                        visible: String(eval(titleKey)).toUpperCase().includes(foldDownFilter.text.toUpperCase())

                        sourceComponent: {
                            switch(foldDown.delegateName) {
                            case "check":
                                return checkSimpleDelegate
                            case "checkUserEdit":
                                return checkUserEditDelegate
                            case "checkUserStatus":
                                return checkUserStatusDelegate
                            case "checkActivity":
                                return checkActivityDelegate
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
                        CheckSimpleDelegate {       // Basic checkbox
                            id: checkSimpleDelegate
                        }

                        CheckActivityDelegate {     // Need to pick up the activity's title in allActivities
                            id: checkActivityDelegate
                        }

                        CheckUserStatusDelegate {   // Add user's connection status
                            id: checkUserStatusDelegate
                        }

                        CheckUserEditDelegate {   // Add user's connection status
                            id: checkUserEditDelegate
                        }
                    }
                }
            }
        }
    }
}
