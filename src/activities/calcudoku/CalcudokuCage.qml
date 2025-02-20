/* GCompris - CalcudokuCage.qml
 *
 * SPDX-FileCopyrightText: 2023 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0
import "../../core"

Item {
    id: mCageCase
    property bool topWallVisible
    property bool leftWallVisible
    property bool rightWallVisible
    property bool bottomWallVisible

    property int cageLineSize: GCStyle.thickBorder

    Rectangle {
        id: topWall
        visible: topWallVisible
        color: GCStyle.darkerBorder
        height: cageLineSize
        width: parent.width + cageLineSize
        anchors.verticalCenter: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Rectangle {
        id: leftWall
        visible: leftWallVisible
        color: GCStyle.darkerBorder
        width: cageLineSize
        height: parent.height + cageLineSize
        anchors.horizontalCenter: parent.left
        anchors.verticalCenter: parent.verticalCenter
    }
    Rectangle {
        id: rightWall
        visible: rightWallVisible
        color: GCStyle.darkerBorder
        width: cageLineSize
        height: parent.height + cageLineSize
        anchors.horizontalCenter: parent.right
        anchors.verticalCenter: parent.verticalCenter
    }
    Rectangle {
        id: bottomWall
        visible: bottomWallVisible
        color: GCStyle.darkerBorder
        height: cageLineSize
        width: parent.width + cageLineSize
        anchors.verticalCenter: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
 
