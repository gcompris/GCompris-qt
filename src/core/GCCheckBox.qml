/* GCompris - GCCheckbox.qml
 *
 * SPDX-FileCopyrightText: 2024 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0
import QtQuick.Controls.Basic

/**
 * A QML component representing GCompris' checkboxs.
 * @ingroup components
 *
 * @inherit QtQuick2.Checkbox
 */
CheckBox {
    id: checkboxControl

    /**
     * type:real
     * Fixed font size of the label in pt.
     *
     * Set to a value > 0 for enforcing a fixed font.pointSize for the label,
     * that won't be updated with ApplicationSettings.baseFontSize.
     * @sa ApplicationSettings.baseFontSize, GCText.fixFontSize
     */
    property real fixedFontSize: -1

    /**
     * type:real
     * if there is an icon on the right, we need to add a rightMargin for the text label
     * 
     * Default is 0.
     */
    property real rightIconSize: 0

    property bool selected: false

    property string textSize: "regular"
    
    property var textSizes: {
        "regular": {
            fontSize: 14,
            fontBold: false
        },
        "subtitle": {
            fontSize: 16,
            fontBold: true
        },
        "title": {
            fontSize: 24,
            fontBold: true
        }
    }
    
    focusPolicy: Qt.NoFocus
    
    background: Rectangle {
        border.width: checkboxControl.activeFocus ? 4 : 2
        //border.color: themes[theme].borderColor
        radius: 10
       /* gradient: Gradient {
            GradientStop { position: 0 ; color: checkboxControl.pressed ? themes[theme].selectedColorGradient0 : themes[theme].backgroundColorGradient0 }
            GradientStop { position: 1 ; color: checkboxControl.pressed ? themes[theme].selectedColorGradient1 : themes[theme].backgroundColorGradient1 }
        }*/
    }
    contentItem: Item {
        id: labelItem
        anchors.fill: parent
        implicitWidth: labelText.implicitWidth
        implicitHeight: labelText.implicitHeight

        GCText {
            id: labelText
            //color: themes[theme].textColor
            text: checkboxControl.text
            fontSize: textSizes[textSize].fontSize
            font.bold: textSizes[textSize].fontBold
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: rightIconSize > 0 ? rightIconSize : 10 // if there's a rightIconSize, it must handle the rightMargin
            anchors.topMargin: 10
            anchors.bottomMargin: 10
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            fontSizeMode: Text.Fit

            Component.onCompleted: {
                if (fixedFontSize > 0) {
                    labelText.fixFontSize = true;
                    labelText.fontSize = fixedFontSize;
                }
            }
        }
    }
}
