import QtQuick 2.1

import "qrc:/gcompris/src/core"
import "magic_hat_plus.js" as Activity

ActivityBase {
    id: activity
    focus: true

    onStart: {}
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: "qrc:/gcompris/src/activities/magic_hat_plus/resource/magic_hat/magic_hat_plus_bg.png"
        fillMode: Image.PreserveAspectFit
        signal start
        signal stop


        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        onStart: { Activity.start(main, background, bar, bonus) }
        onStop: { Activity.stop() }

        Hat{
            x: background.width/5
            y:  background.height/5
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | previous | next }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
