/* GCompris - EditToolBar.qml
 *
 * SPDX-FileCopyrightText: 2025 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
// Display a toolbar with add, remove, move up and move down buttons
import QtQuick 2.15
import QtQuick.Controls.Basic
import QtQuick.Layouts

import "../singletons"

ToolBar {
    id: editToolBar

    // Mandatory properties
    required property ColumnLayout aView
    required property ListModel aPrototype
    required property ListModel aModel
    required property ScrollView aScrollView

    // Other properties, initialized with previous properties. Should not be set.
    readonly property bool addEnabled: aPrototype.multiple ? true : (aModel.count < 1)
    readonly property bool removeEnabled: aView.current !== -1
    readonly property bool upEnabled: aPrototype.multiple
               ? ((aModel !== null)
                  && (aModel.count > 1)
                  && (aView.current > 0)
                  && (aView.current !== -1))
               : false
    readonly property bool downEnabled: aPrototype.multiple
                 ? ((aModel !== null)
                    && (aModel.count > 1)
                    && (aView.current < aModel.count - 1)
                    && (aView.current !== -1))
                 : false

    anchors.margins: 3
    height: 25

    background: Rectangle {
        anchors.fill: parent
        color: Style.colorBackground
    }

    RowLayout {
        anchors.fill: parent

        ToolButton {        // Add button
            Layout.fillHeight: true
            Layout.preferredWidth: 50
            enabled: addEnabled
            text: "\uf067"
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Add")
            onClicked: {
                aModel.append(datasetEditor.createFromPrototype(aPrototype))
                aView.current = aModel.count -1
                aScrollView.ScrollBar.vertical.position = 1.0
            }
        }

        ToolButton {        // Remove button
            Layout.fillHeight: true
            Layout.preferredWidth: 50
            enabled: removeEnabled
            text: "\uf068"
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Remove")
            onClicked: {
                aModel.remove(aView.current)
                aView.current = -1
            }
        }

        ToolButton {        // Move up button
            Layout.fillHeight: true
            Layout.preferredWidth: 50
            enabled: upEnabled
            text: "\uf077"
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Move up")
            onClicked: {
                aModel.move(aView.current, aView.current - 1, 1)
                aView.current = aView.current - 1
                aScrollView.ScrollBar.vertical.position = aView.current / (mainRepeater.model.count + 1)
            }
        }

        ToolButton {        // Move down button
            Layout.fillHeight: true
            Layout.preferredWidth: 50
            enabled: downEnabled
            text: "\uf078"
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Move down")
            onClicked: {
                aModel.move(aView.current, aView.current + 1, 1)
                aView.current = aView.current + 1
                aScrollView.ScrollBar.vertical.position = aView.current / (mainRepeater.model.count + 1)
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }
}
