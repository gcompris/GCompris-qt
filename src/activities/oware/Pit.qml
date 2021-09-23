/* GCompris - Pit.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 *
 * Authors:
 *   Harsh Kumar <hadron43@yahoo.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.9
import GCompris 1.0

import "../../core"
import "oware.js" as Activity

Item {
    id: pit
    property int player
    property int index
    property bool responsive: true
    property bool label: true
    property bool highlight: false
    property string highlightColor: 'yellow'

    height: circle.height + ((label) ? text.height : 0)

    Component.onCompleted: {
        for(var i = 0; i < 9; ++i)
            representationListModel.append({ display: false })
        updateListModel()
    }

    // the number of seeds to be displayed in the pit
    property int seeds: 0

    onSeedsChanged: updateListModel()

    ListModel {
        id: representationListModel
    }

    function updateListModel () {
        var representation = ['000000000', '000010000', '100000001',
                        '000111000', '101000101', '101010101',
                        '101101101', '111010111', '111101111',
                        '111111111'] [Math.min(seeds, 9)]
        for(var i = 0; i < 9; ++i)
            representationListModel.set(i, {
                display: representation.charAt(i) == '1'
            })
    }

    function getSeedSize() {
        return 0.6 * gridView.cellWidth
    }

    Rectangle {
        id: circle
        color: (highlight ? highlightColor : '#c4c4c4')
        width: parent.width
        height: width
        radius: width / 2
        border {
            color: (player === 1 ? '#23B582' : player === 2 ? '#37539A' : undefined)
            width: 0.05 * width
        }

        GridView {
            id: gridView
            width: 1.414 * circle.radius
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            cellWidth: width / 3
            cellHeight: cellWidth
            interactive: false

            model: representationListModel
            delegate: Item {
                width: gridView.cellWidth
                height: gridView.cellHeight

                Rectangle {
                    width: 0.6 * parent.width
                    height: width
                    color: 'black'
                    visible: display
                    opacity: label ? 1 : 0.3
                    radius: width / 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    GCText {
        id: text
        anchors {
            top: label ? circle.bottom : undefined
            verticalCenter: label ? undefined : circle.verticalCenter
            horizontalCenter: circle.horizontalCenter
        }
        color: "#373737"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text: seeds.toString()
    }

    MouseArea {
        anchors.fill: parent
        enabled: responsive
        onClicked: {
            Activity.processMove(player, index)
        }
    }
}
