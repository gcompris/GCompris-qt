/* GCompris - DialogAbout.qml
 *
 * Copyright (C) 2014 Bruno Coudoin
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
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

import GCompris 1.0

DialogBackground {
    visible: false
    title: qsTr("About GCompris")

    // TRANSLATORS: Replace this string with your names, one name per line.
    property string translators: qsTr("translator-credits")
    property string gcVersion: ApplicationInfo.GCVersion
    property string qtVersion: ApplicationInfo.QTVersion

    content: "<center><b>" + qsTr("GCompris Home Page: http://gcompris.net") + "</b></center>" + "<br/>" +
             "<center><b>" + "GCompris Qt " + gcVersion + "</b></center>" + "<br/>" +
             "<center>" + "Based on Qt " + qtVersion + "</center>" + "<br/>" +
             translators + "<br/>" +
             "<center><b>" + "Copyright 2000-2014 Bruno Coudoin and Others" + "</b></center>" + "<br/>"
}
