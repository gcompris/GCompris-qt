import QtQuick 2.0
import QtQuick.Controls 1.0
import "core.js" as Core

DialogBackground {
    title: "Help"
    subtitle: section
    visible: false
    property string section
    property string contentText

    function show(section,
                  title, description,
                  prerequisite, goal, manual, credit) {
        dialogHelp.section = section
        contentText = ""
        contentText += "<center><b>" + title + "</b></center>"
        contentText += "<br/><br/>"
        contentText += "<b>" + description + "</b>"
        contentText += "<br/><br/>"
        if(prerequisite) {
            contentText += "<b>" + "Prerequisite: " + "</b>" + prerequisite
            contentText += "<br/><br/>"
        }
        if(goal) {
            contentText += "<b>" + "Goal: " + "</b>" + goal
            contentText += "<br/><br/>"
        }
        if(manual) {
            contentText += "<b>" + "Manual: " + "</b>" + manual
            contentText += "<br/><br/>"
        }
        if(credit) {
            contentText += "<b>" + "Credit: " + "</b>" + credit
            contentText += "<br/><br/>"
        }
        dialogHelp.visible = true;
    }

    content: TextArea {
        text: contentText
        font.pointSize: 12
        wrapMode: Text.WordWrap
        textFormat: TextEdit.RichText
        readOnly: true
        selectByMouse: false
        MouseArea {
            anchors.fill: parent
            onClicked: dialogHelp.visible = false
        }
    }

}
