import QtQuick 2.1
import QtQuick.Controls 1.0
import GCompris 1.0

Item {
    id: page
    property Item main: parent;
    property Component pageComponent
    property QtObject menu
    property bool isLocked: true
    signal home
    signal start
    signal pause
    signal play
    signal stop
    signal displayDialog(Item dialog)

    onHome: menu.home()
    onDisplayDialog: menu.displayDialog(dialog)

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
    Keys.onReleased: {
        if (event.key === Qt.Key_Back) {
            event.accepted = true
            home()
        }
    }

    Loader {
        id: activity
        sourceComponent: pageComponent
        anchors.fill: parent
    }
}
