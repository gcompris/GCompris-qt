import QtQuick 2.1
import QtQuick.Controls 1.0
import GCompris 1.0

Item {
    id: page
    property Item main: parent;
    property Component pageComponent
    property QtObject activityInfo
    property bool isLocked: true
    signal home
    signal start
    signal stop
    signal displayDialog(Item dialog)

    Stack.onStatusChanged: {
        if (Stack.status == Stack.Active) {
            start()
        } else if (Stack.status == Stack.Inactive) {
            stop()
        }
    }

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
        id: activity
        sourceComponent: pageComponent
        anchors.fill: parent
    }
}
