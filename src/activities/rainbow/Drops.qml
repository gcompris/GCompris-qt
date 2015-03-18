import QtQuick 2.2
import "../../core"
import GCompris 1.0
Image{
    id:drops

    y:80
    x:100
    source:"resource/drops.svg"
   SequentialAnimation on y{
        id:drops_anim
        running: true;loops: Animation.Infinite
        NumberAnimation{
            duration:500
            from:70
            to:90
      }
    }

}
