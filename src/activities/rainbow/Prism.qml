import QtQuick 2.2
import "../../core"
import GCompris 1.0
Image{
    id:prism
 source:"resource/prism.svg"
 y:800
 x:300
visible:true
 SequentialAnimation on y{
     id:prism_anim
     running: true;
     NumberAnimation{
         duration:4500
         to:0;
         from:750
    }
 }
 Item{
     Rectangle{
        y:800
        x:300
        height:prism.height
        width:prism.width
     }
     MouseArea{
         anchors.fill:parent
     onClicked:prism.visible=false
     }


 }

}
