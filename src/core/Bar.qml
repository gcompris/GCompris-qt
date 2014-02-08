import QtQuick 2.1
import GCompris 1.0

Item {
    id: bar
    x: 0
    anchors.bottom: parent.bottom
    width: barRow.width
    height: barRow.height - 30
    scale: 1 * ApplicationInfo.ratio
    z: 1000
    property BarEnumContent content
    property int level: 0
    signal aboutClicked
    signal helpClicked
    signal nextLevelClicked
    signal previousLevelClicked
    signal homeClicked

    function toggle() {
        opacity = (opacity == 0 ? 1.0 : 0)
    }

    function show(newContent) {
        content.value = newContent
    }

    Row {
        id: barRow
        spacing: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        Item { width: 10; height: 1 }
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_exit.svgz";
            contentId: ApplicationInfo.isMobile ? content.disabled : content.exit
            onClicked: Qt.quit();
        }
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_about.svgz";
            contentId: content.about
            onClicked: bar.aboutClicked()
        }
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_help.svgz";
            contentId: content.help
            onClicked: bar.helpClicked()
        }
        BarButton {
            id: previousButton
            source: "qrc:/gcompris/src/core/resource/bar_previous.svgz";
            contentId: content.previous
            onClicked: bar.previousLevelClicked()
        }
        Text {
            text: "" + level
            font.family: "Helvetica"
            font.pointSize: 24
            font.weight: Font.DemiBold
            style: Text.Raised;
            styleColor: "white"
            color: "black"
            visible: level > 0 ? 1.0 : 0
        }
        BarButton {
            id: nextButton
            source: "qrc:/gcompris/src/core/resource/bar_next.svgz";
            contentId: content.next
            onClicked: bar.nextLevelClicked()
        }
        BarButton {
            id: homeButton
            source: "qrc:/gcompris/src/core/resource/bar_home.svgz";
            contentId: ApplicationInfo.isMobile ? content.disabled : content.home
            onClicked: bar.homeClicked()
        }
        Item { width: 10; height: 1 }
    }

    Behavior on opacity { PropertyAnimation { duration: 500 } }
}
