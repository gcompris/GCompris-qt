/* GCompris - Pit.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 *
 * Authors:
 *   Harsh Kumar <hadron43@yahoo.com>
 *   Timothée Giet <animtim@gmail.com> (redesign)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
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
    property string highlightColor: "#E77936" //orange
    property bool selected: false

    height: circle.height

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
        var representation = ["000000000", "000010000", "100000001",
                        "000111000", "101000101", "101010101",
                        "101101101", "111010111", "111101111",
                        "111111111"] [Math.min(seeds, 9)]
        for(var i = 0; i < 9; ++i)
            representationListModel.set(i, {
                display: representation.charAt(i) == "1"
            })
    }

    function getSeedSize() {
        return 0.9 * gridView.cellWidth
    }

    Rectangle {
        id: outline
        color: pit.selected ? "#D2D2D2" : (player === 1 ? "#23B582" : "#37539A")
        width: pit.selected ? 1.15 * circle.width : 1.05 * circle.width
        height: width
        radius: width * 0.5
        anchors.centerIn: circle
        visible: label
    }

    Rectangle {
        id: circle
        color: pit.highlight ? pit.highlightColor : "#8a4f28"
        width: parent.width
        height: width
        radius: width * 0.5
        anchors {
            bottom: player === 1 ? parent.bottom : undefined
            top: player === 2 ? parent.top : undefined
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

                Image {
                    source: Activity.url + "seed.svg"
                    width: 0.9 * parent.width
                    height: width
                    sourceSize.width: width
                    visible: display
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    Rectangle {
        id: labelHandBg
        height: pitLabel.height
        width: pitLabel.width
        radius: height * 0.25
        color: "#80FFFFFF"
        visible: !label
        anchors.centerIn: circle
    }

    GCText {
        id: pitLabel
        anchors {
            top: label && player === 2 ? circle.bottom : undefined
            topMargin: top != undefined ? board.margin : 0
            bottom: label && player === 1 ? circle.top : undefined
            bottomMargin: bottom != undefined ? board.margin : 0
            verticalCenter: label ? undefined : circle.verticalCenter
            horizontalCenter: circle.horizontalCenter
        }
        color: "#373737"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text: seeds.toString()
        width: parent.width * 0.5
        height: parent.height * 0.5
        fontSizeMode: Text.Fit
    }

    MouseArea {
        anchors.centerIn: parent
        width: parent.width + margin
        height: width
        enabled: responsive
        onClicked: {
            Activity.processMove(player, index)
        }
    }
}
