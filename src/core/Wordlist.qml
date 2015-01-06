/* GCompris - Wordlist.qml
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

/** Wordlist: Loads and maintains GCompris wordlists in json format
 * 
 * It expects and returns the following wordlist format (UTF8 encoded):
 * 
 * {  "name":"default-gd",
 *    "description":"Gàidhlig",
 *    "locale":"gd",
 *    "levels":[ { "level":1,
 *                 "speed":150,                           <-- optional
 *                 "fallspeed":7000,                      <-- optional
 *                 "sublevels":10,                        <-- optional
 *                 "words":["a","jim", "beam", ... ]},    <-- mandatory
 *               { "level":2, ... }
 *             ]
 * }
 */
Item {
    id: wordlist

    property string defaultFilename: ""
    property bool useDefault: true  ///< whether to automatically fallback to defaultFilename
    property string filename: ""
    property var wordList: ({})
    property int maxLevel: 0

    signal error(string msg);

    function loadFromFile(fname) {
        filename = fname;
        var from;
        wordList = parser.parseFromUrl(filename, validateWordlist);
        if (wordList == null) {
            error("Wordlist: Invalid wordlist file " + fname);
            if (useDefault) {
                // fallback to default file:
                wordList = parser.parseFromUrl(defaultFilename, validateWordlist);
                if (wordList == null) {
                    error("Wordlist: Invalid wordlist file " + defaultFilename);
                    return;
                }
                from = "default-file " + defaultFilename;
            }
        } else
            from = "file " + fname;
        // at this point we have valid levels
        maxLevel = wordList.levels.length;
        console.log("Wordlist: loaded " + maxLevel + " levels from " + from);
        return wordList;
    }

    /* FIXME: this should be private! possible? */
    function validateWordlist(doc)
    {
        // minimal syntax check:
        var i;
        if (undefined === doc.levels)
            return false;
        for (i = 0; i < doc.levels.length; i++) {
            // check mandatory level properties only (speed, fallspeed and sublevels are optional)
            if (doc.levels[i].words.length < 1)
                return false;
        }
        if (i < 1)
            return false;
        return true;
    }

    function getLevelWordList(level) {
        if (level > maxLevel)
            return null;
        return wordList.levels[level - 1];
    }

    function getMaxSubLevel(level) {
        if (level > maxLevel)
            return null;
        return wordList.levels[level - 1].sublevels !== undefined ?
                    wordList.levels[level - 1].sublevels : 0;
    }
    
    function getRandomWord(level) {
        if (level > maxLevel)
            return null;
        return wordList.levels[level - 1].words[Math.floor(Math.random() * (wordList.levels[level - 1].words.length))];
    }
    
    JsonParser {
        id: parser

        onError: wordlist.error(msg);
    }

    Component.onCompleted: {
        if (filename != "")
            loadFromFile(filename);
    }
}
