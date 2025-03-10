/* GCompris - TopPanel.qml
*
* SPDX-FileCopyrightText: 2014 Manuel Tondeur <manueltondeur@gmail.com>
* SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
*
* Authors:
*   Joe Neeman (spuzzzzzzz@gmail.com) (GTK+ version)
*   Manuel Tondeur <manueltondeur@gmail.com> (Qt Quick port)
*   Timothée Giet <animtim@gmail.com> (refactoring)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import core 1.0

import "../../core"

Item {
    id: topPanel
    required property int goal
    required property string activityType
    property alias life: lifeImage.visible

    onGoalChanged: {
        goalText.text = goalText.setTextGoal(goal)
    }

    Rectangle {
        id: goalBg
        height: parent.height
        width: parent.width - (height + GCStyle.halfMargins) * 2
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        radius: GCStyle.halfMargins
        color: GCStyle.darkBg
        border.width: GCStyle.thinnestBorder
        border.color: GCStyle.lightBorder
    }

    GCText {
        id: goalText
        parent: goalBg
        anchors.fill: goalBg
        anchors.margins: GCStyle.halfMargins
        anchors.leftMargin: GCStyle.baseMargins
        anchors.rightMargin: GCStyle.baseMargins
        color: GCStyle.lightText

        function setTextGoal(goal: string): string {
            if (topPanel.activityType === "equality") {
                return qsTr("Equal to %1").arg(goal)
            } else if (topPanel.activityType === "inequality") {
                return qsTr("Not equal to %1").arg(goal)
            } else if (topPanel.activityType === "factors") {
                return qsTr("Factor of %1").arg(goal)
            } else if (topPanel.activityType === "multiples") {
                return qsTr("Multiple of %1").arg(goal)
            } else if (topPanel.activityType === "primes") {
                return qsTr("Primes less than %1").arg(goal)
            }
        }

        fontSizeMode: Text.Fit
        minimumPointSize: 7
        fontSize: largeSize
        font.weight: Font.DemiBold
        maximumLineCount: 1
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    Rectangle {
        id: muncherLife
        height: goalBg.height
        width: goalBg.height
        anchors.right: parent.right
        anchors.top: parent.top
        border.width: GCStyle.thinnestBorder
        border.color: GCStyle.darkBorder
        radius: GCStyle.tinyMargins
        color: "#80ffffff"

        Image {
            id: lifeImage
            anchors.centerIn: parent
            source: "qrc:/gcompris/src/activities/gnumch-equality/resource/muncherIcon.svg"
            width: parent.width * 0.9
            height: width
            sourceSize.width: width
        }
    }

    // Show an hint to show that can move by swiping anywhere
    Image {
        anchors.left: parent.left
        anchors.top: parent.top
        source: "qrc:/gcompris/src/core/resource/arrows_move.svg"
        width: goalBg.height
        height: goalBg.height
        sourceSize.height: height
        fillMode: Image.PreserveAspectFit
        opacity: ApplicationInfo.isMobile ? 1 : 0
    }
}
