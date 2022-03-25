/* GCompris - GCSliderStyle.qml
 *
 * SPDX-FileCopyrightText: 2014 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Controls 1.5
import QtQuick.Controls.Styles 1.4
import GCompris 1.0

/**
 * Provides styling for GCompris sliders.
 * @ingroup components
 *
 * @inherit QtQuick.Controls.Styles.SliderStyle
 */
SliderStyle {
    groove: Item {
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: 250 * ApplicationInfo.ratio
        implicitHeight: 8 * ApplicationInfo.ratio
        Rectangle {
            radius: height/2
            anchors.fill: parent
            border.width: 1
            border.color: "#888"
            gradient: Gradient {
                GradientStop { color: "#bbb" ; position: 0 }
                GradientStop { color: "#ccc" ; position: 0.6 }
                GradientStop { color: "#ccc" ; position: 1 }
            }
        }
        Item {
            width: styleData.handlePosition
            height: parent.height
            Rectangle {
                anchors.fill: parent
                border.color: Qt.darker("#f8d600", 1.2)
                radius: height/2
                gradient: Gradient {
                    GradientStop {color: "#ffe85c"; position: 0}
                    GradientStop {color: "#f8d600"; position: 1.4}
                }
            }
        }
    }
}
