/* GCompris - Menu.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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
import QtQuick 2.6
import "../../core"
import GCompris 1.0
import QtGraphicalEffects 1.0
import "qrc:/gcompris/src/core/core.js" as Core
import QtQuick.Controls 1.5
import QtQuick.Controls.Styles 1.4

/**
 * GCompris' top level menu screen.
 *
 * Displays a grid of available activities divided subdivided in activity
 * categories/sections.
 *
 * The visibility of the section row is toggled by the setting
 * ApplicationSettings.sectionVisible.
 *
 * The list of available activities depends on the following settings:
 *
 * * ApplicationSettings.showLockedActivities
 * * ApplicationSettings.filterLevelMin
 * * ApplicationSettings.filterLevelMax
 *
 * @inherit QtQuick.Item
 */
ActivityBase {
    id: activity
    focus: true
    activityInfo: ActivityInfoTree.rootMenu
    onBack: {
        pageView.pop(to);
        // Restore focus that has been taken by the loaded activity
        if(pageView.currentItem == activity)
            focus = true;
    }

    onHome: {
        if(pageView.depth === 1 && !ApplicationSettings.isKioskMode) {
            Core.quit(main);
        }
        else {
            pageView.pop();
            // Restore focus that has been taken by the loaded activity
            if(pageView.currentItem == activity)
                focus = true;
        }
    }

    onDisplayDialog: pageView.push(dialog)

    onDisplayDialogs: {
        var toPush = new Array();
        for (var i = 0; i < dialogs.length; i++) {
            toPush.push({item: dialogs[i]});
        }
        pageView.push(toPush);
    }

    // @cond INTERNAL_DOCS
    property string url: "qrc:/gcompris/src/activities/menu/resource/"
    property var sections: [
        {
            icon: activity.url + "all.svg",
            tag: "favorite"
        },
        {
            icon: activity.url + "computer.svg",
            tag: "computer"
        },
        {
            icon: activity.url + "discovery.svg",
            tag: "discovery"
        },
        {
            icon: activity.url + "experience.svg",
            tag: "experiment"
        },
        {
            icon: activity.url + "fun.svg",
            tag: "fun"
        },
        {
            icon: activity.url + "math.svg",
            tag: "math"
        },
        {
            icon: activity.url + "puzzle.svg",
            tag: "puzzle"
        },
        {
            icon: activity.url + "reading.svg",
            tag: "reading"
        },
        {
            icon: activity.url + "strategy.svg",
            tag: "strategy"
        },
        {
            icon: activity.url + "search-icon.svg",
            tag: "search"
        }
    ]
    property string currentTag: sections[0].tag
    /// @endcond

    pageComponent: Image {
        id: background
        source: activity.url + "background.svg"
        sourceSize.width: Math.max(parent.width, parent.height)
        height: main.height
        fillMode: Image.PreserveAspectCrop

        Timer {
            // triggered once at startup to populate the keyboard
            id: keyboardFiller
            interval: 1000; running: true;
            onTriggered: { keyboard.populate(); }
        }

        function loadActivity() {
            // @TODO init of item would be better in setsource but it crashes on Qt5.6
            // https://bugreports.qt.io/browse/QTBUG-49793
            activityLoader.item.audioVoices = audioVoices
            activityLoader.item.audioEffects = audioEffects
            activityLoader.item.loading = loading

            //take the focus away from textField before starting an activity
            searchTextField.focus = false

            pageView.push(activityLoader.item)
        }

        Loader {
            id: activityLoader
            asynchronous: true
            onStatusChanged: {
                if (status == Loader.Loading) {
                    loading.start();
                } else if (status == Loader.Ready) {
                    loading.stop();
                    loadActivity();
                } else if (status == Loader.Error)
                    loading.stop();
            }
        }

        // Filters
        property bool horizontal: main.width > main.height
        property int sectionIconWidth: {
            if(horizontal)
                return Math.min(100 * ApplicationInfo.ratio, main.width / (sections.length + 1))
            else if(activity.currentTag === "search" && ApplicationSettings.isVirtualKeyboard)
                return Math.min(100 * ApplicationInfo.ratio, (background.height - (bar.height+keyboard.height)) / (sections.length + 1))
            else
                return Math.min(100 * ApplicationInfo.ratio, (background.height - bar.height) / (sections.length + 1))
        }
        property int sectionIconHeight: sectionIconWidth
        property int sectionCellWidth: sectionIconWidth * 1.1
        property int sectionCellHeight: sectionIconHeight * 1.1

        property var currentActiveGrid: activitiesGrid
        property bool keyboardMode: false
        Keys.onPressed: {
            // Ctrl-modifiers should never be handled by the search-field
            if (event.modifiers === Qt.ControlModifier) {
                if (event.key === Qt.Key_S) {
                    // Ctrl+S toggle show / hide section
                    ApplicationSettings.sectionVisible = !ApplicationSettings.sectionVisible
                }
            } else if(currentTag === "search") {
                // forward to the virtual keyboard the pressed keys
                if(event.key == Qt.Key_Backspace)
                    keyboard.keypress(keyboard.backspace);
                else
                    keyboard.keypress(event.text);
            } else if(event.key === Qt.Key_Space && currentActiveGrid.currentItem) {
                currentActiveGrid.currentItem.selectCurrentItem()
            }
        }
        Keys.onReleased: {
            keyboardMode = true
            event.accepted = false
        }
        Keys.onTabPressed: currentActiveGrid = ((currentActiveGrid == activitiesGrid) ?
                                                    section : activitiesGrid);
        Keys.onEnterPressed: if(currentActiveGrid.currentItem) currentActiveGrid.currentItem.selectCurrentItem();
        Keys.onReturnPressed: if(currentActiveGrid.currentItem) currentActiveGrid.currentItem.selectCurrentItem();
        Keys.onRightPressed: if(currentActiveGrid.currentItem) currentActiveGrid.moveCurrentIndexRight();
        Keys.onLeftPressed: if(currentActiveGrid.currentItem) currentActiveGrid.moveCurrentIndexLeft();
        Keys.onDownPressed: if(currentActiveGrid.currentItem && !currentActiveGrid.atYEnd) currentActiveGrid.moveCurrentIndexDown();
        Keys.onUpPressed: if(currentActiveGrid.currentItem && !currentActiveGrid.atYBeginning) currentActiveGrid.moveCurrentIndexUp();

        GridView {
            id: section
            model: sections
            width: horizontal ? main.width : sectionCellWidth
            height: {
               if(horizontal)
                   return sectionCellHeight
               else if(activity.currentTag === "search" && ApplicationSettings.isVirtualKeyboard)
                   return sectionCellHeight * (sections.length+1)
               else
                   return main.height - bar.height
            }
            x: ApplicationSettings.sectionVisible ? section.initialX : -sectionCellWidth
            y: ApplicationSettings.sectionVisible ? section.initialY : -sectionCellHeight
            cellWidth: sectionCellWidth
            cellHeight: sectionCellHeight
            interactive: false
            keyNavigationWraps: true
            property int initialX: 4
            property int initialY: 4

            Component {
                id: sectionDelegate
                Item {
                    id: backgroundSection
                    width: sectionCellWidth
                    height: sectionCellHeight

                    Image {
                        source: modelData.icon
                        sourceSize.height: sectionIconHeight
                        anchors.margins: 5
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    ParticleSystemStarLoader {
                        id: particles
                        anchors.fill: backgroundSection
                        clip: false
                    }
                    MouseArea {
                        anchors.fill: backgroundSection
                        onClicked: {
                            selectCurrentItem()
                        }
                    }

                    function selectCurrentItem() {
                        section.currentIndex = index
                        activity.currentTag = modelData.tag
                        particles.burst(10)
                        if(modelData.tag === "search") {
                            ActivityInfoTree.filterBySearch(searchTextField.text);
                        }
                        else {
                            ActivityInfoTree.filterByTag(modelData.tag)
                            ActivityInfoTree.filterLockedActivities()
                            ActivityInfoTree.filterEnabledActivities()
                        }
                    }
                }
            }
            delegate: sectionDelegate
            highlight: Item {
                width: sectionCellWidth
                height: sectionCellHeight

                Rectangle {
                    anchors.fill: parent
                    color:  "#5AFFFFFF"
                }
                Image {
                    source: "qrc:/gcompris/src/core/resource/button.svg"
                    anchors.fill: parent
                }
                Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
                Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }
            }
        }

        // Activities
        property int iconWidth: 120 * ApplicationInfo.ratio
        property int iconHeight: 120 * ApplicationInfo.ratio
        property int activityCellWidth:
            horizontal ? background.width / Math.floor(background.width / iconWidth) :
                         (background.width - section.width) / Math.floor((background.width - section.width) / iconWidth)
        property int activityCellHeight: iconHeight * 1.7

        Loader {
            id: warningOverlay
            anchors {
                top: horizontal ? section.bottom : parent.top
                bottom: parent.bottom
                left: horizontal ? parent.left : section.right
                right: parent.right
                margins: 4
            }
            active: (ActivityInfoTree.menuTree.length === 0) && (currentTag === "favorite")
            sourceComponent: Item {
                anchors.fill: parent
                GCText {
                    id: instructionTxt
                    fontSize: smallSize
                    y: height * 0.2
                    x: (parent.width - width) / 2
                    z: 2
                    width: parent.width * 0.6
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    font.weight: Font.DemiBold
                    color: 'white'
                    text: qsTr("Put your favorite activities here by selecting the " +
                               "sun at the top right of that activity.")
                }
                Rectangle {
                    anchors.fill: instructionTxt
                    anchors.margins: -6
                    z: 1
                    opacity: 0.5
                    radius: 10
                    border.width: 2
                    border.color: "black"
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#000" }
                        GradientStop { position: 0.9; color: "#666" }
                        GradientStop { position: 1.0; color: "#AAA" }
                    }
                }
            }
        }

        GridView {
            id: activitiesGrid

            anchors {
                top: {
                    if(activity.currentTag === "search")
                        return searchBar.bottom
                    else
                        return horizontal ? section.bottom : parent.top
                }
                bottom: bar.top
                left: horizontal ? parent.left : section.right
                margins: 4
            }
            width: background.width
            cellWidth: activityCellWidth
            cellHeight: activityCellHeight
            clip: true
            model: ActivityInfoTree.menuTree
            keyNavigationWraps: true
            property int spacing: 10

            delegate: Item {
                id: delegateItem
                width: activityCellWidth - activitiesGrid.spacing
                height: activityCellHeight - activitiesGrid.spacing
                Rectangle {
                    id: activityBackground
                    width: activityCellWidth - activitiesGrid.spacing
                    height: activityCellHeight - activitiesGrid.spacing
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "white"
                    opacity: 0.5
                }
                Image {
                    source: "qrc:/gcompris/src/activities/" + icon;
                    anchors.top: activityBackground.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    sourceSize.height: iconHeight
                    anchors.margins: 5
                    Image {
                        source: "qrc:/gcompris/src/core/resource/difficulty" +
                                ActivityInfoTree.menuTree[index].difficulty + ".svg";
                        anchors.top: parent.top
                        sourceSize.width: iconWidth * 0.15
                        x: 5
                    }
                    Image {
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            top: parent.top
                            rightMargin: 4
                        }
                        source: demo || !ApplicationSettings.isDemoMode
                                ? "" :
                                  activity.url + "lock.svg"
                        sourceSize.width: 30 * ApplicationInfo.ratio
                    }
                    Image {
                        anchors {
                            left: parent.left
                            bottom: parent.bottom
                        }
                        source: ActivityInfoTree.menuTree[index].createdInVersion == ApplicationInfo.GCVersionCode
                                ? activity.url + "new.svg" : ""
                        sourceSize.width: 30 * ApplicationInfo.ratio
                    }
                    GCText {
                        id: title
                        anchors.top: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Text.AlignHCenter
                        width: activityBackground.width
                        fontSizeMode: Text.Fit
                        minimumPointSize: 7
                        fontSize: regularSize
                        elide: Text.ElideRight
                        maximumLineCount: 2
                        wrapMode: Text.WordWrap
                        text: ActivityInfoTree.menuTree[index].title
                    }
                    // If we have enough room at the bottom display the description
                    GCText {
                        id: description
                        visible: delegateItem.height - (title.y + title.height) > description.height ? 1 : 0
                        anchors.top: title.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Text.AlignHCenter
                        width: activityBackground.width
                        fontSizeMode: Text.Fit
                        minimumPointSize: 7
                        fontSize: regularSize
                        elide: Text.ElideRight
                        maximumLineCount: 3
                        wrapMode: Text.WordWrap
                        text: ActivityInfoTree.menuTree[index].description
                    }
                }
                ParticleSystemStarLoader {
                    id: particles
                    anchors.fill: activityBackground
                }
                MouseArea {
                    anchors.fill: activityBackground
                    onClicked: selectCurrentItem()
                }
                Image {
                    source: activity.url + (favorite ? "all.svg" : "all_disabled.svg");
                    anchors {
                        top: parent.top
                        right: parent.right
                        rightMargin: 4 * ApplicationInfo.ratio
                    }
                    sourceSize.width: iconWidth * 0.25
                    visible: ApplicationSettings.sectionVisible
                    MouseArea {
                        anchors.fill: parent
                        onClicked: favorite = !favorite
                    }
                }

                function selectCurrentItem() {
                    if(pageView.busy)
                        return
                    particles.burst(50)
                    ActivityInfoTree.currentActivity = ActivityInfoTree.menuTree[index]
                    activityLoader.setSource("qrc:/gcompris/src/activities/" + ActivityInfoTree.menuTree[index].name,
                                             {
                                                 'menu': activity,
                                                 'activityInfo': ActivityInfoTree.currentActivity
                                             })
                    if (activityLoader.status == Loader.Ready) loadActivity()
                }
            }
            highlight: Rectangle {
                width: activityCellWidth - activitiesGrid.spacing
                height: activityCellHeight - activitiesGrid.spacing
                color:  "#AAFFFFFF"
                border.width: 3
                border.color: "black"
                visible: background.keyboardMode
                Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
                Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }
            }

            Rectangle {
                id: activitiesMask
                visible: false
                anchors.fill: activitiesGrid
                gradient: Gradient {
                  GradientStop { position: 0.0; color: "#FFFFFFFF" }
                  GradientStop { position: 0.92; color: "#FFFFFFFF" }
                  GradientStop { position: 0.96; color: "#00FFFFFF"}
                }
            }
            layer.enabled: ApplicationInfo.useOpenGL
            layer.effect: OpacityMask {
                id: activitiesOpacity
                source: activitiesGrid
                maskSource: activitiesMask
                anchors.fill: activitiesGrid
            }
        }
        
        // The scroll buttons
        GCButtonScroll {
            visible: !ApplicationInfo.useOpenGL
            anchors.right: parent.right
            anchors.rightMargin: 5 * ApplicationInfo.ratio
            anchors.bottom: activitiesGrid.bottom
            anchors.bottomMargin: 30 * ApplicationInfo.ratio
            onUp: activitiesGrid.flick(0, 1127)
            onDown: activitiesGrid.flick(0, -1127)
            upVisible: activitiesGrid.visibleArea.yPosition <= 0 ? false : true
            downVisible: activitiesGrid.visibleArea.yPosition >= 1 ? false : true
        }
        
        Rectangle {
            id: searchBar
            width: horizontal ?  parent.width/2 : parent.width - (section.width+10)
            height: searchTextField.height
            visible: activity.currentTag === "search"
            anchors {
                top: horizontal ? section.bottom : parent.top
                left: horizontal ? undefined : section.right
            }
            anchors.topMargin: horizontal ? 0 : 4
            anchors.bottomMargin: horizontal ? 0 : 4
            anchors.horizontalCenter: horizontal ? parent.horizontalCenter : undefined
            opacity: 0.5
            radius: 10
            border.width: 2
            border.color: "black"
            gradient: Gradient {
                GradientStop { position: 0.3; color: "#000" }
                GradientStop { position: 0.9; color: "#666" }
                GradientStop { position: 1.0; color: "#AAA" }
            }

            Connections {
                // On mobile with GCompris' virtual keyboard activated:
                // Force invisibility of Androids virtual keyboard:
                target: (ApplicationInfo.isMobile && activity.currentTag === "search"
                         && ApplicationSettings.isVirtualKeyboard) ? Qt.inputMethod : null
                onVisibleChanged: {
                    if (ApplicationSettings.isVirtualKeyboard && visible)
                        Qt.inputMethod.hide();
                }
                onAnimatingChanged: {
                    // note: seems to be never fired!
                    if (ApplicationSettings.isVirtualKeyboard && Qt.inputMethod.visible)
                        Qt.inputMethod.hide();
                }
            }

            Connections {
                target: activity
                onCurrentTagChanged: {
                    if (activity.currentTag === 'search') {
                        searchTextField.focus = true;
                    } else
                        activity.focus = true;
                }
            }

            TextField {
                id: searchTextField
                width: parent.width
                textColor: "black"
                font.pointSize: 16
                font.bold: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                font.family: GCSingletonFontLoader.fontLoader.name
                inputMethodHints: Qt.ImhNoPredictiveText
                // Note: we give focus to the textfield also in case
                // isMobile && !ApplicationSettings.isVirtualKeyboard
                // in conjunction with auto-hiding the inputMethod to always get
                // an input-cursor:
                activeFocusOnPress: true //ApplicationInfo.isMobile ? !ApplicationSettings.isVirtualKeyboard : true

                Keys.onReturnPressed: {
                    if (ApplicationInfo.isMobile && !ApplicationSettings.isVirtualKeyboard)
                        Qt.inputMethod.hide();
                    activity.focus = true;
                }

                onEditingFinished: {
                    if (ApplicationInfo.isMobile && !ApplicationSettings.isVirtualKeyboard)
                        Qt.inputMethod.hide();
                    activity.focus = true;
                }

                style: TextFieldStyle {
                    placeholderTextColor: "black"
                }

                placeholderText: qsTr("Search specific activities")
                onTextChanged: ActivityInfoTree.filterBySearch(searchTextField.text);
            }
        }

        VirtualKeyboard {
            id: keyboard
            readonly property var letter: ActivityInfoTree.characters
            width: parent.width
            visible: activity.currentTag === "search" && ApplicationSettings.isVirtualKeyboard
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            onKeypress: {
                if(text == keyboard.backspace) {
                    searchTextField.text = searchTextField.text.slice(0, -1);
                }
                else if(text == keyboard.space) {
                    searchTextField.text = searchTextField.text.concat(" ");
                }
                else {
                    searchTextField.text = searchTextField.text.concat(text);
                }
            }
            function populate() {
               var tmplayout = [];
               var row = 0;
               var offset = 0;
               var cols;
               while(offset < letter.length-1) {
                   if(letter.length <= 100) {
                       cols = Math.ceil((letter.length-offset) / (3 - row));
                   }
                   else {
                       cols = background.horizontal ? (Math.ceil((letter.length-offset) / (15 - row)))
                                                       :(Math.ceil((letter.length-offset) / (22 - row)))
                       if(row == 0) {
                           tmplayout[row] = new Array();
                           tmplayout[row].push({ label: keyboard.backspace });
                           tmplayout[row].push({ label: keyboard.space });
                           row ++;
                       }
                   }

                   tmplayout[row] = new Array();
                   for (var j = 0; j < cols; j++)
                       tmplayout[row][j] = { label: letter[j+offset] };
                   offset += j;
                   row ++;
               }
               if(letter.length <= 100) {
                   tmplayout[0].push({ label: keyboard.space });
                   tmplayout[row-1].push({ label: keyboard.backspace });
               }
               keyboard.layout = tmplayout
           }
        }

        Bar {
            id: bar
            // No exit button on mobile, UI Guidelines prohibits it
            content: BarEnumContent {
                value: help | config | about | (ApplicationInfo.isMobile ? 0 : exit)
            }
            anchors.bottom: keyboard.visible ? keyboard.top : parent.bottom
            onAboutClicked: {
                searchTextField.focus = false
                displayDialog(dialogAbout)
            }

            onHelpClicked: {
                searchTextField.focus = false
                displayDialog(dialogHelp)
            }

            onConfigClicked: {
                searchTextField.focus = false
                dialogActivityConfig.active = true
                dialogActivityConfig.loader.item.loadFromConfig()
                displayDialog(dialogActivityConfig)
            }
        }
                
        DialogAbout {
            id: dialogAbout
            onClose: home()
            }
        DialogHelp {
            id: dialogHelp
            onClose: home()
            activityInfo: ActivityInfoTree.rootMenu
        }

        DialogActivityConfig {
            id: dialogActivityConfig
            currentActivity: activity

            content: Component {
                ConfigurationItem {
                    id: configItem
                    width: dialogActivityConfig.width - 50 * ApplicationInfo.ratio
                }
            }

            onSaveData: {
                dialogActivityConfig.configItem.save();
            }
            onClose: {
                if(activity.currentTag != "search") {
                    ActivityInfoTree.filterByTag(activity.currentTag)
                    ActivityInfoTree.filterLockedActivities()
                    ActivityInfoTree.filterEnabledActivities()
                } else
                    ActivityInfoTree.filterBySearch(searchTextField.text);
                home()
            }
        }
    }
}
