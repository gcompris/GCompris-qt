/* GCompris - Bar.qml
 *
 * SPDX-FileCopyrightText: 2014-2016 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0
import "qrc:/gcompris/src/core/core.js" as Core

/**
 * A QML component for GCompris' navigation bar.
 * @ingroup components
 *
 * The Bar is visible in all activities and the main menu screen. It can be
 * hidden by clicking on the 'toggle' region.
 *
 * It can consist of a couple of child-elements, mostly buttons, defined
 * in the BarEnumContent container. An activity can define which elements its bar should
 * present using the content property. In most cases it contains at least
 * BarEnumContent.help, BarEnumContent.home and BarEnumContent.level.
 *
 * Cf. the BarEnumContent container for a full list of available Bar elements.
 *
 * Cf. the Bar object used in Template.qml as an example of how a minimal
 * Bar implementation should look like.
 *
 * @sa BarButton, BarEnumContent
 * @inherit QtQuick.Item
 */
Item {
    id: bar

    /**
      * type: real
      * Minimum size for BarZoom
      */
    readonly property real minWidth: (parent.width - 20 -
                                      10 * ApplicationInfo.ratio) / (totalWidth + textLength)

    /**
      * type: real
      * Maximum size for barZoom
      */
    readonly property real maxWidth: 1.2 * ApplicationInfo.ratio

    /**
      * type: real
      * Length of level String
      */
    property real textLength

    /**
      * type: real
      * The maximum size allowed for the bar
      */
    readonly property real maxBarWidth: (totalWidth+textLength) * maxWidth +
                               (numberOfButtons - 1) * 5 + 10 * ApplicationInfo.ratio
    /**
      * type: real
      * Font size for text level
      */
    readonly property real textSize: (parent.width<maxBarWidth) ? 32 * minWidth / maxWidth : 32

    /**
     * type:real
     * Zoom factor of the bar and its children.
     */
    property real barZoom: (parent.width<maxBarWidth) ? minWidth : maxWidth

    /**
      * type: real
      * Keeps track of the number of buttons that are displayed
      */
    property int numberOfButtons: 0

    //totalWidth has 66 as initial value because it will always have the "hideBar" button
    /**
      * type: real
      * Width of all the buttons
      */
    property real totalWidth: 66

    readonly property int fullButton: 66
    readonly property int halfButton: 30

    readonly property int fullButtonScaled: fullButton * barZoom
    readonly property int halfButtonScaled: halfButton * barZoom

    /**
     * type:BarEnumContent
     * Defines the content/children of the bar.
     *
     * @sa BarEnumContent
     */
    property BarEnumContent content

    /**
     * type:int
     * Current level to be shown in the level child.
     *
     * Set this to the current level of your activity.
     */
    property int level: 0

    /**
     * Emitted when the about button was clicked.
     */
    signal aboutClicked

    /**
     * Emitted when the help button was clicked.
     *
     * Show help dialog upon this signal.
     */
    signal helpClicked

    /**
     * Emitted when the config button was clicked.
     *
     * Should be implemented if an activity provides per-activity
     * configuration.
     */
    signal configClicked

    /**
     * Emitted when the next level button was clicked.
     *
     * Switch to the next level upon this signal.
     */
    signal nextLevelClicked

    /**
     * Emitted when the previous level button was clicked.
     *
     * Switch to the previous level upon this signal.
     */
    signal previousLevelClicked

    /**
     * Emitted when the repeat button was clicked.
     *
     * Implement if your activity needs to repeat audio voices.
     */
    signal repeatClicked

    /**
     * Emitted when the reload button was clicked.
     *
     * Implement if you want to support repeating a level from the beginning.
     */
    signal reloadClicked

    /**
     * Emitted when the hint button was clicked.
     *
     * Implement if your activity needs a hint to help children.
     */
    signal hintClicked

    /**
     * Emitted when the activity configuration button was clicked.
     *
     * Only in menu to change the activity configuration.
     */
    signal activityConfigClicked

    /**
     * Emitted when the home button was clicked.
     *
     * Should always be connected to the ActivityBase.home signal and thus
     * return to the home/main menu.
     */
    signal homeClicked

    /// @cond INTERNAL_DOCS

    /*
     * A list of all our possible buttons.
     *
     * bid = Button ID. And references the Component object of the button
     * This way we can have any visual object in the bar.
     */
    property var buttonList: [
        {
            'bid': exit,
            'contentId': content.exit,
            'allowed': !ApplicationSettings.isKioskMode
        },
        {
            'bid': about,
            'contentId': content.about,
            'allowed': true
        },
        {
            'bid': help,
            'contentId': content.help,
            'allowed': true
        },
        {
            'bid': home,
            'contentId': content.home,
            'allowed': true
        },
        {
            'bid': previous,
            'contentId': content.level,
            'allowed': true
        },
        {
            'bid': levelText,
            'contentId': content.level,
            'allowed': true
        },
        {
            'bid': next,
            'contentId': content.level,
            'allowed': true
        },
        {
            'bid': repeat,
            'contentId': content.repeat,
            'allowed': true
        },
        {
            'bid': reload,
            'contentId': content.reload,
            'allowed': true
        },
        {
            'bid': config,
            'contentId': content.config,
            'allowed': !ApplicationSettings.isKioskMode
        },
        {
            'bid': hint,
            'contentId': content.hint,
            'allowed': true
        },
        {
            'bid': activityConfigImage,
            'contentId': content.activityConfig,
            'allowed': !ApplicationSettings.isKioskMode
        },
        {
            'bid': downloadImage,
            'contentId': content.download,
            'allowed': true
        }
    ]

    /* internal? */
    property var buttonModel

    x: 0
    anchors.bottom: parent.bottom
    width: openBar.width
    height: openBar.height
    z: 1000

    function show(newContent) {
        content.value = newContent
    }

    Connections {
        target: DownloadManager

        onDownloadStarted: content.value |= content.download
        onAllDownloadsFinished: content.value &= ~content.download
        onError: content.value &= ~content.download
    }

    Image {
        id: openBar
        source: "qrc:/gcompris/src/core/resource/bar_open.svg";
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        sourceSize.width: fullButtonScaled
        MouseArea {
            anchors.fill: parent

            onClicked: {
                ApplicationSettings.isBarHidden = !ApplicationSettings.isBarHidden;
            }
        }
    }

    function computeWidth(bid) {
        if (bid===levelText) {
            return 0
        }
        else if (bid===previous||bid===next)
            return halfButton
        else return fullButton
    }

    function updateContent() {
        var newButtonModel = new Array()
        numberOfButtons = 0
        totalWidth = 66;
        for(var def in buttonList) {
            if((content.value & buttonList[def].contentId) &&
               buttonList[def].allowed) {
                newButtonModel.push(buttonList[def])
                totalWidth += computeWidth(buttonList[def].bid)
                numberOfButtons++
            }
        }
        buttonModel = newButtonModel
    }

    Connections {
        target: content
        onValueChanged: updateContent()
    }

    onContentChanged: {
        updateContent()
    }

    Row {
        id: barRow
        spacing: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.left: openBar.right
        anchors.leftMargin: 10 * ApplicationInfo.ratio
        property bool isHidden: false
        Repeater {
            model: buttonModel
            Loader {
                sourceComponent: modelData.bid
            }
        }

        state: ApplicationSettings.isBarHidden ? "hidden" : "shown"

        states: [
            State {
                name: "shown"

                AnchorChanges {
                    target: barRow
                    anchors.top: undefined
                    anchors.bottom: parent.bottom
                }
            },
            State {
                name: "hidden"

                AnchorChanges {
                    target: barRow
                    anchors.bottom: undefined
                    anchors.top: parent.bottom
                }
            }
        ]

        transitions: Transition {
            SequentialAnimation {
                ScriptAction { script: if(barRow.state === "shown") barRow.isHidden = false }
                AnchorAnimation { duration: 800; easing.type: Easing.OutBounce }
                ScriptAction { script: if(barRow.state === "hidden") barRow.isHidden = true }
            }
        }
        populate: Transition {
            NumberAnimation {
                properties: "x,y"; from: 200;
                duration: 1500; easing.type: Easing.OutBounce
            }
        }
        add: Transition {
            NumberAnimation {
                properties: "x,y"; from: 200;
                duration: 1500; easing.type: Easing.OutBounce
            }
        }
        move: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: 1500; easing.type: Easing.OutBounce
            }
        }
    }

    // All the possible bar buttons are defined here
    // ---------------------------------------------
    Component {
        id: exit
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_exit.svg";
            sourceSize.width: fullButtonScaled
            visible: barRow.isHidden === false
            onClicked: Core.quit(bar.parent);
        }
    }
    Component {
        id: about
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_about.svg";
            sourceSize.width: fullButtonScaled
            visible: barRow.isHidden === false
            onClicked: bar.aboutClicked()
        }
    }
    Component {
        id: help
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_help.svg";
            sourceSize.width: fullButtonScaled
            visible: barRow.isHidden === false
            onClicked: bar.helpClicked()
        }
    }
    Component {
        id: previous
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_previous.svg";
            sourceSize.width: halfButtonScaled
            visible: barRow.isHidden === false
            onClicked: {
                if(typeof bonus !== "undefined")
                    bonus.haltBonus();
                bar.previousLevelClicked();
            }
        }
    }
    Component {
        id: levelText
        GCText {
            id: levelTextId
            text: "" + level
            fontSize: textSize
            font.weight: Font.DemiBold
            style: Text.Outline
            styleColor: "black"
            color: "white"
            visible: content.level & content.value && barRow.isHidden === false
            onTextChanged: {
                if (level>9)
                    textLength = fullButtonScaled
                else textLength = halfButtonScaled
            }
        }
    }
    Component {
        id: next
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_next.svg";
            sourceSize.width: halfButtonScaled
            visible: barRow.isHidden === false
            onClicked: {
                if(typeof bonus !== "undefined")
                    bonus.haltBonus();
                bar.nextLevelClicked();
            }
        }
    }
    Component {
        id: repeat
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_repeat.svg";
            sourceSize.width: fullButtonScaled
            visible: barRow.isHidden === false
            onClicked: bar.repeatClicked()
        }
    }
    Component {
        id: hint
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_hint.svg";
            sourceSize.width: fullButtonScaled
            visible: barRow.isHidden === false
            onClicked: bar.hintClicked()
        }
    }
    Component {
        id: activityConfigImage
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_activity_config.svg";
            sourceSize.width: fullButtonScaled
            visible: barRow.isHidden === false
            onClicked: bar.activityConfigClicked()
        }
    }
    Component {
        id: reload
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_reload.svg";
            sourceSize.width: fullButtonScaled
            visible: barRow.isHidden === false
            onClicked: bar.reloadClicked()
        }
    }
    Component {
        id: config
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_config.svg";
            sourceSize.width: fullButtonScaled
            visible: barRow.isHidden === false
            onClicked: bar.configClicked()
        }
    }
    Component {
        id: home
        BarButton {
            // Replace home icon with exit icon in case activity is started as standalone
            source: ActivityInfoTree.startingActivity != "" ?
                "qrc:/gcompris/src/core/resource/bar_exit.svg" :
                "qrc:/gcompris/src/core/resource/bar_home.svg";
            sourceSize.width: fullButtonScaled
            visible: barRow.isHidden === false
            onClicked: {
                bar.homeClicked();
            }
        }
    }
    Component {
        id: downloadImage
        AnimatedImage {
            source: "qrc:/gcompris/src/core/resource/loader.gif"
            visible: barRow.isHidden === false
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    var downloadDialog = Core.showDownloadDialog(activity, {});
                }
            }
        }
    }

    /// @endcond
}

