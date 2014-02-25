import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtMultimedia 5.0

import "qrc:/gcompris/src/core"
import "qrc:/gcompris/src/activities/memory"
import "memory.js" as Activity

ActivityBase {
    id: activity
    focus: true

    property int itemWidth
    property int itemHeight
    property int rowsnb
    property int paired

    onStart: {}
    onStop: {}
    paired:0

    onPairedChanged: {
        if (paired==3){//when 2 pictures are clicked and we click a third one
          Activity.cardReturn()
        }

    }

    pageComponent: Image {
        source: "qrc:/gcompris/src/activities/memory/resource/scenery_background.png"
        fillMode: Image.PreserveAspectCrop
        id: background
        signal start
        signal stop
        focus: true


        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        onStart: { Activity.start(main, background, bar, bonus, containerModel,cardRepeater,grid) }
        onStop: { Activity.stop() }

        ListModel {
              id: containerModel
        }

        Grid {
            id:grid
            columns: Activity.getColumn()
            x: main.width*0.1
            y: main.height * 0.1
            spacing: 20
            Repeater {
                id:cardRepeater
                model:containerModel
                delegate: CardItem {

                       source: back  //first picture is the back
                       width: width_
                       height:height_
                       backPict: back
                       isBack:true
                       imagePath:image


                       //audioSrc: audio
                       //question: text
               }
            }

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
            onHomeClicked: home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
