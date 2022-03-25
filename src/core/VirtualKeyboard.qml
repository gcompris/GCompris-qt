/* GCompris - VirtualKeyboard.qml
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

/**
 * A QML component providing an on screen keyboard.
 * @ingroup components
 *
 * VirtualKeyboard displays a virtual on screen keyboard that can be used
 * in applications that need keyboard support, especially on mobile devices.
 *
 * The component itself does not provide builtin localized keyboard layouts,
 * the user has to define the keyboard-layout dynamically.
 *
 * @inherit QtQuick.Item
 */
Item {
    id: keyboard

    /* Public interface: */

    /**
     * type:list
     *
     * Default basic qwerty-layout used unless the user provides another.
     * @sa layout.
     */
    readonly property var qwertyLayout:
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


    /**
     * type:string
     * Symbol that can be used for the space key.
    */
    readonly property string space: "\u2423"

    /**
     * type:string
     * Symbol that can be used for the backspace key.
     */
    readonly property string backspace: "\u2190"

    /**
     * type:string
     * Symbol for the shift-up key.
     */
    readonly property string shiftUpSymbol:   "\u21E7"

    /**
     * type:string
     * Symbol for the shift-down key.
     */
    readonly property string shiftDownSymbol: "\u21E9"

    /**
     * type:list
     * Keyboard layout.
     *
     * The layout should be provided by the user. It can contain
     * unicode characters, and can be set dynamically also on a per-level
     * basis.
     *
     * The expected format of the @ref layout property is a list of row lists.
     * Example:
     *
     * @code
     * [
     *    [                                    <-- start of the first row
     *      { label: "1", shiftLabel: "!" },   <-- first key of the first row
     *      { label: "2", shiftLabel: "@" },
     *      ...
     *    ],
     *    [
     *      { label: "q", shiftLabel: "Q" },
     *      { label: "w", shiftLabel: "W" },
     *      ...
     *    ],
     *    ...
     * ]
     * @endcode
     *
     * The order passed in layout will not be altered.
     *
     * Use the @ref shiftKey property to activate a shift button which allows
     * to assign 2 letters on one key. You can define an additional shiftLabel
     * per key, or leave it undefined, in which case VirtualKeyboard
     * automatically defines the shift-label (using
     * String.toLocaleUpperCase()).
     *
     * Default is to use the qwertyLayout.
     *
     * @sa qwertyLayout shiftKey
     */
    property var layout: null

    /**
     * type:bool
     * Whether a shift key should be used.
     */
    property bool shiftKey: false

    // property bool ctrlKey: false;
    // ...

    /**
     * type:int
     * Vertical spacing between rows in pixel.
     * Default: 5 * ApplicationInfo.ratio
     */
    property int rowSpacing: 5 * ApplicationInfo.ratio

    /**
     * type:int
     * Horizontal spacing between keys in pixel.
     * Default: 3 * ApplicationInfo.ratio
     */
    property int keySpacing: 3 * ApplicationInfo.ratio

    /**
     * type:int
     * Height of the keys in pixel.
     * Default: 45 * ApplicationInfo.ratio
     */
    property int keyHeight: 45 * ApplicationInfo.ratio

    /**
     * type:int
     * Margin around the keyboard in pixel.
     * Default: 5 * ApplicationInfo.ratio
     */
    property int margin: 5 * ApplicationInfo.ratio

    /**
     * type:bool
     * Whether the keyboard should be hidden.
     *
     * Besides this property the visibility of the virtual keyboard also
     * depends on the setting ApplicationSettings.isVirtualKeyboard and
     * its successful initialization.
     */
    property bool hide

    /**
     * Emitted for every keypress.
     *
     * @param text The label of the pressed key.
     */
    signal keypress(string text)

    /**
     * Emitted upon error.
     *
     * @param msg Error message.
     */
    signal error(string msg)

    /// @cond INTERNAL_DOCS

    opacity: 0.9

    visible: !hide && ApplicationSettings.isVirtualKeyboard && priv.initialized
    enabled: visible

    z: 9999
    width: parent.width
    height: visible ? priv.cHeight : 0
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

    WorkerScript {
        id: keyboardWorker

        source: "virtualkeyboard_worker.js"
        onMessage: {
            // worker finished
            activity.loading.stop();
            if (messageObject.error !== "") {
                error(messageObject.error);
            } else {
                // update all changed values (except the model):
                priv.numRows = messageObject.numRows;
                priv.initialized = messageObject.initialized;
            }
        }
    }

    function populateKeyboard(a) {
        activity.loading.start();
        // populate asynchronously in a worker thread:
        keyboardWorker.sendMessage({
                                       shiftKey: keyboard.shiftKey,
                                       shiftUpSymbol: keyboard.shiftUpSymbol,
                                       shiftDownSymbol: keyboard.shiftDownSymbol,
                                       a: a,
                                       rowListModel: rowListModel
                                   });
    }

    function handleVirtualKeyPress(virtualKey) {
        if (virtualKey.specialKey === Qt.Key_Shift)
            keyboard.modifiers ^= Qt.ShiftModifier;
//      else if (virtualKey.specialKey == Qt.Key_Alt)
//          keyboard.modifiers ^= Qt.AltModifier;
        else
            keyboard.keypress(virtualKey.text);
    }

    onLayoutChanged: {
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
         */
    }

    Behavior on height {
        NumberAnimation {
            duration: 500
            easing.type: Easing.OutCubic
        }
    }

    Rectangle {
        id: keyboardBackground

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
    } // keyboardBackground

    /// @endcond
}
