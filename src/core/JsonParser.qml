/* GCompris - JsonParser.qml
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick 2.6
import GCompris 1.0

/**
 * A QML helper component for loading and validating JSON data.
 * @ingroup components
 *
 * @inherit QtQuick.Item
 */
QtObject {
    id: jsonparser

    /**
     * type:File
     * File with json content to parse.
     */
    property File jsonFile: File {
        id: jsonfile
        name: ""

        onError: jsonparser.error(msg);
    }

    /**
     * Emitted upon error.
     *
     * @param msg Error message.
     */
    signal error(string msg);

    /* public interface: */

    /**
     * Parse the passed json string and return a corresponding object.
     *
     * @param type:string json JSON string to parse.
     * @param type:function validateFunc Function used to semantically validate
     *      the parsed json [optional].
     *      The function must have the signature
     *      <tt>bool validateFunc(jsonString)</tt>
     *      and return @c true if json string is semantically
     *      valid, @c false otherwise.
     * @returns The object parsed from json if valid, @c null if json is
     *          syntactically or semantically invalid.
     */
    function parseString(json, validateFunc)
    {
        var doc;
        try {
            doc = JSON.parse(json);
            // validate if requested:
            if (validateFunc !== undefined
                && !validateFunc(doc)) {
                    error("JsonParser: JSON is semantically invalid");
                    return null;
            }
        } catch(e) {
            error("JsonParser: JSON is syntactically invalid: " + e);
            return null;
        }
        return doc;
    }

    /**
     * Parse a json string from the given url and return a corresponding
     * object.
     *
     * @param type:string url Source URL for the json file to parse.
     *        Supported URL-schemes: file://, qrc://.
     * @param type:functions validateFunc cf. @ref parseString
     * @returns cf. @ref parseString
     */
    function parseFromUrl(url, validateFunc)
    {
        var json = "'";
        if (url.substring(0,3) == "qrc" || url.substring(0,4) == "file"
            || url.substring(0,1) == ":") {
            json = jsonFile.read(url);
            if (json != "")
                return parseString(json, validateFunc);
        } else if (url.substring(0,4) == "http")
            error("http:// scheme not yet implemented");
        else // unknown url scheme
            error("Unknown url scheme in url parameter: " + url);
        return null;
    }
}
