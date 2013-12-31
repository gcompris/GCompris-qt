import QtQuick 2.0
import "core.js" as Core

Item {
    id: main
    width: 800
    height: 520
    focus: true

    Component.onCompleted: Core.init(main, menu, bar);

    Menu {
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
