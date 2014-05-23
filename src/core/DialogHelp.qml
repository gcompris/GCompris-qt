/* GCompris - DialogHelp.qml
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
import QtQuick 2.2
import QtQuick.Controls 1.1
import GCompris 1.0

DialogBackground {
    visible: false
    title: activityInfo.title
    property QtObject activityInfo: ActivityInfoTree.currentActivity

    function getContent() {
        var contentText = ""
        contentText += "<b>" + activityInfo.description + "</b>"
        contentText += "<br/><br/>"
        if(activityInfo.author) {
            contentText += "<b>" + qsTr("Author") + ": </b>" + activityInfo.author
            contentText += "<br/><br/>"
        }
        contentText += "<br/><br/>"
        if(activityInfo.prerequisite) {
            contentText += "<b>" + qsTr("Prerequisite") + ": </b>" + activityInfo.prerequisite
            contentText += "<br/><br/>"
        }
        if(activityInfo.goal) {
            contentText += "<b>" + qsTr("Goal") + ": </b>" + activityInfo.goal
            contentText += "<br/><br/>"
        }
        if(activityInfo.manual) {
            var manual = activityInfo.manual.replace(/^    (.*)$/gm,'<ul><li>$1</li></ul>')
            manual = manual.replace(/\n/gm,'<br/>')
            contentText += "<b>" + qsTr("Manual") + ": </b>" + manual
            contentText += "<br/><br/>"
        }
        if(activityInfo.credit) {
            contentText += "<b>" + qsTr("Credit") + ": </b>" + activityInfo.credit
            contentText += "<br/><br/>"
        }
        if(activityInfo.section) {
            contentText += "<b>" + qsTr("Section: ") + "</b>" + activityInfo.section
            contentText += "<br/><br/>"
        }
        return contentText
    }

    content: getContent()

}
