import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Dialogs 1.1
import GCompris 1.0

Rectangle {
    id: dialogConfig
    color: "#696da3"
    border.color: "black"
    border.width: 1
    z: 1000
    property bool isDialog: true
    property string title
    property string subtitle
    property string content
    signal close
    signal start
    signal pause
    signal play
    signal stop

    visible: false
    title: "Configuration"
    property QtObject activityInfo: ActivityInfoTree.currentActivity
    //subtitle: activityInfo.section

    Row {
        spacing: 2
        Item { width: 10; height: 1 }

        Column {
            spacing: 10
            anchors.top: parent.top
            Item { width: 1; height: 10 }
            Rectangle {
                color: "#e6e6e6"
                radius: 6.0
                width: dialogConfig.width - 30
                height: 52
                border.color: "black"
                border.width: 2

                Item {
                    id: title
                    width: parent.width
                    height: 32
                    Text {
                        text: dialogConfig.title
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.family: "Helvetica"
                        color: "black"
                        fontSizeMode: Text.Fit
                        minimumPointSize: 8
                        font.pointSize: 24
                        font.weight: Font.DemiBold
                    }
                }
                Item {
                    width: parent.width
                    height: 18
                    anchors.top: title.bottom
                    Text {
                        text: dialogConfig.subtitle
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.family: "Helvetica"
                        color: "black"
                        fontSizeMode: Text.Fit
                        minimumPointSize: 7
                        font.pointSize: 20
                    }
                }
            }
            Rectangle {
                color: "#e6e6e6"
                radius: 6.0
                width: dialogConfig.width - 30
                height: dialogConfig.height - 100
                border.color: "black"
                border.width: 2
                anchors.margins: 100

                Flickable {
                    id: flick
                    anchors.margins: 8
                    anchors.fill: parent
                    // contentWidth: textContent.contentWidth
                    // contentHeight: textContent.contentHeight
                    flickableDirection: Flickable.VerticalFlick
                    clip: true

                    Column {
                        spacing: 10
                        // Put configuration here
                        CheckBox {
                            id: enableAudioBox
                            text: "Enable audio"
                            checked: isAudioEnabled
                            style: CheckBoxStyle {
                                indicator: Image {
                                    sourceSize.height: 50 * ApplicationInfo.ratio
                                    source:
                                        control.checked ? "qrc:/gcompris/src/core/resource/apply.svgz" :
                                                          "qrc:/gcompris/src/core/resource/cancel.svgz"
                                }
                            }
                            onCheckedChanged: {
                                isAudioEnabled = checked;
                            }
                        }
                        ComboBox {
                            id: languageBox
                            style: GCComboBoxStyle {}
                            model: languages
                            width: 200
                            onCurrentIndexChanged:
                                if(languages != undefined) {
                                    console.debug(languages.get(currentIndex).text +
                                                  ", " + languages.get(currentIndex).locale)
                                }
                        }
                    }
                }
            }
            Item { width: 1; height: 10 }
        }
    }

    // The cancel button
    Image {
        id: cancel
        source: "qrc:/gcompris/src/core/resource/cancel.svgz";
        fillMode: Image.PreserveAspectFit
        anchors.right: parent.right
        anchors.top: parent.top
        smooth: true
        sourceSize.width: 60 * ApplicationInfo.ratio
        anchors.margins: 10
        SequentialAnimation {
            id: anim
            running: true
            loops: Animation.Infinite
            NumberAnimation {
                target: cancel
                property: "rotation"
                from: -10; to: 10
                duration: 500
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: cancel
                property: "rotation"
                from: 10; to: -10
                duration: 500
                easing.type: Easing.InOutQuad }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(hasConfigChanged()) {
                    // If locale changed, ask the user to restart GCompris
                    if(ApplicationInfo.locale != languages.get(languageBox.currentIndex).locale) {
                        confirmDialog.text = qsTr("Do you want to apply these changes ?\n
Locale has changed, restart the application to have new locale")
                    }
                    else {
                        confirmDialog.text = qsTr("Do you want to apply these changes ?");
                    }
                    confirmDialog.open()
                }
                else {
                    close();
                }
            }
        }
    }

    property bool isAudioEnabled: ApplicationInfo.isAudioEnabled

    onStart: {
        // Synchronize settings with data
        isAudioEnabled = ApplicationInfo.isAudioEnabled
        enableAudioBox.checked = isAudioEnabled

        // Set locale
        for(var i = 0 ; i < languages.count ; i ++) {
            print(i + " " + languages.get(i).locale)
            if(languages.get(i).locale == ApplicationInfo.locale) {
                languageBox.currentIndex = i;
                break;
            }
        }
    }

    MessageDialog {
        id: confirmDialog
        title: qsTr("Confirm changes")
        text: qsTr("Do you want to apply these changes ?")
        icon: StandardIcon.Question
        standardButtons: StandardButton.Yes | StandardButton.No | StandardButton.Cancel
        onYes: {  // Save settings, propagate signals then quit the page
            ApplicationInfo.isAudioEnabled = isAudioEnabled
            ApplicationInfo.locale = languages.get(languageBox.currentIndex).locale
            dialogConfig.close()
        }
        onNo: {
            dialogConfig.close() // Do not save, quit the page
        }
        onRejected: {
            close() // Cancel, we stay on the config page
        }
    }

    ListModel {
        id: languages
        // todo: load all from json/xml file ?
        ListElement { text:  QT_TR_NOOP("English (Great Britain)"); locale: "en_GB.UTF-8" }
        ListElement { text:  QT_TR_NOOP("English (United States)"); locale: "en_US.UTF-8" }
        ListElement { text: QT_TR_NOOP("French"); locale: "fr_FR.UTF-8" }
        ListElement { text: QT_TR_NOOP("German"); locale: "de_DE.UTF-8" }
    }

    function hasConfigChanged() {
        return (ApplicationInfo.locale != languages.get(languageBox.currentIndex).locale ||
                (ApplicationInfo.isAudioEnabled != isAudioEnabled));
    }
}
