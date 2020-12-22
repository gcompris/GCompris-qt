/* GCompris - TopPanel.qml
*
* Copyright (C) 2014 Manuel Tondeur <manueltondeur@gmail.com>
*
* Authors:
*   Joe Neeman (spuzzzzzzz@gmail.com) (GTK+ version)
*   Manuel Tondeur <manueltondeur@gmail.com> (Qt Quick port)
*
*   This program is free software; you can redistribute it and/or modify
*   it under the terms of the GNU General Public License as published by
*   the Free Software Foundation; either version 3 of the License, or
*   (at your option) any later version.
*
*   This program is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*   GNU General Public License for more details.
*
*   You should have received a copy of the GNU General Public License
*   along with this program; if not, see <https://www.gnu.org/licenses/>.
*/
import QtQuick 2.6
import GCompris 1.0

import "../../core"

Item {
    property int goal
    property bool useMultipleDataset: activity.useMultipleDataset
    property var muncherLife: muncherLife
    property var life: life
    property var bar: bar

    width: background.width
    height: background.height / 3
    anchors.right: parent.right
    anchors.bottom: parent.bottom

    onGoalChanged: {
        goalText.text = goalText.setTextGoal(goal)
    }

    Rectangle {
        id: goalBg
        height: muncherLife.height
        width: parent.width - muncherLife.width * 2 - muncherLife.anchors.rightMargin * 2
        anchors.horizontalCenter: parent.horizontalCenter
        radius: 10
        color: "#373737"
        border.width: 2
        border.color: "#F2F2F2"
    }

    GCText {
        id: goalText
        parent: goalBg
        height: parent.height
        width: parent.width
        color: "white"

        function setTextGoal(goal) {
            if (activity.type === "equality") {
                return qsTr("Equal to %1").arg(goal)
            } else if (activity.type === "inequality") {
                return qsTr("Not equal to %1").arg(goal)
            } else if (activity.type === "factors") {
                return qsTr("Factor of %1").arg(goal)
            } else if (activity.type === "multiples") {
                return qsTr("Multiple of %1").arg(goal)
            } else if (activity.type === "primes") {
                return qsTr("Primes less than %1").arg(goal)
            }
        }

        fontSizeMode: Text.Fit
        minimumPointSize: 7
        fontSize: hugeSize
        font.weight: Font.DemiBold
        maximumLineCount: 1
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignHCenter
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Rectangle {
        id: muncherLife

        width: height
        height: (parent.height - bar.height) * 0.4
        anchors.right: parent.right
        anchors.top: goalText.bottom
        anchors.rightMargin: 5 * ApplicationInfo.ratio
        border.width: 2
        border.color: "#373737"
        radius: 5
        color: "#80ffffff"

        Image {
            id: life
            anchors.centerIn: parent
            source: "qrc:/gcompris/src/activities/gnumch-equality/resource/muncherIcon.svg"
            width: parent.width * 0.9
            height: width
            sourceSize.width: width
        }
    }

    // Show an hint to show that can move by swiping anywhere
    Image {
        anchors {
            left: parent.left
            verticalCenter: muncherLife.verticalCenter
            margins: 12
        }
        source: "qrc:/gcompris/src/core/resource/arrows_move.svg"
        sourceSize.height: muncherLife.height
        opacity: topPanel.bar.level == 1 && ApplicationInfo.isMobile ? 1 : 0
    }

    Bar {
        id: bar

        content: BarEnumContent {
              value: (useMultipleDataset) ? (help | home | level | activityConfig) : (help | home | level)
        }
        onHelpClicked: displayDialog(dialogHelp)
        onPreviousLevelClicked: background.previousLevel()
        onNextLevelClicked: background.nextLevel()
        onHomeClicked: activity.home()
        onActivityConfigClicked: displayDialog(dialogActivityConfig)
    }
}
