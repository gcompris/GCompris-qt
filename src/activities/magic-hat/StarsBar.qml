import QtQuick 2.0
import "magic-hat.js" as Activity

Item {
    property int nbStarsOn: 0
    property bool authorizeClick: false
    property int starsSize: 32
    property string starsColor: "yellow"
    property int targetX
    property int targetY
    id: item
    width: starsSize
    height: starsSize

    Row {
        id: rowlayout
        height: item.height
        spacing: 5
        Repeater {
            id: repeaterStarsOn
            model: nbStarsOn
            Star {
                starState: "on_" + starsColor
                width: item.height
                height: item.height
                displayBounds: true
                isClickable: authorizeClick
            }
        }
        Repeater {
            id: repeaterStarsOff
            model: 10-nbStarsOn
            Star {
                starState: "off"
                width: item.height
                height: item.height
                isClickable: authorizeClick
            }
        }
    }

    Row{
        spacing: 5
        Repeater{
            id: repeaterStarsToMove
            model: nbStarsOn
            Star {
                starState: "on_" + starsColor
                width: item.height
                height: item.height
                displayBounds: false
                isClickable: authorizeClick
                opacity: 1
            }
        }
    }

    function moveStars(){
        console.log("Move stars : " + nbStarsOn)
        for(var i=0;i<nbStarsOn;i++){
            repeaterStarsToMove.itemAt(i).x=targetX
            repeaterStarsToMove.itemAt(i).y=targetY
            repeaterStarsToMove.itemAt(i).z-=2
        }
    }

   function resetStars(){
       authorizeClick=false
       nbStarsOn=0
       for(var i=0;i<10-nbStarsOn;i++){
           repeaterStarsOff.itemAt(i).starState="off"
       }
   }
}
