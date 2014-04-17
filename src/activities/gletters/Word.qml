/* GCompris - Word.qml
 *
 * Copyright (C) 2014 Holger Kaelberer
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
 *
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
import "gletters.js" as Activity

Item {
    id: word
    
    width: wordText.width
    height: wordText.height
    
    ///< index into text.split("") where next typed match should occur
    property int unmatchedIndex: 0;
    property alias text: wordText.text;
    
    /** Called when user typed the next letter correctly */
    function  nextCharMatched()
    {
        unmatchedIndex++;
        // FIXME: update char color of matched chars for multichar words!
    }
    
    function startMoving(dur)
    {
        down.duration = dur;
        down.restart();
    }
    
    function isCompleted()
    {
        return (unmatchedIndex === text.length);
    }

    Text {
        id: wordText
        
        text: ""
        font.pointSize: 35
        font.bold: true
        color: "navy"        
    }
    
    NumberAnimation {
        id: down
        target: word
        property: "y"
        to: parent.height
        duration: 10000
        
        onStopped: {
            //console.log("Gletters: word hit the ground: " + wordText.text);
            Activity.deleteWord(word);
        }
    }
}
