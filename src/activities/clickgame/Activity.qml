import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import "qrc:/gcompris/src/core"
import "activity.js" as Activity

ActivityBase {
    id: activity
    focus: true

    pageComponent: Image {
        id: backgound
        focus: true
        fillMode: Image.PreserveAspectCrop
        Component.onCompleted: Activity.start(backgound, bar, bonus);

        // FIXME It's not working
        Keys.onLeftPressed: Activity.leftClick()
        Keys.onRightPressed: Activity.rightClick()

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: home()
            activityInfo: activity.activityInfo
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
        }
    }
}
