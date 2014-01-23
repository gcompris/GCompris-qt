import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Window 2.1

import GCompris 1.0

Window {
    id: main
    width: 800
    height: 520
    minimumWidth: 600
    minimumHeight: 400
    title: "GCompris"

    StackView {
        id: pageView
        anchors.fill: parent
        initialItem: "qrc:/gcompris/src/activities/menu/Activity.qml"
        delegate: StackViewDelegate {
            pushTransition: StackViewTransition {
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
            popTransition: StackViewTransition {
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
            property Component replaceTransition: pushTransition
        }
    }
}
