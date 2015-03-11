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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import GCompris 1.0

Item {
    id: jsonparser
    
    signal error(string msg);

    property File jsonFile: File {
        id: jsonfile
        name: ""
    
        onError: jsonparser.error(msg);
    }

    /** public interface: */
    
    /** Parse the passed json string and return a corresponding
     * object.
     * 
     *  @param url  Source URL for the json file to parse. Supported URL-schemes:
     *             file://, qrc://. In future also http://
     * @param validateFunc  function used to semantically validate the parsed
     *                      json. Optional. Signature:
     *                      bool validateFunc(jsonString);
     *                      Should return true if json string is semantically
     *                      valid, false otherwise.
     * @returns  object
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

    /** Parse a json string from the given url and return a corresponding
     * object.
     * 
     * For details cf. parseFromUrl()
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
            error("HTTP scheme not yet implemented");
        else // unknown url scheme
            error("Unknown url scheme in url parameter");
        return null;
    }
}
