/* GCompris - Wordlist.qml
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
import "core.js" as Core

/**
 * A Wordlist component loads and maintains GCompris wordlists.
 * @ingroup components
 *
 * It loads wordlists from json-files, validates its content and exposes
 * wordlists and levels to activities.
 *
 * It expects and returns the following wordlist format (UTF8 encoded):
 *
 * @code
 * {
 *    "name":"default-gd",
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
 * @endcode
 *
 * @inherit QtQuick.Item
 * @sa JsonParser
 */
Item {
    id: wordlist

    /**
     * type:string
     * Default filename to be used if the language specific wordlist file could
     * not be loaded.
     * Default is emtpy.
     */
    property string defaultFilename: ""

    /**
     * type:bool
     * Whether to automatically fallback to the default filename if the
     * language specific wordlist file could not be loaded.
     * Default is true.
     */
    property bool useDefault: true

    /**
     * type:string
     * Name of the file to load the language specific wordlist from.
     * Default is empty. Can also be passed directly in loadFromFile().
     * If set in the QML definition, the wordlist is autoloaded onCompleted.
     */
    property string filename: ""

    /**
     * type:object
     * Complete Wordlist content loaded. You probably want to use one of the
     * convenience accessors like getLevelWordList().
     * Default is empty.
     */
    property var wordList: ({})

    /// @cond INTERNAL_DOCS

    property var randomWordList: []
    property int maxLevel: 0

    /// @endcond

    /**
     * Emitted if an error occurs.
     * @param msg Error message.
     */
    signal error(string msg);

    /**
     * Load Wordlist from JSON Object.
     *
     * @param type:object levels to load wordlist from.
    */
    function loadFromJSON(levels) {
        wordList = {levels: levels};
        maxLevel = wordList.levels.length;
        return wordList;
    }

    /**
     * Load Wordlist from file @p fname.
     *
     * @param type:string fname Filename to load wordlist from.
     */
    function loadFromFile(fname) {
        filename = fname;
        var from;
        maxLevel = 0
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
            else {
                error("Wordlist: do not use default list, no list loaded");
                return;
            }
        } else {
            from = "file " + fname;
        }
        // at this point we have valid levels
        maxLevel = wordList.levels.length;
        console.log("Wordlist: loaded " + maxLevel + " levels from " + from);
        return wordList;
    }

    /**
     * Get wordlist data for @p level
     *
     * @param type:int level Level.
     * @returns type:object wordlist data.
     */
    function getLevelWordList(level) {
        if (level > maxLevel)
            return null;
        return wordList.levels[level - 1];
    }

    /**
     * Get number of sub-levels in @p level.
     *
     * @param type:int level Level.
     * @returns type:int Number of sublevels.
     */
    function getMaxSubLevel(level) {
        if (level > maxLevel || level === 0) {
            console.log("ERROR: Wordlist.getMaxSubLevel out of range, requested level", level,
                        "out of expected range", 1, "-", maxLevel)
            return null;
        }
        return wordList.levels[level - 1].sublevels !== undefined ?
                    wordList.levels[level - 1].sublevels : 0;
    }

    /**
     * Build a random word list for @p level.
     *
     * We don't want to propose several time the same word. First call
     * initRandomWord(level) to create the initial shuffled list of words.
     * Then call getRandomWord() to get the words one at a time.
     * If a word was not found by the child, add it again to the list
     * with appendRandomWord(word)
     *
     * @param type:int level Level.
     */
    function initRandomWord(level) {
        randomWordList = Core.shuffle(wordList.levels[level - 1].words).slice(0)
    }

    /**
     * Re-add a random word to a shuffled word list.
     *
     * @param type:string word Word to append.
     * @sa initRandomWord
     */
    function appendRandomWord(word) {
        randomWordList.unshift(word)
    }

    /**
     * Returns the next random word from a shuffled wordlist.
     *
     * @sa initRandomWord
     */
    function getRandomWord() {
        return randomWordList.pop()
    }

    /// @cond INTERNAL_DOCS

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

    /// @endcond

    JsonParser {
        id: parser

        onError: wordlist.error(msg);
    }

    Component.onCompleted: {
        if (filename != "")
            loadFromFile(filename);
    }
}
