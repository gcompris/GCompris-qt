import QtQuick 2.1

Item {
    id: page
    property Item main: parent;
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
}
