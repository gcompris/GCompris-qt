/* GCompris - VirtualKeyboard.qml
 *
 * Copyright (C) 2014 Holger Kaelberer <holger.k@elberer.de>
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
    readonly property var qwertyLayout: // a default layout (qwerty)
                      [  [ { label: "1", shiftLabel: "!" },
                           { label: "2", shiftLabel: "@" },
                           { label: "3", shiftLabel: "#" },
                           { label: "4", shiftLabel: "$" },
                           { label: "5", shiftLabel: "%" },
                           { label: "6", shiftLabel: "^" },
                           { label: "7", shiftLabel: "&" },
                           { label: "8", shiftLabel: "*" },
                           { label: "9", shiftLabel: "(" },
                           { label: "0", shiftLabel: ")" },
                           { label: "-", shiftLabel: "_" },
                           { label: "=", shiftLabel: "+" } ],
                         
                         [ { label: "q", shiftLabel: "Q" },
                           { label: "w", shiftLabel: "W" },
                           { label: "e", shiftLabel: "E" },
                           { label: "r", shiftLabel: "R" },
                           { label: "t", shiftLabel: "T" },
                           { label: "y", shiftLabel: "Y" },
                           { label: "u", shiftLabel: "U" },
                           { label: "i", shiftLabel: "I" },
                           { label: "o", shiftLabel: "O" },
                           { label: "p", shiftLabel: "P" } ],
                           
                         [ { label: "a", shiftLabel: "A" },
                           { label: "s", shiftLabel: "S" },
                           { label: "d", shiftLabel: "D" },
                           { label: "f", shiftLabel: "F" },
                           { label: "g", shiftLabel: "G" },
                           { label: "h", shiftLabel: "H" },
                           { label: "j", shiftLabel: "J" },
                           { label: "k", shiftLabel: "K" },
                           { label: "l", shiftLabel: "L" } ],
                           
                         [ { label: "z", shiftLabel: "Z" },
                           { label: "x", shiftLabel: "X" },
                           { label: "c", shiftLabel: "C" },
                           { label: "v", shiftLabel: "V" },
                           { label: "b", shiftLabel: "B" },
                           { label: "n", shiftLabel: "N" },
                           { label: "m", shiftLabel: "M" } ]]
    
    readonly property string backspace: "\u2190"
    readonly property string shiftUpSymbol:   "\u21E7"
    readonly property string shiftDownSymbol: "\u21E9"

    property var layout: null
    property bool shiftKey: false
    // property bool ctrlKey: false;
    // ...

    property int rowSpacing: 5 * ApplicationInfo.ratio
    property int keySpacing: 3 * ApplicationInfo.ratio
    property int keyHeight: 45 * ApplicationInfo.ratio
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
    
    property int modifiers: Qt.NoModifier;  // currently active key modifiers, internal only

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
        // if we need special keys, put them in a separate row at the bottom:
        if (keyboard.shiftKey) {
            a.push([ {
                label     : keyboard.shiftUpSymbol + " Shift",
                shiftLabel: keyboard.shiftDownSymbol + " Shift",
                specialKeyValue: Qt.Key_Shift } ]);
        }
        var i
        var seenLabels = [];
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
                if (undefined === a[i][j].specialKeyValue)
                    a[i][j].specialKeyValue = 0;
                var label = a[i][j].label;
                // if we have a shift key lowercase all labels:
                if (shiftKey && label == label.toLocaleUpperCase())
                    label = label.toLocaleLowerCase();
                // drop duplicates (this alters keyboard layout, though!):
                if (seenLabels.indexOf(label) !=-1) {
                    a[i].splice(j, 1);
                    j--;
                    continue;
                }
                a[i][j].label = label;
                seenLabels.push(label);
                if (keyboard.shiftKey && undefined === a[i][j].shiftLabel)
                    a[i][j].shiftLabel = a[i][j].label.toLocaleUpperCase();
            }
        }
        
        // populate
        for (i = 0; i < a.length; i++) {
            var row = a[i];
            var offset = 0;
            rowListModel.append({ rowNum: i,
                                  offset: offset,
                                  keys: row});
        }
        priv.numRows = i;
        priv.initialized = (priv.numRows > 0);
    }
    
    function handleVirtualKeyPress(virtualKey) {
        if (virtualKey.specialKey == Qt.Key_Shift)
            keyboard.modifiers ^= Qt.ShiftModifier;
//      else if (virtualKey.specialKey == Qt.Key_Alt)
//          keyboard.modifiers ^= Qt.AltModifier;
        else
            keyboard.keypress(virtualKey.text);
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
         *   keys: [ { label: "a", shiftLabel: "A" },
         *           { label: "b", shiftLabel: "B" },
         *           { label: "Shift", shiftLabel: "Shift", special },
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
                                modifiers: keyboard.modifiers
                                specialKey: specialKeyValue
                            }
                            
                            onItemAdded: item.pressed.connect(keyboard.handleVirtualKeyPress);
                            
                            onItemRemoved: item.pressed.disconnect(keyboard.handleVirtualKeyPress);
                        } // Repeater
                    } // Row
            } // Item
        } // ListView
    } // background
}
