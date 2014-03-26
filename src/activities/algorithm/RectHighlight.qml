import QtQuick 2.0
import "algorithm.js" as Activity
import QtMultimedia 5.0
import QtQuick.Particles 2.0
import "qrc:/gcompris/src/core"
Rectangle{
    id: sampleTray
    height: parent.height/8
    width: parent.width - parent.width/3
    color: "transparent"
    property string src1: "qrc:/gcompris/src/activities/algorithm/resource/apple.png"
    property string src2: "qrc:/gcompris/src/activities/algorithm/resource/cerise.png"
    property string src3: "qrc:/gcompris/src/activities/algorithm/resource/egg.png"
    property string src4: "qrc:/gcompris/src/activities/algorithm/resource/eggpot.png"
    property string src5: "qrc:/gcompris/src/activities/algorithm/resource/football.png"
    property string src6: "qrc:/gcompris/src/activities/algorithm/resource/glass.png"
    property string src7: "qrc:/gcompris/src/activities/algorithm/resource/peer.png"
    property string src8: "qrc:/gcompris/src/activities/algorithm/resource/strawberry.png"

    Image{
        id: img1
        source: sampleTray.src1
        height: parent.height
        width: parent.width/9
        Rectangle{
            id:  rect1
            color: "red"
            anchors.fill: parent
            opacity: 0
            radius: 10.0
            MouseArea{
                hoverEnabled: true
                anchors.fill: parent
                onEntered: rect1.opacity = 0.5
                onExited: rect1.opacity = 0
                onClicked: {Activity.clickHandler('img1');particle1.emitter.burst(20)}
            }
        }
            ParticleSystemStar{
                id: particle1
            }
    }

    Image{
        id: img2
        source: sampleTray.src2
        height: parent.height
        width: parent.width/9
        anchors.left: img1.right
        anchors.leftMargin: 10
        Rectangle{
            id:  rect2
            color: "red"
            anchors.fill: parent
            opacity: 0
            radius: 10.0
            MouseArea{
                hoverEnabled: true
                anchors.fill: parent
                onEntered: rect2.opacity = 0.5
                onExited: rect2.opacity = 0
                onClicked: {Activity.clickHandler('img2');particle2.emitter.burst(20)}
            }

        }
        ParticleSystemStar{
            id: particle2
        }
    }

    Image{
        id: img3
        source: sampleTray.src3
        height: parent.height
        width: parent.width/9
        anchors.left: img2.right
        anchors.leftMargin: 10
        Rectangle{
            id:  rect3
            color: "red"
            anchors.fill: parent
            opacity: 0
            radius: 10.0
            MouseArea{
                hoverEnabled: true
                anchors.fill: parent
                onEntered: rect3.opacity = 0.5
                onExited: rect3.opacity = 0
                onClicked: {Activity.clickHandler('img3');particle3.emitter.burst(20)}
            }

        }
        ParticleSystemStar{
            id: particle3
        }
    }

    Image{
        id: img4
        source: sampleTray.src4
        height: parent.height
        width: parent.width/9
        anchors.left: img3.right
        anchors.leftMargin: 10
        Rectangle{
            id:  rect4
            color: "red"
            anchors.fill: parent
            opacity: 0
            radius: 10.0
            MouseArea{
                hoverEnabled: true
                anchors.fill: parent
                onEntered: rect4.opacity = 0.5
                onExited: rect4.opacity = 0
                onClicked: {Activity.clickHandler('img4');particle4.emitter.burst(20)}
            }

        }
        ParticleSystemStar{
            id: particle4
        }
    }

    Image{
        id: img5
        source: sampleTray.src5
        height: parent.height
        width: parent.width/9
        anchors.left: img4.right
        anchors.leftMargin: 10
        Rectangle{
            id:  rect5
            color: "red"
            anchors.fill: parent
            opacity: 0
            radius: 10.0
            MouseArea{
                hoverEnabled: true
                anchors.fill: parent
                onEntered: rect5.opacity = 0.5
                onExited: rect5.opacity = 0
                onClicked: {Activity.clickHandler('img5');particle5.emitter.burst(20)}
            }

        }
        ParticleSystemStar{
            id: particle5
        }
    }

    Image{
        id: img6
        source: sampleTray.src6
        height: parent.height
        width: parent.width/9
        anchors.left: img5.right
        anchors.leftMargin: 10
        Rectangle{
            id:  rect6
            color: "red"
            anchors.fill: parent
            opacity: 0
            radius: 10.0
            MouseArea{
                hoverEnabled: true
                anchors.fill: parent
                onEntered: rect6.opacity = 0.5
                onExited: rect6.opacity = 0
                onClicked: {Activity.clickHandler('img6');particle6.emitter.burst(20)}
            }

        }
        ParticleSystemStar{
            id: particle6
        }
    }

    Image{
        id: img7
        source: sampleTray.src7
        height: parent.height
        width: parent.width/9
        anchors.left: img6.right
        anchors.leftMargin: 10
        Rectangle{
            id:  rect7
            color: "red"
            anchors.fill: parent
            opacity: 0
            radius: 10.0
            MouseArea{
                hoverEnabled: true
                anchors.fill: parent
                onEntered: rect7.opacity = 0.5
                onExited: rect7.opacity = 0
                onClicked: {Activity.clickHandler('img7');particle7.emitter.burst(20)}
            }

        }
        ParticleSystemStar{
            id: particle7
        }
    }

    Image{
        id: img8
        source: sampleTray.src8
        height: parent.height
        width: parent.width/9
        anchors.left: img7.right
        anchors.leftMargin: 10
        Rectangle{
            id:  rect8
            color: "red"
            anchors.fill: parent
            opacity: 0
            radius: 10.0
            MouseArea{
                hoverEnabled: true
                anchors.fill: parent
                onEntered: rect8.opacity = 0.5
                onExited: rect8.opacity = 0
                onClicked: {Activity.clickHandler('img8');particle8.emitter.burst(20)}
            }

        }
        ParticleSystemStar{
            id: particle8
        }
    }
}
