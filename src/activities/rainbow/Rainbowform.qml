import QtQuick 2.2
import "../../core"
import GCompris 1.0
Image{
    id:rainbow

    y:80
    x:800
    height:900
    width:600

    source:"resource/rainbow.svg"
    SequentialAnimation on y{
        id:rainbow_anim
        running: true;
        NumberAnimation{
            duration:5500
       }
    }

}
