/* GCompris - DialogHelp.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
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
