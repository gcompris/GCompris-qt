import QtQuick 2.0
import "magic-hat.js" as Activity

Item {
    property int nbStarsOn: 0
    property bool authorizeClick: false
    property int starsSize: 32
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
                starState: "on"
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

   function resetStars(){
       authorizeClick=false
       nbStarsOn=0
       for(var i=0;i<10-nbStarsOn;i++){
           repeaterStarsOff.itemAt(i).starState="off"
       }
   }
}
