/* GCompris - StyledComboBox.qml
 *
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls.Basic
import "../singletons"

AbstractButton {
    id: button
    height: Style.controlSize
    text: menuList.currentItem ? menuList.currentItem.text : ""
    opacity: enabled ? 1 : 0.3

    // For now, supports model as list of number/string or list of objects with key-value pairs to define text and role.
    readonly property Item rootItem: Window.contentItem
    property int maxHeight: Window.height
    property alias model: menuList.model
    property alias currentIndex: menuList.currentIndex
    property alias currentText: button.text

    // Properties and functions usable only if model is a list of objects with key-value pairs.
    property string textRole: ""
    property string valueRole: ""

    function textAt(index_) {
        return model[index_][textRole];
    }

    function valueAt(index_) {
        return model[index_][valueRole];
    }

    function indexOfValue(value_) {
        var valueIndex = -1;
        for(var i = 0; i < model.length; i++) {
            if(model[i][valueRole] === value_) {
                valueIndex = i;
                break;
            }
        }
        return valueIndex;
    }


    Keys.onPressed: (event) => {
        if(event.key == Qt.Key_Enter || event.key == Qt.Key_Return || event.key == Qt.Key_Space) {
            event.accepted = true;
            button.checked = !button.checked;
        } else if(event.key == Qt.Key_Down) {
            event.accepted = true;
            menuList.incrementCurrentIndex();
        } else if(event.key == Qt.Key_Up) {
            event.accepted = true;
            menuList.decrementCurrentIndex();
        }
    }

    onCheckedChanged: {
        if(checked) {
            showMenu();
        } else {
            hideMenu();
        }
    }

    onActiveFocusChanged: {
        if(!activeFocus) {
            checked = false;
        }
    }

    onClicked: {
        checked = !checked;
    }

    function hideMenu() {
        menuContainer.visible = false;
        menuContainer.parent = button;
        menuContainer.x = 0;
        menuContainer.y = 0;
        menuContainer.z = 0;
    }

    function showMenu() {
        var buttonGlobalPosition = button.mapToItem(rootItem, 0, 0);
        var minY = 0;
        var maxY = rootItem.height - Style.margins - menuList.height;
        var menuGlobalY = Math.max(minY, Math.min(buttonGlobalPosition.y, maxY));
        menuContainer.parent = Window.contentItem;
        for(var i=0; i < Window.contentItem.children.length; i++) {
            var itemZ = Window.contentItem.children[i].z
            menuContainer.z = Math.max(menuContainer.z, itemZ);
        }
        menuContainer.y = menuGlobalY;
        menuContainer.x = buttonGlobalPosition.x;
        menuContainer.visible = true;
    }

    background: Rectangle {
        width: button.width
        height: button.height
        radius: Style.defaultRadius
        border.color: button.activeFocus ? Style.selectedPalette.text : Style.selectedPalette.accent
        border.width: Style.defaultBorderWidth
        color: button.down || button.checked ? Style.selectedPalette.accent :
                                                Style.selectedPalette.base
    }

    DefaultLabel {
        text: button.text
        color: button.down ? Style.selectedPalette.highlightedText : Style.selectedPalette.text
        anchors {
            verticalCenter: parent.verticalCenter
            left: button.left
            right: button.right
            leftMargin: Style.margins
            rightMargin: Style.controlSize + Style.smallMargins * 2
        }
        horizontalAlignment: Text.AlignLeft
        fontSizeMode: Text.VerticalFit
    }

    Image {
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            margins: Style.smallMargins
        }
        width: height
        source: "../resource/icons/" + Style.themePrefix + "dropdownArrow.svg"
        sourceSize.width: width
    }

    Rectangle {
        id: menuContainer
        visible: false
        width: button.width
        height: visible ? menuList.height + 2 * Style.defaultBorderWidth : 0
        color: Style.selectedPalette.base
        border.color: Style.selectedPalette.accent
        border.width: Style.defaultBorderWidth

        ListView {
            id: menuList
            x: Style.defaultBorderWidth
            y: Style.defaultBorderWidth
            contentHeight: contentItem.childrenRect.height
            width: parent.width - 2 * Style.defaultBorderWidth
            height: menuContainer.visible ? Math.min(contentHeight, button.maxHeight) : 0
            clip: true
            keyNavigationEnabled: false
            delegate: Rectangle {
                id: menuItem
                width: menuList.width
                height: Style.controlSize
                color: menuItem.index === menuList.currentIndex || listItemClick.pressed ?
                    Style.selectedPalette.highlight :
                    (listItemClick.containsMouse ? Style.selectedPalette.accent : "transparent")

                required property int index
                required property var modelData

                readonly property string text: button.textRole != "" ?
                    menuItem.modelData[button.textRole] : menuItem.modelData

                DefaultLabel {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        left: parent.left
                        margins: Style.smallMargins
                        leftMargin: Style.margins
                        rightMargin: Style.margins
                    }
                    horizontalAlignment: Text.AlignLeft
                    text: menuItem.text
                    color: menuItem.index === menuList.currentIndex || listItemClick.pressed ?
                        Style.selectedPalette.highlightedText :
                        Style.selectedPalette.text
                }

                MouseArea {
                    id: listItemClick
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        menuList.currentIndex = menuItem.index;
                        button.checked = false;
                    }
                }
            }
        }
    }
}
