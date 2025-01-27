/* GCompris - DialogActivityConfig.qml
 *
 * SPDX-FileCopyrightText: 2014 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

/**
 * A QML component for a full screen configuration dialog.
 * @ingroup components
 *
 * All user editable settings are presented to the user in a
 * DialogActivityConfig dialog. The global configuration can be accessed
 * through the Bar in the main menu, activity specific configuration from the
 * respective activity.
 *
 * All config items that are shown in this dialog are persisted
 * using ApplicationSettings.
 *
 * For an example have a look at Menu.qml.
 *
 * For more details on how to add configuration to an activity cf.
 * [the wiki](https://invent.kde.org/education/gcompris/-/wikis/Developers-corner/Development-process#adding-a-configuration-for-a-specific-activity)
 *
 * @sa ApplicationSettings
 * @inherit QtQuick.Item
 */
Rectangle {
    id: dialogActivityContent
    visible: false
    focus: visible

    /* Public interface: */

    /**
     * type:object
     * The content object as loaded dynamically.
     */
    property alias configItem: loader.item

    /**
     * type:Component
     * Content component which holds the visual presentation of the
     * config settings in the QML scene.
     */
    property Component content

    /**
     * type:string
     * The name of the activity in case of per-activity config.
     *
     * Will be autogenerated unless set by the caller.
     */
    property string activityName: ""

    /**
     * type:object
     * Map containing all settings as key/value-pairs.
     *
     * Will be populated from ApplicationSettings.loadActivityConfiguration
     * and can be passed to ApplicationSettings.saveActivityConfiguration.
     */
    property var dataToSave

    property var dataValidationFunc: null

    /// @cond INTERNAL_DOCS

    property bool isDialog: true

    /**
     * type:string
     * Title of the configuration dialog.
     * Global configuration name is "Configuration".
     * For activities, it is "activity name configuration".
    */
    readonly property string title: {
        if(activityName != "")
        qsTr("%1 configuration").arg(activityInfo.title)
        else
        qsTr("Configuration")
    }
    property alias active: loader.active
    property alias loader: loader
    property QtObject activityInfo: ActivityInfoTree.currentActivity

    property ActivityBase currentActivity

    /// @endcond

    /**
     * Emitted when the config dialog has been closed.
     */
    signal close

    /**
     * Emitted when the config dialog has been started.
     */
    signal start

    /**
     * Emitted when the settings are to be saved.
     *
     * The actual persisting of the settings in the settings file is done by
     * DialogActivityConfig. The activity has to take care to update its
     * internal state.
     */
    signal saveData

    /**
     * Emitted when the config settings have been loaded.
     */
    signal loadData

    signal stop

    color: "#696da3"

    Keys.onPressed: (event) => {
        if(event.key === Qt.Key_Down) {
            scrollItem.down();
        } else if(event.key === Qt.Key_Up) {
            scrollItem.up();
        } else if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
            apply.close();
        }
    }

    Keys.onEscapePressed: {
        dialogActivityContent.close();
    }

    Keys.onReleased: (event) => {
        if(event.key === Qt.Key_Back) {
            dialogActivityContent.close();
            event.accepted = true;
        }
    }

    onClose: activity.forceActiveFocus();

    function getInitialConfiguration() {
        if(activityName == "") {
            activityName = activityInfo.name.split('/')[0];
        }
        dataToSave = ApplicationSettings.loadActivityConfiguration(activityName)
        loadData()
    }

    function saveDatainConfiguration() {
        saveData()
        ApplicationSettings.saveActivityConfiguration(activityName, dataToSave)
    }

    Column {
        visible: dialogActivityContent.active
        spacing: 10
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.horizontalCenter: parent.horizontalCenter
        width: dialogActivityContent.width - 30
        Rectangle {
            id: titleRectangle
            color: "#e6e6e6"
            radius: 10 * ApplicationInfo.ratio
            width: parent.width
            height: title.height + 10 * 2

            // The apply button
            GCButtonCancel {
                id: apply
                apply: true
                anchors.verticalCenter: titleRectangle.verticalCenter
                anchors.margins: 2 * ApplicationInfo.ratio
                onClose: {
                    if (dialogActivityContent.dataValidationFunc && !
                        dialogActivityContent.dataValidationFunc()) {
                        console.log("Configuration data is invalid, not saving!");
                    return;
                        }
                        saveData()
                        if(activityName != "") {
                            ApplicationSettings.saveActivityConfiguration(activityName, dataToSave)
                        }
                        dialogActivityContent.close()
                }
            }

            GCText {
                id: title
                text: dialogActivityContent.title
                width: titleRectangle.width - 120 * ApplicationInfo.ratio //minus twice the apply button size
                height: 50 * ApplicationInfo.ratio
                anchors.horizontalCenter: titleRectangle.horizontalCenter
                anchors.verticalCenter: titleRectangle.verticalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                minimumPointSize: 7
                fontSize: largeSize
                font.weight: Font.DemiBold
                wrapMode: Text.WordWrap
            }
        }

        Rectangle {
            color: "#bdbed0"
            radius: 10 * ApplicationInfo.ratio
            width: dialogActivityContent.width - 30
            height: dialogActivityContent.height - (2 * parent.anchors.topMargin) - titleRectangle.height - parent.spacing
            border.color: "white"
            border.width: 3 * ApplicationInfo.ratio

            Flickable {
                id: flick
                maximumFlickVelocity: dialogActivityContent.height
                boundsBehavior: Flickable.StopAtBounds
                anchors.margins: 10 * ApplicationInfo.ratio
                anchors.fill: parent
                flickableDirection: Flickable.VerticalFlick
                clip: true
                contentHeight: contentItem.childrenRect.height + 40 * ApplicationInfo.ratio
                interactive: dialogActivityContent.focus
                Loader {
                    id: loader
                    active: false
                    sourceComponent: dialogActivityContent.content
                    property alias rootItem: dialogActivityContent
                }
            }

            // The scroll buttons
            GCButtonScroll {
                id: scrollItem
                anchors.right: parent.right
                anchors.rightMargin: 5 * ApplicationInfo.ratio
                anchors.bottom: flick.bottom
                anchors.bottomMargin: 5 * ApplicationInfo.ratio
                onUp: flick.flick(0, 1000)
                onDown: flick.flick(0, -1000)
                upVisible: flick.atYBeginning ? false : true
                downVisible: flick.atYEnd ? false : true
            }
        }
    }
}
