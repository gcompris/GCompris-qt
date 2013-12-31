import QtQuick 2.0
import "core.js" as Core

Rectangle {
    id: bar
    color: "red"
    radius: 5.0
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    width: barRow.width
    height: barRow.height - 30
    border.color: "black"
    border.width: 2
    scale: 0.7
    z: 1000
    property BarEnumContent content
    property int level: 0

    function show(newContent) {
        content.value = newContent
    }

    function showHelp(section, title, description,
                      prerequisite, goal, manual, credit) {
        dialogHelp.show(section, title, description,
                        prerequisite, goal, manual, credit)
    }

    Row {
        id: barRow
        spacing: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        Item { width: 10; height: 1 }
        BarButton {
            source: "qrc:///core/resource/core/bar_exit.svgz";
            contentId: content.exit
            onClicked: Qt.quit();
        }
        BarButton {
            source: "qrc:///core/resource/core/bar_about.svgz";
            contentId: content.about
            onClicked: dialogAbout.visible = true;
        }
        BarButton {
            source: "qrc:///core/resource/core/bar_help.svgz";
            contentId: content.help
            onClicked: Core.displayHelp()
        }
        BarButton {
            id: previousButton
            source: "qrc:///core/resource/core/bar_previous.svgz";
            contentId: content.previous
            onClicked: Core.previousLevel()
        }
        Text {
            text: "" + level
            font.family: "Helvetica"
            font.pointSize: 24
            font.weight: Font.DemiBold
            style: Text.Outline;
            styleColor: "grey"
            color: "black"
            visible: level > 0 ? 1.0 : 0
        }
        BarButton {
            id: nextButton
            source: "qrc:///core/resource/core/bar_next.svgz";
            contentId: content.next
            onClicked: Core.nextLevel()
        }
        BarButton {
            id: homeButton
            source: "qrc:///core/resource/core/bar_home.svgz";
            contentId: content.home
            onClicked: Core.stopActivity()
        }
        Item { width: 10; height: 1 }
    }
}
