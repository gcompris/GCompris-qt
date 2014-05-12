import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtMultimedia 5.0
import GCompris 1.0

import "../../core"
import "hexagon.js" as Activity

ActivityBase {
    id: activity
    focus: true

    pageComponent: Image {
        source: "qrc:/gcompris/src/activities/menu/resource/background.svgz"
        fillMode: Image.PreserveAspectCrop
        id: background
        signal start
        signal stop
        focus: true

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        QtObject {
            id: items
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias audioDrip: audioDrip
        }

        onStart: Activity.start(main, items)
        onStop: Activity.stop()

        // For perf reason it is best not to put this in each HexagonItem
        GCAudio {
            id: audioDrip
            source: "qrc:/gcompris/src/activities/clickgame/resource/drip.wav"
        }

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | previous | next }
            onHelpClicked: {
                displayDialog(dialogHelpLeftRight)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
