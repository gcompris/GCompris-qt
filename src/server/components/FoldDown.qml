/* GCompris - FoldDown.qml
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

Item {
    id: foldDown
    required property ListModel foldModel
    required property string indexKey
    required property string nameKey
    required property string checkKey
    required property string title

    property bool activated: true
    property bool filterVisible: true
    property bool collapsable: true
    property int currentChecked: -1
    property string titleKey: nameKey
    property string delegateName: "check"
    property alias foldDownFilter: foldDownFilter
    property alias filterButton: filterButton
    property alias childGroup: childGroup
    // Used to trigger selectionClicked() even if it's not visible,
    // useful especially when changing locale to refresh Dataset view if an activity was selected
    property bool clickOnClear: false

    enabled: activated
    visible: activated

    signal selectionClicked(int modelId, bool checked)

    ButtonGroup {
        id: childGroup
        exclusive: foldDown.delegateName.includes("radio")

        onCheckStateChanged: {
            if(checkState === Qt.Unchecked) {
                clearSelection();
            }
        }
    }

    function clearSelection() {
        currentChecked = -1;
        if(visible || clickOnClear) {
            selectionClicked(-1, false);
        }
    }

    // Folddown header
    Rectangle {
        id: foldDownHeader
        width: parent.width
        height: Style.lineHeight
        color: Style.selectedPalette.base
        border.width: Style.defaultBorderWidth
        border.color: Style.selectedPalette.accent

        // button used for radio lists
        SmallButton {
            id: clearButton
            visible: childGroup.exclusive
            anchors.left: parent.left
            icon.source: "qrc:/gcompris/src/server/resource/icons/minus.svg"
            enabled: collapseButton.checked && childGroup.checkState != Qt.Unchecked
            onClicked: {    // Uncheck all buttons
                for(var i = 0; i < childGroup.buttons.length; i++) {
                    foldDown.foldModel.setProperty(i, foldDown.checkKey, false);
                }
            }
        }

        // button used for checkbox lists
        StyledCheckBox {
            id: parentBox
            visible: !childGroup.exclusive
            anchors.left: parent.left
            anchors.margins: Style.margins + Style.smallMargins
            enabled: foldDownFilter.text === ""
            linkedGroup: childGroup
            onClicked: {
                foldDown.currentChecked = parentBox.checked ? -2 : -1 // -2 = all checked, -1 = none
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
            visible: foldDown.filterVisible
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
                activeFocusOnTab: filterButton.checked
            }
        }

        SmallButton {
            id: filterButton
            anchors.right: counter.left
            anchors.rightMargin: visible ? Style.smallMargins : 0
            width: visible ? height : 0
            visible: foldDown.filterVisible
            checkable: true
            icon.source: "qrc:/gcompris/src/server/resource/icons/filter.svg"
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

        CollapseButton {
            id: collapseButton
            anchors.right: parent.right
            visible: foldDown.collapsable
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
        anchors.top: foldDownHeader.bottom
        anchors.bottom: parent.bottom
        color: Style.selectedPalette.alternateBase

        Flickable {
            id: scrollLines
            anchors.fill: parent
            contentWidth: width
            contentHeight: boxes.height
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            clip: true

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
                contentItem: Rectangle {
                    implicitWidth: 6
                    radius: width
                    opacity: scrollLines.contentHeight > scrollLines.height ? 1 : 0
                    color: parent.pressed ? Style.selectedPalette.highlight : Style.selectedPalette.button
                }
            }

            Column {
                id: boxes
                height: implicitHeight

                Repeater {
                    model: foldDown.foldModel
                    delegate: Loader {
                        width: elements.width
                        height: Style.lineHeight
                        visible: String(eval(titleKey)).toUpperCase().includes(foldDownFilter.text.toUpperCase())

                        source: {
                            switch(foldDown.delegateName) {
                            case "check":
                                return "CheckSimpleDelegate.qml"
                            case "checkUserEdit":
                                return "CheckUserEditDelegate.qml"
                            case "checkUserStatus":
                                return "CheckUserStatusDelegate.qml"
                            case "checkActivity":
                                return "CheckActivityDelegate.qml"
                            case "radio":
                                return "RadioSimpleDelegate.qml"
                            case "radioActivity":
                                return "RadioActivityDelegate.qml"
                            case "radioGroupEdit":
                                return "RadioGroupEditDelegate.qml"
                            default:
                                return ""
                            }
                        }
                    }
                }

                Item {
                    width: 1
                    height: Style.bigMargins
                }
            }
        }
    }
}
