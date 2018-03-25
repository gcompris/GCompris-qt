/* GCompris - DialogActivityConfig.qml
 *
 * Copyright (C) 2014 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
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
 * [the wiki](http://gcompris.net/wiki/Qt_Quick_development_process#Adding_a_configuration_for_a_specific_activity)
 *
 * @sa ApplicationSettings
 * @inherit QtQuick.Item
 */
Rectangle {
    id: dialogActivityContent
    visible: false

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
    border.color: "black"
    border.width: 1

    function getInitialConfiguration() {
        if(activityName == "") {
            activityName = ActivityInfoTree.currentActivity.name.split('/')[0];
        }
        dataToSave = ApplicationSettings.loadActivityConfiguration(activityName)
        loadData()
    }

    function saveDatainConfiguration() {
        saveData()
        ApplicationSettings.saveActivityConfiguration(activityName, dataToSave)
    }

    Row {
        visible: dialogActivityContent.active
        spacing: 2
        Item { width: 10; height: 1 }

        Column {
            spacing: 10
            anchors.top: parent.top
            Item { width: 1; height: 10 }
            Rectangle {
                color: "#e6e6e6"
                radius: 6.0
                width: dialogActivityContent.width - 30
                height: title.height * 1.2
                border.color: "black"
                border.width: 2

                Row {
                    spacing: 2
                    padding: 8
                    Image {
                        id: titleIcon
                        anchors {
                            left: parent.left
                            top: parent.top
                            margins: 4 * ApplicationInfo.ratio
                        }
                    }

                    GCText {
                        id: title
                        text: dialogActivityContent.title
                        width: dialogActivityContent.width - (30 + cancel.width)
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: "black"
                        fontSize: 20
                        font.weight: Font.DemiBold
                        wrapMode: Text.WordWrap
                    }
                }
            }

            Rectangle {
                color: "#e6e6e6"
                radius: 6.0
                width: dialogActivityContent.width - 30
                height: dialogActivityContent.height - (30 + title.height * 1.2)
                border.color: "black"
                border.width: 2
                anchors.margins: 100

                Flickable {
                    id: flick
                    anchors.margins: 8
                    anchors.fill: parent
                    flickableDirection: Flickable.VerticalFlick
                    clip: true
                    contentHeight: contentItem.childrenRect.height + 40 * ApplicationInfo.ratio
                    Loader {
                        id: loader
                        active: false
                        sourceComponent: dialogActivityContent.content
                        property alias rootItem: dialogActivityContent
                    }
                }

                // The scroll buttons
                GCButtonScroll {
                    anchors.right: parent.right
                    anchors.rightMargin: 5 * ApplicationInfo.ratio
                    anchors.bottom: flick.bottom
                    anchors.bottomMargin: 5 * ApplicationInfo.ratio
                    onUp: flick.flick(0, 1400)
                    onDown: flick.flick(0, -1400)
                    upVisible: flick.visibleArea.yPosition <= 0 ? false : true
                    downVisible: flick.visibleArea.yPosition + flick.visibleArea.heightRatio >= 1 ? false : true
                }
            }

            Item { width: 1; height: 10 }
        }
    }

    // The cancel button
    GCButtonCancel {
        id: cancel
        onClose: {
            if (dialogActivityContent.dataValidationFunc && !
                    dialogActivityContent.dataValidationFunc()) {
                console.log("Configuration data is invalid, not saving!");
                return;
            }

            saveData()
            ApplicationSettings.saveActivityConfiguration(activityName, dataToSave)
            parent.close()
        }
    }

}
