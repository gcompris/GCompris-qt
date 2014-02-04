import QtQuick 2.2
import QtQuick.Controls 1.1
import GCompris 1.0

DialogBackground {
    visible: false
    title: "Help"
    property QtObject activityInfo: ActivityInfoTree.currentActivity
    subtitle: activityInfo.section


    function getContent() {
        var contentText = ""
        contentText += "<center><b>" + activityInfo.title + "</b></center>"
        contentText += "<br/><br/>"
        contentText += "<b>" + activityInfo.description + "</b>"
        contentText += "<br/><br/>"
        if(activityInfo.prerequisite) {
            contentText += "<b>" + "Prerequisite: " + "</b>" + activityInfo.prerequisite
            contentText += "<br/><br/>"
        }
        if(activityInfo.goal) {
            contentText += "<b>" + "Goal: " + "</b>" + activityInfo.goal
            contentText += "<br/><br/>"
        }
        if(activityInfo.manual) {
            var manual = activityInfo.manual.replace(/^    (.*)$/gm,'<ul><li>$1</li></ul>')
            contentText += "<b>" + "Manual: " + "</b>" + manual
            contentText += "<br/><br/>"
        }
        if(activityInfo.credit) {
            contentText += "<b>" + "Credit: " + "</b>" + activityInfo.credit
            contentText += "<br/><br/>"
        }
        return contentText
    }

    content: getContent()

}
