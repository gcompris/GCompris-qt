import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Window 2.1
import QtMultimedia 5.0

import GCompris 1.0

Window {
    id: main
    width: 800
    height: 520
    minimumWidth: 600
    minimumHeight: 400
    title: "GCompris"

    Component.onCompleted: {
        console.log("ApplicationInfo.isMobile:" + ApplicationInfo.isMobile)
        console.log("ApplicationInfo.ratio:" + ApplicationInfo.ratio)
    }

    Audio {
        id: audio
        source: "qrc:/gcompris/src/core/resource/intro.ogg"
        onError: console.log("intro play error: " + errorString)
        autoPlay: true
    }

    StackView {
        id: pageView
        anchors.fill: parent
        initialItem: "qrc:/gcompris/src/activities/menu/Activity.qml"
        delegate: StackViewDelegate {
            id: root
            function getTransition(properties)
            {
                if(properties.name === "pushTransition") {
                    if(properties.enterItem.isDialog) {
                        return pushVTransition
                    } else {
                        return pushHTransition
                    }
                } else {
                    if(properties.exitItem.isDialog) {
                        return popVTransition
                    } else {
                        return popHTransition
                    }

                }
            }

            property Component pushHTransition: StackViewTransition {
                function transitionFinished(properties)
                {
                    properties.exitItem.opacity = 1
                }
                PropertyAnimation {
                    target: enterItem
                    property: "x"
                    from: target.width
                    to: 0
                    duration: 500
                    easing.type: Easing.OutSine
                }
                PropertyAnimation {
                    target: exitItem
                    property: "x"
                    from: 0
                    to: -target.width
                    duration: 500
                    easing.type: Easing.OutSine
                }
            }

            property Component popHTransition: StackViewTransition {
                function transitionFinished(properties)
                {
                    properties.exitItem.opacity = 1
                }
                PropertyAnimation {
                    target: enterItem
                    property: "x"
                    from: -target.width
                    to: 0
                    duration: 500
                    easing.type: Easing.OutSine
                }
                PropertyAnimation {
                    target: exitItem
                    property: "x"
                    from: 0
                    to: target.width
                    duration: 500
                    easing.type: Easing.OutSine
                }
            }

            property Component pushVTransition: StackViewTransition {
                function transitionFinished(properties)
                {
                    properties.exitItem.opacity = 1
                }
                PropertyAnimation {
                    target: enterItem
                    property: "y"
                    from: -target.height
                    to: 0
                    duration: 500
                    easing.type: Easing.OutSine
                }
                PropertyAnimation {
                    target: exitItem
                    property: "y"
                    from: 0
                    to: target.height
                    duration: 500
                    easing.type: Easing.OutSine
                }
            }

            property Component popVTransition: StackViewTransition {
                function transitionFinished(properties)
                {
                    properties.exitItem.opacity = 1
                }
                PropertyAnimation {
                    target: enterItem
                    property: "y"
                    from: target.height
                    to: 0
                    duration: 500
                    easing.type: Easing.OutSine
                }
                PropertyAnimation {
                    target: exitItem
                    property: "y"
                    from: 0
                    to: -target.height
                    duration: 500
                    easing.type: Easing.OutSine
                }
            }

            property Component replaceTransition: pushHTransition
        }
    }
}
