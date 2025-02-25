/* GCompris - Carriage.qml
 *
 * SPDX-FileCopyrightText: 2014 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ Mostly full rewrite)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import core 1.0
import QtQuick.Effects
import "../../core"
import "click_on_letter.js" as Activity

Image {
    id: carriageItem
    property int nbCarriage
    property bool isCarriage: index <= nbCarriage
    property bool clickEnabled
    property bool isSelected
    property alias successAnimation: successAnimation
    property alias particle: particle
    property alias carriageBg: carriageBg

    sourceSize.width: width
    fillMode: Image.PreserveAspectFit
    source: isCarriage ?
                Activity.url + "carriage.svg":
                Activity.url + "cloud.svg"
    z: (state == 'scaled') ? 1 : -1

    Rectangle {
        id: carriageBg
        visible: isCarriage
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.13
        anchors.bottomMargin: parent.height * 0.325
        radius: GCStyle.halfMargins
        color: "#f0d578"
        border.color: "#b98a1c"
        border.width: GCStyle.thinBorder
    }

    Rectangle {
        id: selector
        visible: isSelected && items.keyNavigationMode
        width: parent.width
        height: parent.height
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: isCarriage ?
            carriageBg.horizontalCenter : parent.horizontalCenter
        radius: GCStyle.halfMargins
        color: GCStyle.highlightColor
        border.color: GCStyle.whiteBorder
        border.width: GCStyle.thinBorder
    }

    GCText {
        id: text
        anchors.centerIn: isCarriage ? carriageBg : parent
        text: letter
        width: carriageBg.width
        height: carriageBg.height
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        fontSizeMode: Text.Fit
        minimumPointSize: 7
        fontSize: largeSize
        font.bold: true
        style: Text.Outline
        styleColor: GCStyle.darkerText
        color: GCStyle.whiteText
    }

    MultiEffect {
        anchors.fill: text
        source: text
        shadowEnabled: true
        shadowBlur: 1.0
        blurMax: 6
        shadowHorizontalOffset: 1
        shadowVerticalOffset: 1
        shadowOpacity: 0.25
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: ApplicationInfo.isMobile ? false : true

        onClicked: {
            if(carriageItem.clickEnabled) {
                items.lastSelectedIndex = train.currentIndex
                items.keyNavigationMode = false;
                items.buttonsBlocked = true;
                if (Activity.checkAnswer(index)) {
                    successAnimation.restart();
                    particle.burst(30);
                } else {
                    activityBackground.moveErrorRectangle(carriageItem);
                }
            }
        }
    }

    ParticleSystemStarLoader {
        z: 10
        id: particle
        clip: false
    }

    states: State {
        name: "scaled"; when: mouseArea.containsMouse
        PropertyChanges {
            carriageItem {
                scale: 1.2
                z: 2
            }
        }
    }

    transitions: Transition {
        NumberAnimation { properties: "scale"; easing.type: Easing.OutCubic }
    }

    SequentialAnimation {
        id: successAnimation
        NumberAnimation {
            target: carriageItem
            easing.type: Easing.InOutQuad
            property: "rotation"
            to: 20; duration: 100
        }
        NumberAnimation {
            target: carriageItem
            easing.type: Easing.InOutQuad
            property: "rotation"; to: -20
            duration: 100 }
        NumberAnimation {
            target: carriageItem
            easing.type: Easing.InOutQuad
            property: "rotation"
            to: 0; duration: 50
        }
    }
}
