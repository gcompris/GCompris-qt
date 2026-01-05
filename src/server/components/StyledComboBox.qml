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
    focus: true

    // For now, supports model as list of number/string or list of objects with key-value pairs to define text and role.
    property alias model: menuList.model
    property alias currentIndex: menuList.currentIndex
    property alias currentText: button.text

    // Properties and functions usable only if model is a list of objects with key-value pairs.
    property string textRole: ""
    property string valueRole: ""

    signal selectIndex(int index)

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
            if(listPopup.opened) {
                button.selectIndex(menuList.currentIndex);
                hideMenu();
            } else {
                showMenu();
            }
        } else if(event.key == Qt.Key_Down) {
            event.accepted = true;
            menuList.incrementCurrentIndex();
            if(!listPopup.opened) {
               button.selectIndex(menuList.currentIndex);
            }
        } else if(event.key == Qt.Key_Up) {
            event.accepted = true;
            menuList.decrementCurrentIndex();
            if(!listPopup.opened) {
                button.selectIndex(menuList.currentIndex);
            }
        }
    }

    onCheckedChanged: {
        if(checked) {
            showMenu();
        } else if(listPopup.opened) {
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

    onVisibleChanged: {
        if(listPopup.opened) {
            listPopup.close();
        }
    }

    // Used to detect window resize to auto-close the popup
    readonly property int windowWidth: Window.width
    readonly property int windowHeight: Window.height
    onWindowWidthChanged: {
        if(listPopup.opened) {
            listPopup.close();
        }
    }
    onWindowHeightChanged: {
        if(listPopup.opened) {
            listPopup.close();
        }
    }

    // Need an intermediate property since actual menuList height is always 0 while the popup is closed.
    property int listHeight: Math.min(menuList.contentHeight, Window.height - 2 * Style.defaultBorderWidth)

    function showMenu() {
        var popupHeight = Math.min(Window.height, listHeight + 2 * Style.defaultBorderWidth);
        var buttonGlobalPosition = button.mapToItem(Window.contentItem, 0, 0);
        var minY = 0;
        var maxY = Window.height - popupHeight;
        var adjustedY = Math.max(minY, Math.min(buttonGlobalPosition.y, maxY));
        listPopup.height = popupHeight;
        listPopup.y = adjustedY;
        listPopup.x = buttonGlobalPosition.x;
        listPopup.open();
    }

    function hideMenu() {
        listPopup.close();
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

    Popup {
        id: listPopup
        parent: Overlay.overlay
        width: button.width
        height: 1
        x: 0
        y: 0
        modal: false
        padding: 0

        onClosed: {
            button.checked = false;
        }

        background: Rectangle {
            color: Style.selectedPalette.base
            border.color: Style.selectedPalette.accent
            border.width: Style.defaultBorderWidth
        }

        ListView {
            id: menuList
            x: Style.defaultBorderWidth
            y: Style.defaultBorderWidth
            contentHeight: Style.controlSize * model.length
            width: button.width - 2 * Style.defaultBorderWidth
            height: button.listHeight
            clip: true
            keyNavigationEnabled: false
            boundsBehavior: Flickable.StopAtBounds

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
                        button.selectIndex(menuList.currentIndex);
                        listPopup.close();
                    }
                }
            }
        }
    }
}
