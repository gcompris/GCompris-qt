/* GCompris - DialogHelp.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import GCompris 1.0

/**
 * GCompris' full screen help dialog.
 * @ingroup infrastructure
 *
 * Used in Menu.qml as well as all activities to show more detailed
 * information like author, manual, difficulty etc. as defined in each
 * activities ActivityInfo.qml
 *
 * The help screens for the activities are generated automatically by
 * the core and are started via the 'help' button on the Bar.
 *
 * @sa Bar.helpClicked, BarEnumContent.help, DialogBackground, ActivityInfo
 */
DialogBackground {
    visible: false
    title: activityInfo.title
    titleIcon: activityInfo.difficulty != 0 ? "qrc:/gcompris/src/core/resource/difficulty" +
               activityInfo.difficulty + ".svg" : ""
    property QtObject activityInfo: ActivityInfoTree.currentActivity

    function getIcon() {
        if(activityInfo.icon) {
            return "qrc:/gcompris/src/activities/" + activityInfo.icon
        }
        return ""
    }
    
    function reformat(string) {
        var text = string.replace(/^    (.*)\n/gm,'<ul><li>$1</li></ul>')
        text = text.replace(/\n/gm,'<br/>')
        return text
    }

    function getContent() {
        var contentText = "<b>" + activityInfo.description + "</b>"
        contentText += "<br/><br/>"
        if(activityInfo.author) {
            contentText += "<b>" + qsTr("Author:") + " </b>" + activityInfo.author
            contentText += "<br/><br/>"
        }
        if(activityInfo.prerequisite) {
            contentText += "<b>" + qsTr("Prerequisite:") + " </b>" + activityInfo.prerequisite
            contentText += "<br/><br/>"
        }
        if(activityInfo.goal) {
            var goal = reformat(activityInfo.goal)
            contentText += "<b>" + qsTr("Goal:") + " </b>" + goal
            contentText += "<br/><br/>"
        }
        if(activityInfo.manual) {
            var manual = reformat(activityInfo.manual)
            contentText += "<b>" + qsTr("Manual:") + " </b>" + manual
            contentText += "<br/><br/>"
        }
        if(activityInfo.credit) {
            contentText += "<b>" + qsTr("Credit:") + " </b>" + activityInfo.credit
            contentText += "<br/><br/>"
        }
        if(activityInfo.section) {
            contentText += "<b>" + qsTr("Section:") + " </b>" + activityInfo.section
            contentText += " (" + activityInfo.name.split('/')[0] + ")"
            contentText += "<br/><br/>"
        }
        return contentText
    }

    contentIcon: getIcon()
    content: getContent()

}
