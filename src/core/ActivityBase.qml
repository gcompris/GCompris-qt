import QtQuick 2.1
import "qrc:/gcompris/src/core"
import GCompris 1.0

Item {
    id: page
    property Item main: parent;
    property Component pageComponent
    property QtObject activityInfo
    signal home
    signal displayDialog(Item dialog)

    Keys.onEscapePressed: home()
    Keys.onPressed: {
        if (event.modifiers === Qt.ControlModifier &&
                event.key === Qt.Key_Q) {
            Qt.quit()
        } else if (event.modifiers === Qt.ControlModifier &&
                event.key === Qt.Key_B) {
            bar.toggle()
        }
    }

    Loader {
        sourceComponent: pageComponent
        anchors.fill: parent
    }
}
