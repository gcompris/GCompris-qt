import QtQuick 2.1
import QtQuick.Controls 1.0
import "core.js" as Core
import QtQuick.Window 2.1

Window {
    id: main
    width: 800
    height: 520
    title: "GCompris"

    Component.onCompleted: Core.init(main, menu, bar);

    GCMenu {
        id: menu
    }
    Bar {
        id: bar
        content: BarEnumContent { value: help | exit | about }
    }

    DialogAbout { id: dialogAbout  }
    DialogHelp { id: dialogHelp }

    function stopDialogs() {
        dialogAbout.visible = false
        dialogHelp.visible = false
    }

    Keys.onEscapePressed: Core.stopActivity()
    Keys.onPressed: {
        if (event.modifiers === Qt.ControlModifier &&
            event.key === Qt.Key_Q) {
            Qt.quit()
        }
    }
}
