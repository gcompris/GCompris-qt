import QtQuick 2.2
import GCompris 1.0

Rectangle {
    property int goal

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

        font.pointSize: ApplicationInfo.ratio*40
        font.weight: Font.DemiBold
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
    }
}
