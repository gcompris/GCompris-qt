/* GCompris - VirtualKey.qml
 *
 * SPDX-FileCopyrightText: 2014 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.12

Item {
    id: virtualKey
    
    property alias text: button.text
    property var modifiers: 0   /* Supposed to hold any active key modifiers
                                 * in a bitmask from the Qt namespace:
                                 * Qt.ShiftModifier/MetaModifier/ControlModifier.
                                 * 0 if none. */

    property var specialKey: 0  /* Supposed to hold special key values from the
                                 * Qt namespace like Qt.Key_Shift/Key_Control/
                                 * Key_Alt if VirtualKey is a special key.
                                 * 0 Otherwise */

    signal pressed(var virtualKey);

    Button {
        id: button
        text: ((modifiers & Qt.ShiftModifier) && (shiftLabel !== undefined)) ? shiftLabel : label

        width: parent.width
        height: virtualKey.height
        
        background: Rectangle {
            border.width: button.activeFocus ? 2 : 1
            border.color: "black"
            radius: 4
            gradient: Gradient {
                GradientStop {
                    position: 0;
                    color: (button.pressed
                            || ( virtualKey.specialKey == Qt.Key_Shift
                                 && virtualKey.modifiers & Qt.ShiftModifier))
                           ? "#ccc" : "#eee";
                }
                GradientStop {
                    position: 1;
                    color: (button.pressed
                            || ( virtualKey.specialKey == Qt.Key_Shift
                                    && virtualKey.modifiers & Qt.ShiftModifier))
                           ? "#aaa" : "#ccc";
                }
            }
        }
        contentItem: Item {
            GCText {
                //renderType: Text.NativeRendering
                anchors.centerIn: parent
                text: button.text
                fontSize: 20
                font.bold: false
                color: "black"
                //antialiasing: true
            }
        }
    
        SequentialAnimation {
            id: anim
            PropertyAction { target: virtualKey; property: 'z'; value: 1 }
            NumberAnimation { target: button; properties: "scale"; to: 1.3; duration: 100; easing.type: Easing.OutCubic }
            NumberAnimation { target: button; properties: "scale"; to: 1.0; duration: 100; easing.type: Easing.OutCubic }
            PropertyAction { target: virtualKey; property: 'z'; value: 0 }
        }

        onClicked: {
            //console.log("### virtualKey.onClicked text=" + virtualKey.text 
            //        + " specialKey="+ virtualKey.specialKey
            //        + " modifiers= "+ virtualKey.modifiers);
            anim.start()
            virtualKey.pressed(virtualKey);
            button.focus = false;
        }
    }
    
    DropShadow {
        anchors.fill: button
        cached: false
        horizontalOffset: 3
        verticalOffset: 3
        radius: 8.0
        samples: 16
        color: "#80000000"
        source: button
        scale: button.scale
    }
}
