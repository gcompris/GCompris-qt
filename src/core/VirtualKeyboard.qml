/* GCompris - VirtualKeyboard.qml
 *
 * Copyright (C) 2014 Holger Kaelberer
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.0
import GCompris 1.0

import "qrc:/gcompris/src/core"

/* ToDo:
 * - check for duplicate letters
 * - add support for shift key
 */
Item {
    id: keyboard
    
    // public:
    property var qwertyLayout: // a default layout (qwerty)
                      [/*[ { label: "1" },
                           { label: "2" },
                           { label: "3" },
                           { label: "4" },
                           { label: "5" },
                           { label: "6" },
                           { label: "7" },
                           { label: "8" },
                           { label: "9" },
                           { label: "0" } ],*/
                         
                         [ { label: "q" },
                           { label: "w" },
                           { label: "e" },
                           { label: "r" },
                           { label: "t" },
                           { label: "y" },
                           { label: "u" },
                           { label: "i" },
                           { label: "o" },
                           { label: "p" } ],
                           
                         [ { label: "a" },
                           { label: "s" },
                           { label: "d" },
                           { label: "f" },
                           { label: "g" },
                           { label: "h" },
                           { label: "j" },
                           { label: "k" },
                           { label: "l" } ],
                           
                         [ { label: "z" },
                           { label: "x" },
                           { label: "c" },
                           { label: "v" },
                           { label: "b" },
                           { label: "n" },
                           { label: "m" } ]]
    
    property var layout: null
    //property bool shift: false  // FIXME: add support for shift-key
    property bool equalKeyWidth: true
    property int rowSpacing: 5 * ApplicationInfo.ratio
    property int keySpacing: 3 * ApplicationInfo.ratio
    property int keyHeight: 35 * ApplicationInfo.ratio
    property int margin: 5 * ApplicationInfo.ratio
    opacity: 0.9
    
    visible: priv.initialized  // this should probably be readonly from outside
    enabled: visible
    
    signal keypress(string text);
    signal error(string msg);

    // internal:
    state: "OPENED"
    z: 9999
    width: parent.width
    height: priv.cHeight
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    
    // private properties:
    QtObject {
        id: priv
        
        readonly property int cHeight: numRows * keyboard.keyHeight +
                                       (numRows - 1) * keyboard.rowSpacing //+ keyboard.margin * 2
        property int numRows: 0
        property bool initialized: false
    }

    
    function populateKeyboard(a)
    {
        var nRows;
        var maxButtons = 0;
        
        // validate layout syntax:
        if (!Array.isArray(a) || a.length < 1) {
            error("VirtualKeyboard: Invalid layout, array of length > 0");
            return;
        }
        nRows = a.length;
        var i
        for (i = 0; i < a.length; i++) {
            if (!Array.isArray(a[i])) {
                error("VirtualKeyboard: Invalid layout, expecting array of arrays of keys");
                return;
            }
            if (a[i].length > maxButtons)
                maxButtons = a[i].length;
            for (var j = 0; j < a[i].length; j++) {
                if (undefined === a[i][j].label) {
                    error("VirtualKeyboard: Invalid layout, invalid key object");
                    return;
                } 
            }
        }
        
        // populate
        for (i = 0; i < a.length; i++) {
            var offset =
                    equalKeyWidth ? ((maxButtons - a[i].length) *
                                     (keyboard.width - maxButtons *
                                      keyboard.rowSpacing - keyboard.margin*2) /
                                     maxButtons) : 0;
            rowListModel.append({ rowNum: i,
                                  offset: offset,
                                  keys: a[i]});
        }
        priv.numRows = i + 1;
        priv.initialized = (priv.numRows > 0);
    }
    
    onLayoutChanged: {
        rowListModel.clear();
        priv.initialized = false;
        if (layout != null)
            populateKeyboard(layout);
    }
    
    ListModel {
        id: rowListModel
        /* Currently expects the following 
         * ListElement {
         *   rowNum: 1
         *   keys: [ { label: "a" },
         *           { label: "b", 
         *             ...}
         *         ]
         * }
         * FIXME: probably should distinguish label and value!
         */
    }
    
    transitions: Transition {
        NumberAnimation {
            properties: "height"
            duration: 500
            easing.type: Easing.OutCubic
        }
    }
    
    states: [
             State {
                 name: "OPENED"
                 PropertyChanges { target: keyboard; height: priv.cHeight}
                 PropertyChanges { target: arrowIcon; rotation: 0 }
             },
             State {
                 name: "CLOSED"
                 PropertyChanges { target: keyboard; height: keyboardDrawer.height}
                 PropertyChanges { target: arrowIcon; rotation: 180 }
             }
         ]
    
    Rectangle {
        id: background
        
        width: parent.width
        height: keyboard.height
        color: "#8C8F8C"
        opacity: keyboard.opacity
        
        MultiPointTouchArea {
            id: keyboardTouchArea
            
            anchors.fill: parent
            // mutually exclusive with drawerMouseArea
            enabled: ApplicationInfo.isMobile
            touchPoints: [ TouchPoint { id: point1 } ]
            
            property bool inGesture: false
                       
            onGestureStarted: keyboardTouchArea.inGesture = true;
            
            onReleased: {
                if (point1.y > 20 && keyboardTouchArea.inGesture &&
                        keyboard.state != "CLOSED")
                    keyboard.state = "CLOSED"; //slide down
                else if (point1.y < 0 && keyboardTouchArea.inGesture &&
                         keyboard.state != "OPENED")
                    keyboard.state = "OPENED"; //slide up
                else if (point1.y > 0 && point1.y <= keyboardDrawer.height) {
                    // assume: click on drawer
                    if (keyboard.state == "CLOSED")
                        keyboard.state = "OPENED";
                    else if (keyboard.state == "OPENED")
                        keyboard.state = "CLOSED";
                }
                keyboardTouchArea.inGesture = false;
            }
        }
        
        Rectangle {
            id: keyboardDrawer
            height: 15 * ApplicationInfo.ratio;
            width: parent.width
            border.color : "#6A6D6A"
            border.width: 1
            z: 1

            gradient: Gradient {
                GradientStop { position: 0.0; color: "#8C8F8C" }
                GradientStop { position: 0.17; color: "#6A6D6A" }
                GradientStop { position: 0.77; color: "#3F3F3F" }
                GradientStop { position: 1.0; color: "#6A6D6A" }
            }

            Image {
                id: arrowIcon
                source: "qrc:/gcompris/src/core/resource/arrow.png"
                anchors.centerIn: parent

                Behavior {
                    NumberAnimation {
                        property: "rotation"
                        easing.type: Easing.OutExpo
                    }
                }
            }
            
            MouseArea {
                id: drawerMouseArea
                
                anchors.fill: parent
                hoverEnabled: true
                // mutually exclusive with keyboardTouchArea
                enabled: !ApplicationInfo.isMobile
                
                onEntered: parent.border.color = Qt.lighter("#6A6D6A")
                
                onExited: parent.border.color = "#6A6D6A"
                    
                onClicked: {
                    if (keyboard.state == "CLOSED")
                        keyboard.state = "OPENED";
                    else if (keyboard.state == "OPENED")
                        keyboard.state = "CLOSED";
                }
            }
        }

        ListView {
            id: rowList
            
            anchors.top: parent.top
            anchors.topMargin: keyboardDrawer.height + keyboard.margin
            anchors.left: parent.left
            anchors.margins: keyboard.margin
            width: parent.width
            height: parent.height - keyboard.margin * 2 - keyboardDrawer.height
            spacing: keyboard.rowSpacing
            orientation: Qt.Vertical
            verticalLayoutDirection: ListView.TopToBottom
            interactive: false
    
            model: rowListModel

            delegate:
                Item {
                    /* Wrap keyboardRow for attaching a MouseArea. Not possible
                     * in Row-s directly */ 
                    id: rowListDelegate
                    width: rowList.width
                    height: keyboardRow.height
                    x: keyboardRow.x
                    y: keyboardRow.y
                    z: keyboardRow.z

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        propagateComposedEvents: true
                        
                        // update index to allow for updating z value of the rows
                        onEntered: rowList.currentIndex = index;
                        
                        onPressed: {
                            // same onPress for mobile
                            rowList.currentIndex = index;
                            // need to propagate through to the key for mobile!
                            mouse.accepted = false;
                        }
                    }
                    
                    Row { 
                        id: keyboardRow
                        spacing: keyboard.keySpacing
                        width: parent.width
                        
                        z: rowListDelegate.ListView.isCurrentItem ? 1 : -1
                            
                        Item {
                            // Spacer used for equalKeyWidth
                            id: keyboardRowSpacing
                            width: offset / 2;
                            height: keyboard.keyHeight
                        }

                        Repeater {
                            id: keyboardRowRepeater
        
                            z: rowListDelegate.ListView.isCurrentItem ? 1 : -1
        
                            model: keys
                            delegate: VirtualKey {
                                width: (keyboard.width - keyboardRowRepeater.count *
                                        keyboardRow.spacing - offset - keyboard.margin*2) /
                                       keyboardRowRepeater.count
                                height: keyboard.keyHeight
                            }
                            
                            onItemAdded: item.pressed.connect(keyboard.keypress);
                            
                            onItemRemoved: item.pressed.disconnect(keyboard.keypress);
                        } // Repeater
                    } // Row
            } // Item
        } // ListView
    } // background
}
