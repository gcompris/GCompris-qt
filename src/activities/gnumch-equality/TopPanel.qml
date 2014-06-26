import QtQuick 2.2
import GCompris 1.0

import "../../core"

Rectangle {
    property int goal
    property var muncherLife : muncherLife
    property var life : life
    property var bar : bar

    width: gridPart.width
    height: background.height / 7 - 4
    anchors.right: parent.right
    anchors.top: parent.top
    border.color: "black"
    border.width: 2
    radius: 5

    onGoalChanged: {
        goalText.text = goalText.setTextGoal() + " " + goal
    }

    Text {
        id: goalText

        function setTextGoal() {
            if (activity.type === "equality") {
                return qsTr("Equal to :")
            } else if (activity.type === "inequality") {
                return qsTr("Different from :")
            } else if (activity.type === "factors") {
                return qsTr("Divisible by :")
            } else if (activity.type === "multiples") {
                return qsTr("Multiple of :")
            } else if (activity.type === "primes") {
                return qsTr("Primes ≤ ")
            }
        }

        font.pointSize: parent.width > 440 * ApplicationInfo.ratio ? 30 * ApplicationInfo.ratio : 20 * ApplicationInfo.ratio
        font.weight: Font.DemiBold
        anchors.left: muncherLife.right
        anchors.leftMargin: ApplicationInfo.ratio*5
        anchors.verticalCenter: parent.verticalCenter
    }

    Rectangle {
        id: muncherLife

        width: height
        height: parent.height * 0.9
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        border.width: 2
        anchors.leftMargin: ApplicationInfo.ratio*5
        radius: 5

        Creature {
            id: life

            monsterType: "muncher"
            width: parent.width
            height: parent.width
            frames: 1
            frameW: 80
            widthRatio: 1.35
        }
    }

    Bar {
        id: bar

        barZoom: background.height < background.width ? parent.height / 85 : parent.width / 600
        anchors.right: parent.right
        anchors.rightMargin: ApplicationInfo.ratio*5
        anchors.top: undefined

        content: BarEnumContent {
            value: help | home
        }
        onHelpClicked: {
            displayDialog(dialogHelp)
        }
        onPreviousLevelClicked: Activity.previousLevel()
        onNextLevelClicked: Activity.nextLevel()
        onHomeClicked: activity.home()
    }
}
