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
    
    property string backspace: "\u2190"
    property var layout: null
    //property bool shift: false  // FIXME: add support for shift-key
    property bool equalKeyWidth: true
    property int rowSpacing: 5 * ApplicationInfo.ratio
    property int keySpacing: 3 * ApplicationInfo.ratio
    property int keyHeight: 35 * ApplicationInfo.ratio
    property int margin: 5 * ApplicationInfo.ratio
    property bool hide

    opacity: 0.9
    
    visible: !hide && ApplicationSettings.isVirtualKeyboard && priv.initialized
    enabled: visible
    
    signal keypress(string text);
    signal error(string msg);

    // internal:
    z: 9999
    width: parent.width
    height: visible ? priv.cHeight : 0
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    
    // private properties:
    QtObject {
        id: priv
        
        readonly property int cHeight: numRows * keyboard.keyHeight +
                                       (numRows + 1) * keyboard.rowSpacing
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
        priv.numRows = i;
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
    
    Behavior on height {
        NumberAnimation {
            duration: 500
            easing.type: Easing.OutCubic
        }
    }
    
    Rectangle {
        id: background
        
        width: parent.width
        height: keyboard.height
        color: "#8C8F8C"
        opacity: keyboard.opacity
        
        ListView {
            id: rowList
            
            anchors.top: parent.top
            anchors.topMargin: keyboard.margin
            anchors.left: parent.left
            anchors.margins: keyboard.margin
            width: parent.width
            height: parent.height - keyboard.margin * 2
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
