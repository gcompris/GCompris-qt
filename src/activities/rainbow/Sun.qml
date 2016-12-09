import QtQuick 2.2
import "../../core"
import GCompris 1.0

Image{

    id:sun

    y:800
    x:0
    height:200
    width:200
    source:"resource/sun.svg"
    SequentialAnimation on y{
        id:sun_anim
        running: true;
        NumberAnimation{
            duration:4500
            to:0;
            from:750
       }
    }

    Loader{
            source:"Rainbowform.qml"}
}
