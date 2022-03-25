/* GCompris - orderingPlaceholder.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Harsh Kumar <hadron43@yahoo.com>
 *   Emmanuel Charruau <echarruau@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQml.Models 2.12
import QtQuick.Controls 2.12

import GCompris 1.0
import "../../core/core.js" as Core

Rectangle {
    id: orderingPlaceholder

    property ListModel placeholderListModel
    property Image highestParent
    // Mode : numbers | alphabets | sentences | chronology
    property string mode
    property string placeholderName

    property string elementKey
    property string targetPlaceholderKey

    property bool colorResetRequired: false

    border.color: placeholderDropArea.containsDrag ? "#FFFFFFFF" : "#00FFFFFF"
    border.width:  4 * ApplicationInfo.ratio
    color: placeholderDropArea.containsDrag ? "#B0FFFFFF" : "#80FFFFFF"
    width:  parent.width * 0.8
    radius: 10
    anchors.horizontalCenter: parent.horizontalCenter

    DelegateModel {
        id: originPHDelegateModel
        model: placeholderListModel

        delegate: OrderingElement {
            id: orderingElement
            mode: orderingPlaceholder.mode
            elementKey: orderingPlaceholder.elementKey
            index: DelegateModel.itemsIndex
            highestParent: orderingPlaceholder.highestParent
            placeholderName: orderingPlaceholder.placeholderName
        }
    }

    // Drop area to detect drops in the target placeholder
    DropArea {
        id: placeholderDropArea

        keys: orderingPlaceholder.targetPlaceholderKey
        anchors.fill: parent

        onDropped: {
            var element = drag.source
            var modelObj = {
                "elementValue" : element.draggableText,
                "borderColor" : "#808080"
            }
            if (element.placeholderName === "origin" && placeholderName === "target") {
                targetListModel.append(modelObj)
                targetListModel.setProperty(0,"placeholderName", "target")
                originListModel.remove(drag.source.index)
            }

            if (element.placeholderName === "target" && placeholderName === "origin") {
                originListModel.append(modelObj)
                originListModel.setProperty(0,"placeholderName", "origin")
                targetListModel.remove(drag.source.index)
            }
        }

        Flickable {
            id: flick
            width: parent.width
            height: parent.height
            clip: true
            flickableDirection: Flickable.VerticalFlick 
            contentWidth: originListView.width + 2*0.01 * placeholderDropArea.width
            contentHeight: originListView.height + 2*0.01 * placeholderDropArea.width

            Flow {
                id: originListView
                width: placeholderDropArea.width * 0.98
                spacing: 0.01 * placeholderDropArea.width
                anchors {
                    top: flick.contentItem.top
                    left: flick.contentItem.left
                    margins: 0.01 * placeholderDropArea.width
                }

                layoutDirection: (Core.isLeftToRightLocale(ApplicationSettings.locale)) ? Qt.LeftToRight : Qt.RightToLeft

                Repeater {
                    model: originPHDelegateModel
                }
            }
        }
    }
}


