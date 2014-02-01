import QtQuick 2.1
import QtQuick.Particles 2.0
import QtMultimedia 5.0
import "activity.js" as Activity
import GCompris 1.0

Item {
    id: hexagon
    property Item main
    property string color
    property bool hasStrawberry: false
    property double ix
    property double iy
    property double nbx
    property double nby
    property double r: Math.min(main.width / nbx / 2, (main.height - 10) / nby / 2)
    property double offsetX: (main.width % (width * nbx)) / 2
    property double offsetY: (main.height % (height * nby)) / 2
    x: (iy % 2 ? width * ix + width / 2 : width * ix) + offsetX
    y: height * iy - (Math.sin((Math.PI * 2) / 12) * r * 2 * iy) / 2 + offsetY
    width: Math.cos((Math.PI * 2) / 12) * r * 2
    height: r * 2

    Image {
        anchors.fill: parent
        enabled: hasStrawberry
        visible: hasStrawberry
        source: "qrc:/gcompris/src/activities/hexagon/resource/strawberry.svg"
    }

    Audio {
        id: audioDrip
        source: "qrc:/gcompris/src/activities/clickgame/resource/drip.wav"
    }

    // Taken from
    // http://www.storminthecastle.com/2013/07/24/how-you-can-draw-regular-polygons-with-the-html5-canvas-api/
    function polygon(ctx, x, y, radius, sides, startAngle, anticlockwise) {
      if (sides < 3) return;
      var a = (Math.PI * 2)/sides;
      a = anticlockwise?-a:a;
      ctx.save();
      ctx.translate(x,y);
      ctx.rotate(startAngle);
      ctx.moveTo(radius,0);
      for (var i = 1; i < sides; i++) {
        ctx.lineTo(radius*Math.cos(a*i),radius*Math.sin(a*i));
      }
      ctx.closePath();
      ctx.restore();
    }

    Canvas {
      id:canvas
      width: hexagon.r * 2
      height: hexagon.r * 2
      antialiasing: true
      onPaint:{
          var ctx = canvas.getContext('2d');
          ctx.beginPath();
          polygon(ctx, r, r, r, 6, Math.PI / 2);
          ctx.fillStyle = hexagon.color;
          ctx.fill();
          ctx.stroke()
      }

      onOpacityChanged: if(opacity == 0) Activity.strawberryFound()

      Behavior on opacity { PropertyAnimation { duration: 500 } }
    }

    Component.onCompleted: {
        canvas.requestPaint()
    }


    MouseArea {
        x: 0
        y: r - Math.sin((Math.PI * 2) / 8) * r
        width: parent.width
        height: r * 2 - y
        onClicked: {

            if(hasStrawberry) {
                canvas.opacity = 0
                enabled = false
                audioDrip.play()
                Activity.strawberryFound()
                clickedEffect.start()
            } else {
                hexagon.color =
                        Activity.getColor(Activity.getDistance(hexagon.ix, hexagon.iy))
                enabled = false
                canvas.requestPaint()
            }
        }
    }

    ParticleSystem
    {
        id: clickedEffect
        anchors.fill: parent
        running: false
        Emitter {
            anchors.fill: parent
            emitRate: 100
            lifeSpan: 100
            lifeSpanVariation: 50
            size: 48
            sizeVariation: 20
        }

        ImageParticle {
            source: "qrc:/gcompris/src/activities/clickgame/resource/star.png"
            sizeTable: "qrc:/gcompris/src/activities/clickgame/resource/sizeTable.png"
            color: "white"
            blueVariation: 0.5
            greenVariation: 0.5
            redVariation: 0.5
        }
    }

}
