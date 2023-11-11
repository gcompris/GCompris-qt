/* GCompris - Menu.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "../../core"
import GCompris 1.0
import QtGraphicalEffects 1.0
import "qrc:/gcompris/src/core/core.js" as Core

// For TextField
import QtQuick.Controls 2.12

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
    isMenu: true
    onBack: {
        if (pageView.currentItem === activity) {
            // Restore focus that has been taken by the loaded activity
            focus = true
        } else {
            pageView.pop(to)
        }

    }

    onHome: {
        if(pageView.depth === 1 && !ApplicationSettings.isKioskMode) {
            Core.quit(activity);
        }
        else {
            pageView.popElement();
            // Restore focus that has been taken by the loaded activity
            if(pageView.currentItem === activity) {
                focus = true;
                if(ActivityInfoTree.startingActivity != "") {
                    Core.quit(activity);
                }
            }
        }
    }

    enabled: ActivityInfoTree.startingActivity === ""

    onDisplayDialog: pageView.pushElement(dialog)

    onDisplayDialogs: {
        for (var i = 0; i < dialogs.length; i++) {
            pageView.pushElement(dialogs[i]);
        }
    }

    //when selecting a new language in config, we need to open the newVoicesDialog,
    //but only after the config page is closed, hence the need to have a signal calling a Timer calling the function
    signal newVoicesSignal
    onNewVoicesSignal: newVoicesDialogTimer.restart();

    Timer {
        id: newVoicesDialogTimer
        interval: 250
        onTriggered: newVoicesDialog();
    }
    function newVoicesDialog() {
        Core.showMessageDialog(activity,
                qsTr("You selected a new locale, you need to restart GCompris to use it.<br/>Do you want to download the corresponding sound files now?"),
                qsTr("Yes"), function() {
                    // yes -> start download
                    if (DownloadManager.downloadResource(
                            GCompris.VOICES,
                           {"locale": ApplicationInfo.getVoicesLocale(ApplicationSettings.locale)}))
                    var downloadDialog = Core.showDownloadDialog(pageView.currentItem, {});
                },
                qsTr("No"), null,
                null
                );
    }

    Connections {
        // At the launch of the application, box2d check is performed after we
        // first initialize the menu. This connection is to refresh
        // automatically the menu at start.
        target: ApplicationInfo
        onIsBox2DInstalledChanged: {
            ActivityInfoTree.filterByTag(activity.currentTag, currentCategory)
            ActivityInfoTree.filterEnabledActivities()
        }
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
            tag: "discovery",
            categories: [{ "logic": qsTr("Logic") },
                         { "arts": qsTr("Fine Arts") },
                         { "music": qsTr("Music") }
            ]
        },
        {
            icon: activity.url + "sciences.svg",
            tag: "sciences",
            categories: [{ "experiment": qsTr("Experiment") },
                         { "history": qsTr("History") },
                         { "geography": qsTr("Geography") }
            ]
        },
        {
            icon: activity.url + "fun.svg",
            tag: "fun"
        },
        {
            icon: activity.url + "math.svg",
            tag: "math",
            categories: [{ "numeration": qsTr("Numeration") },
                         { "arithmetic": qsTr("Arithmetic") },
                         { "measures": qsTr("Measures") }
                        ]
        },
        {
            icon: activity.url + "puzzle.svg",
            tag: "puzzle"
        },
        {
            icon: activity.url + "reading.svg",
            tag: "reading",
            categories: [{ "letters": qsTr("Letters") },
                         { "words": qsTr("Words") },
                         { "vocabulary": qsTr("Vocabulary") }
                        ]
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
    property var currentTagCategories: []
    property string currentCategory: ""
    /// @endcond

    property string clickMode: "play"

    signal startActivity(string activityName, int level)

    pageComponent: Image {
        id: background
        source: activity.url + "background.svg"
        sourceSize.width: width
        sourceSize.height: height
        height: main.height
        fillMode: Image.PreserveAspectCrop

        function loadActivity() {
            // @TODO init of item would be better in setsource but it crashes on Qt5.6
            // https://bugreports.qt.io/browse/QTBUG-49793
            activityLoader.item.audioVoices = audioVoices
            activityLoader.item.audioEffects = audioEffects
            activityLoader.item.loading = loading

            //take the focus away from textField before starting an activity
            searchTextField.focus = false

            pageView.pushElement(activityLoader.item)
            ActivityInfoTree.startingLevel = -1
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
                } else if (status == Loader.Error) {
                    loading.stop();
                }
            }
        }

        // Filters
        property bool horizontal: main.width >= main.height
        property int sectionIconWidth: Math.min(100 * ApplicationInfo.ratio, main.width / (sections.length + 1))
        property int sectionCellWidth: sectionIconWidth * 1.1
        property int categoriesHeight: currentCategory == "" ? 0 : sectionCellWidth - 2

        property var currentActiveGrid: activitiesGrid
        property bool keyboardMode: false
        Keys.onPressed: {
            if(loading.active) {
                return;
            }
            // Ctrl-modifiers should never be handled by the search-field
            if (event.modifiers === Qt.ControlModifier) {
                if (event.key === Qt.Key_S) {
                    // Ctrl+S toggle show / hide section
                    ApplicationSettings.sectionVisible = !ApplicationSettings.sectionVisible
                }
            } else if(currentTag === "search") {
                // forward to the virtual keyboard the pressed keys
                if(event.key === Qt.Key_Backspace)
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
        Keys.onTabPressed: {
            if(currentActiveGrid == section) {
                if(currentTagCategories && currentTagCategories.length != 0) {
                    currentActiveGrid = categoriesGrid;
                }
                else {
                    currentActiveGrid = activitiesGrid;
                }
            }
            else if(currentActiveGrid == categoriesGrid) {
                currentActiveGrid = activitiesGrid;
            }
            else {
                currentActiveGrid = section;
            }
        }
        Keys.onEnterPressed: if(currentActiveGrid.currentItem && !loading.active) currentActiveGrid.currentItem.selectCurrentItem();
        Keys.onReturnPressed: if(currentActiveGrid.currentItem && !loading.active) currentActiveGrid.currentItem.selectCurrentItem();
        Keys.onRightPressed: if(currentActiveGrid.currentItem && !loading.active) currentActiveGrid.moveCurrentIndexRight();
        Keys.onLeftPressed: if(currentActiveGrid.currentItem && !loading.active) currentActiveGrid.moveCurrentIndexLeft();
        Keys.onDownPressed: if(currentActiveGrid.currentItem && !loading.active) currentActiveGrid.moveCurrentIndexDown();
        Keys.onUpPressed: if(currentActiveGrid.currentItem && !loading.active) currentActiveGrid.moveCurrentIndexUp();

        GridView {
            id: section
            model: sections
            x: ApplicationSettings.sectionVisible ? section.initialX : -sectionCellWidth
            y: ApplicationSettings.sectionVisible ? section.initialY : -sectionCellWidth
            visible: ApplicationSettings.sectionVisible
            cellWidth: sectionCellWidth
            cellHeight: sectionCellWidth
            interactive: false
            keyNavigationWraps: true
            property int initialX: 4
            property int initialY: 4

            Component {
                id: sectionDelegate
                Item {
                    id: backgroundSection
                    width: sectionCellWidth
                    height: sectionCellWidth

                    Image {
                        source: modelData.icon
                        sourceSize.height: sectionIconWidth
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
                        activity.currentTagCategories = modelData.categories
                        if(modelData.categories !== undefined) {
                            currentCategory = Object.keys(modelData.categories[0])[0];
                        }
                        else {
                            currentCategory = ""
                        }
                        particles.burst(10)
                        if(modelData.tag === "search") {
                            ActivityInfoTree.filterBySearch(searchTextField.text);
                        }
                        else {
                            ActivityInfoTree.filterByTag(modelData.tag, currentCategory)
                            ActivityInfoTree.filterEnabledActivities()
                        }
                    }
                }
            }
            delegate: sectionDelegate
            highlight: Item {
                width: sectionCellWidth
                height: sectionCellWidth

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
        property int activityCellWidth:  activitiesGrid.width / Math.floor(activitiesGrid.width / iconWidth)
        property int activityCellHeight: iconWidth * 1.7

        Loader {
            id: warningOverlay
            anchors {
                bottom: parent.bottom
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
                    text: qsTr("Put your favorite activities here by clicking on the " +
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
            id: categoriesGrid
            model: currentTagCategories
            topMargin: 5
            interactive: false
            keyNavigationWraps: true
            visible: activity.currentTag !== "search"
            cellWidth: currentTagCategories ? categoriesGrid.width / currentTagCategories.length : 0
            cellHeight: height

            delegate: GCButton {
                id: button
                selected: currentCategory === button.category
                theme: "categories"
                textSize: "regular"
                rightIconSize: rightIcon.width + rightIcon.anchors.rightMargin
                width: categoriesGrid.width / (currentTagCategories.length + 1)
                height: categoriesGrid.cellHeight
                text: modelData[category]
                property string category: Object.keys(modelData)[0]
                onClicked: {
                    selectCurrentItem()
                }

                function selectCurrentItem() {
                    categoriesGrid.currentIndex = index
                    currentCategory = Object.keys(modelData)[0]
                    ActivityInfoTree.filterByTag(currentTag, currentCategory)
                    ActivityInfoTree.filterEnabledActivities()
                }
                Image {
                    id: rightIcon
                    visible: horizontal
                    source: "qrc:/gcompris/src/activities/menu/resource/category-" + button.category + ".svg";
                    height: visible ? Math.round(parent.height * 0.8) : 0
                    sourceSize.height: height
                    width: height
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: visible ? parent.height * 0.1 : 0
                    }
                }
            }
            highlight: Rectangle {
                z: 10
                width: activityCellWidth - activitiesGrid.spacing
                height: activityCellHeight - activitiesGrid.spacing
                color:  "#00FFFFFF"
                radius: 10
                border.width: 5
                border.color: "#FF87A6DD"
                visible: true
                Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
                Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }
            }
        }

        GridView {
            id: activitiesGrid
            anchors {
                top: {
                    if(searchBar.visible)
                        return searchBar.bottom
                    else
                        return categoriesGrid.bottom
                }
                bottom: bar.top
                margins: 4
                topMargin: currentCategory == "" ? 4 : 10
            }
            width: background.width
            cellWidth: activityCellWidth
            cellHeight: activityCellHeight
            clip: true
            model: ActivityInfoTree.menuTree
            keyNavigationWraps: true
            property int spacing: 10
            // Needed to calculate the OpacityMask offset
            // If not using OpenGL, this value is not used, so we save the calculation and set it to 1
            property real hiddenBottom: ApplicationInfo.useOpenGL ? contentHeight - height - contentY : 1

            delegate: Item {
                id: delegateItem
                width: activityCellWidth - activitiesGrid.spacing
                height: activityCellHeight - activitiesGrid.spacing
                enabled: clickMode === "play" || (activityInfoTreeItem.hasConfig || activityInfoTreeItem.hasDataset)
                property var activityInfoTreeItem: ActivityInfoTree.menuTree[index]
                Rectangle {
                    id: activityBackground
                    width: parent.width
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "white"
                    opacity: 0.5
                }
                Image {
                    id: activityIcon
                    source: "qrc:/gcompris/src/activities/" + icon
                    anchors.top: activityBackground.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: iconWidth - activitiesGrid.spacing
                    height: width
                    sourceSize.width: width
                    fillMode: Image.PreserveAspectFit
                    anchors.margins: 5
                    opacity: delegateItem.enabled ? 1 : 0.5

                    Image {
                        id: minimalDifficultyIcon
                        source: "qrc:/gcompris/src/core/resource/difficulty" +
                                activityInfoTreeItem.minimalDifficulty + ".svg"
                        anchors.top: parent.top
                        sourceSize.width: iconWidth * 0.15
                    }
                    Image {
                        id: iconSeparator
                        source: "qrc:/gcompris/src/core/resource/separator.svg"
                        visible: activityInfoTreeItem.minimalDifficulty !== activityInfoTreeItem.maximalDifficulty
                        anchors.top: parent.top
                        anchors.left: minimalDifficultyIcon.right
                        sourceSize.height: minimalDifficultyIcon.height
                    }
                    Image {
                        source: "qrc:/gcompris/src/core/resource/difficulty" +
                                activityInfoTreeItem.maximalDifficulty + ".svg"
                        visible: iconSeparator.visible
                        anchors.top: parent.top
                        anchors.left: iconSeparator.right
                        sourceSize.width: minimalDifficultyIcon.width
                    }
                    Image {
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            top: parent.top
                        }
                        source: activityInfoTreeItem.createdInVersion > lastGCVersionRanCopy
                                ? activity.url + "new.svg" : ""
                        sourceSize.width: 25 * ApplicationInfo.ratio
                    }
                    GCText {
                        id: title
                        anchors.top: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Text.AlignHCenter
                        width: activityBackground.width
                        height: activityBackground.height - activityIcon.height
                        fontSizeMode: Text.Fit
                        minimumPointSize: 10
                        fontSize: regularSize
                        elide: Text.ElideRight
                        wrapMode: Text.WordWrap
                        text: activityInfoTreeItem.title
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

                Loader {
                    id: chooseLevelLoader
                    active: false
                    onStatusChanged: {
                        if (status == Loader.Ready) {
                            displayDialog(item);
                        }
                    }

                    sourceComponent: DialogChooseLevel {
                        id: dialogChooseLevel
                        displayDatasetAtStart: hasDataset
                        currentActivity: activityInfoTreeItem
                        inMenu: true

                        onClose: {
                            home()
                        }
                        onSaveData: {
                            currentLevels = dialogChooseLevel.chosenLevels
                            ApplicationSettings.setCurrentLevels(name, currentLevels)
                        }
                        onStartActivity: {
                            clickMode = "play"
                            // immediately pop the Dialog to load the activity
                            // if we don't do it immediately the page is busy
                            // and it does not load the activity
                            pageView.pop(StackView.Immediate)
                            selectCurrentItem()
                        }
                    }
                }

                function selectCurrentItem() {
                    if(pageView.busy || !delegateItem.enabled)
                        return

                    if(clickMode === "play") {
                        particles.burst(50)
                        ActivityInfoTree.currentActivity = activityInfoTreeItem
                        activityLoader.setSource("qrc:/gcompris/src/activities/" + ActivityInfoTree.currentActivity.name,
                        {
                            'menu': activity,
                            'activityInfo': ActivityInfoTree.currentActivity,
                            'levelFolder': currentLevels
                        })
                        if (activityLoader.status == Loader.Ready) loadActivity()
                    }
                    else {
                        // Display configuration
                        chooseLevelLoader.active = false;
                        chooseLevelLoader.active = true;
                    }
                    activitiesGrid.currentIndex = index
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
                // Dynamic position of the gradient used for OpacityMask
                // If the hidden bottom part of the grid is > to the maximum height of the gradient,
                // we use the maximum height.
                // Else we set the gradient start position proportionnally to the hidden bottom part,
                // until it disappears.
                // And if not using OpenGL, the mask is disabled, so we save the calculation and set it to 1
                property real gradientStartValue:
                    ApplicationInfo.useOpenGL ?
                    (activitiesGrid.hiddenBottom > activitiesGrid.height * 0.08 ?
                        0.92 : 1 - (activitiesGrid.hiddenBottom / activitiesGrid.height)) :
                        1
                gradient: Gradient {
                  GradientStop { position: 0.0; color: "#FFFFFFFF" }
                  GradientStop { position: activitiesMask.gradientStartValue; color: "#FFFFFFFF" }
                  GradientStop { position: activitiesMask.gradientStartValue + 0.04; color: "#00FFFFFF"}
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
            upVisible: activitiesGrid.atYBeginning ? false : true
            downVisible: activitiesGrid.atYEnd ? false : true
        }

        Rectangle {
            id: categories
            height: searchTextField.height
            visible: sections[activity.currentTag] === "search"
        }

        Rectangle {
            id: searchBar
            visible: activity.currentTag === "search"
            radius: 5 * ApplicationInfo.ratio
            border.width: 2
            border.color: "#80000000"
            gradient: Gradient {
                GradientStop { position: 0.3; color: "#A0CCCCCC" }
                GradientStop { position: 0.9; color: "#A0EEEEEE" }
                GradientStop { position: 1; color: "#A0FFFFFF" }
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
                        if(ApplicationSettings.isVirtualKeyboard && !keyboard.isPopulated) {
                            keyboard.populate();
                            keyboard.isPopulated = true;
                        }
                        searchTextField.focus = true;
                    } else
                        activity.focus = true;
                }

                onStartActivity: {
                    ActivityInfoTree.setCurrentActivityFromName(activityName)
                    var currentLevels = ApplicationSettings.currentLevels(ActivityInfoTree.currentActivity.name)
                    activityLoader.setSource("qrc:/gcompris/src/activities/" + ActivityInfoTree.currentActivity.name,
                    {
                        'menu': activity,
                        'activityInfo': ActivityInfoTree.currentActivity,
                        'levelFolder': currentLevels
                    })
                    if (activityLoader.status == Loader.Ready) loadActivity()
                }
            }

            TextField {
                id: searchTextField
                width: parent.width
                height: parent.height
                color: "black"
                font.pixelSize: height * 0.5
                font.bold: true
                opacity: 0.5
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                font.family: GCSingletonFontLoader.fontLoader.name
                inputMethodHints: Qt.ImhNoPredictiveText
                // Note: we give focus to the textfield also in case
                // isMobile && !ApplicationSettings.isVirtualKeyboard
                // in conjunction with auto-hiding the inputMethod to always get
                // an input-cursor:
                activeFocusOnPress: true //ApplicationInfo.isMobile ? !ApplicationSettings.isVirtualKeyboard : true

                background: Rectangle {
                    opacity: 0
                }

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

                placeholderText: qsTr("Search specific activities")
                onTextChanged: searchTimer.restart();
            }
        }

        //timer to workaround some weird Type errors when typing too fast in the search field
        Timer {
            id: searchTimer
            interval: 500
            onTriggered: ActivityInfoTree.filterBySearch(searchTextField.text);
        }

        Rectangle {
            id: activityConfigTextBar
            height: activitySettingsLabel.height
            visible: clickMode === "activityConfig"
            anchors {
                bottom: bar.top
                bottomMargin: height * 0.3
            }
            radius: 10
            border.width: height * 0.05
            border.color: "#8b66b2"
            color: "#eeeeee"

            GCText {
                id: activitySettingsLabel
                text: qsTr("Activity Settings")
                fontSizeMode: Text.Fit
                visible: parent.visible
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignHCenter
                color: "#232323"
            }
        }

        states: [
            State {
                name: "horizontalState"; when: horizontal === true
                PropertyChanges {
                    target: background
                    sectionIconWidth: Math.min(100 * ApplicationInfo.ratio, main.width / (sections.length + 1))
                }
                PropertyChanges {
                    target: section
                    width: main.width
                    height: sectionCellWidth
                }
                PropertyChanges {
                    target: categoriesGrid
                    width: main.width
                    height: categoriesHeight * 0.5
                    x: currentTagCategories ? categoriesGrid.width / (4 * (currentTagCategories.length + 1)) : 0
                }
                PropertyChanges {
                    target: activitiesGrid
                    width: background.width
                }
                PropertyChanges {
                    target: categories
                    width: background.width
                }
                PropertyChanges {
                    target: searchBar
                    width: background.width * 0.5
                    height: sectionCellWidth * 0.5
                    anchors.topMargin: 0
                    anchors.bottomMargin: 0
                }
                PropertyChanges {
                    target: activityConfigTextBar
                    width: background.width * 0.5
                }
                AnchorChanges {
                    target: warningOverlay
                    anchors.top: section.bottom
                    anchors.left: background.left
                }
                AnchorChanges {
                    target: categoriesGrid
                    anchors.top: section.bottom
                }
                AnchorChanges {
                    target: activitiesGrid
                    anchors.left: background.left
                }
                AnchorChanges {
                    target: categories
                    anchors.top: section.bottom
                    anchors.left: undefined
                }
                AnchorChanges {
                    target: searchBar
                    anchors.top: section.bottom
                    anchors.left: undefined
                    anchors.horizontalCenter: background.horizontalCenter
                }
                AnchorChanges {
                    target: activityConfigTextBar
                    anchors.left: undefined
                    anchors.horizontalCenter: background.horizontalCenter
                }
            },
            State {
                name: "verticalState"; when: horizontal === false
                PropertyChanges {
                    target: background
                    sectionIconWidth: Math.min(100 * ApplicationInfo.ratio, (background.height - bar.height) / (sections.length + 1))
                }
                PropertyChanges {
                    target: section
                    width: sectionCellWidth
                    height: main.height - bar.height
                }
                PropertyChanges {
                    target: categoriesGrid
                    width: main.width - section.width
                    height: categoriesHeight
                    x: currentTagCategories ? categoriesGrid.width / (4 * (currentTagCategories.length + 1)) + section.width : 0
                }
                PropertyChanges {
                    target: activitiesGrid
                    width: background.width - sectionCellWidth
                }
                PropertyChanges {
                    target: categories
                    width: background.width - (section.width + 10)
                }
                PropertyChanges {
                    target: searchBar
                    width: background.width - (section.width + 10)
                    height: sectionCellWidth
                    anchors.topMargin: 4
                    anchors.bottomMargin: 4
                }
                PropertyChanges {
                    target: activityConfigTextBar
                    width: background.width - (section.width + 10)
                }
                AnchorChanges {
                    target: warningOverlay
                    anchors.top: background.top
                    anchors.left: section.right
                }
                AnchorChanges {
                    target: categoriesGrid
                    anchors.top: background.top
                }
                AnchorChanges {
                    target: activitiesGrid
                    anchors.left: section.right
                }
                AnchorChanges {
                    target: categories
                    anchors.top: categoriesGrid.top
                    anchors.left: section.right
                }
                AnchorChanges {
                    target: searchBar
                    anchors.top: background.top
                    anchors.left: section.right
                    anchors.horizontalCenter: undefined
                }
                AnchorChanges {
                    target: activityConfigTextBar
                    anchors.left: section.right
                    anchors.horizontalCenter: undefined
                }
            },
            State {
                name: "verticalWithSearch"; when: horizontal === false && activity.currentTag === "search" && ApplicationSettings.isVirtualKeyboard
                PropertyChanges {
                    target: background
                    sectionIconWidth: Math.min(100 * ApplicationInfo.ratio, (background.height - (bar.height+keyboard.height)) / (sections.length + 1))
                }
                PropertyChanges {
                    target: section
                    width: main.width
                    height: sectionCellWidth (sections.length + 1)
                }
                PropertyChanges {
                    target: categoriesGrid
                    width: main.width - section.width
                    height: categoriesHeight
                    x: currentTagCategories ? categoriesGrid.width / (4 * (currentTagCategories.length + 1)) + section.width : 0
                }
                PropertyChanges {
                    target: activitiesGrid
                    width: background.width - sectionCellWidth
                }
                PropertyChanges {
                    target: categories
                    width: background.width - (section.width + 10)
                }
                PropertyChanges {
                    target: searchBar
                    width: background.width - (section.width + 10)
                    height: sectionCellWidth
                    anchors.topMargin: 4
                    anchors.bottomMargin: 4
                }
                PropertyChanges {
                    target: activityConfigTextBar
                    width: background.width - (section.width + 10)
                }
                AnchorChanges {
                    target: warningOverlay
                    anchors.top: background.top
                    anchors.left: section.right
                }
                AnchorChanges {
                    target: categoriesGrid
                    anchors.top: background.top
                }
                AnchorChanges {
                    target: activitiesGrid
                    anchors.left: section.right
                }
                AnchorChanges {
                    target: categories
                    anchors.top: categoriesGrid.top
                    anchors.left: section.right
                }
                AnchorChanges {
                    target: searchBar
                    anchors.top: background.top
                    anchors.left: section.right
                    anchors.horizontalCenter: undefined
                }
            }
        ]

        VirtualKeyboard {
            id: keyboard
            property bool isPopulated: false
            readonly property var letter: ActivityInfoTree.characters
            width: parent.width
            visible: activity.currentTag === "search" && ApplicationSettings.isVirtualKeyboard
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            onKeypress: {
                var textArray = searchTextField.text.split("");
                var cursorPosition = searchTextField.cursorPosition
                if(text == keyboard.backspace) {
                    --cursorPosition;
                    textArray.splice(cursorPosition, 1);
                }
                else if(text == keyboard.space) {
                    textArray.splice(cursorPosition, 0, " ");
                    ++cursorPosition;
                }
                else {
                    textArray.splice(cursorPosition, 0, text);
                    ++cursorPosition;
                }
                searchTextField.text = textArray.join("");
                searchTextField.cursorPosition = cursorPosition;
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
                       if(row === 0) {
                           tmplayout[row] = [];
                           tmplayout[row].push({ label: keyboard.backspace });
                           tmplayout[row].push({ label: keyboard.space });
                           row ++;
                       }
                   }

                   tmplayout[row] = [];
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
                value: help | config | activityConfig | about | (ApplicationInfo.isMobile ? 0 : exit)
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

            onActivityConfigClicked: {
                if(clickMode == "play") {
                    clickMode = "activityConfig"
                }
                else {
                    clickMode = "play"
                }
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
                    parentActivity: activity
                    width: dialogActivityConfig.width - 50 * ApplicationInfo.ratio
                }
            }

            onSaveData: {
                dialogActivityConfig.configItem.save()
            }
            onClose: {
                if(activity.currentTag != "search") {
                    ActivityInfoTree.filterByTag(activity.currentTag, currentCategory)
                    ActivityInfoTree.filterEnabledActivities()
                } else
                    ActivityInfoTree.filterBySearch(searchTextField.text);

                var filteredBackgroundMusic = dialogActivityConfig.configItem.filteredBackgroundMusic
                backgroundMusic.clearQueue()
                var allBackgroundMusic = dialogActivityConfig.configItem.allBackgroundMusic
                /**
                 * 1. If the current playing background music is in new filtered playlist too, continue playing it and append all the next filtered musics to backgroundMusic element.
                 * 2. Else, stop the current music, find the filtered music which comes just after it, and append all the further musics after it.
                 */
                var backgroundMusicSource = String(backgroundMusic.source)
                var backgroundMusicName = dialogActivityConfig.configItem.extractMusicNameFromPath(backgroundMusicSource) + backgroundMusicSource.slice(backgroundMusicSource.lastIndexOf('.'), backgroundMusicSource.length)
                var nextMusicIndex = filteredBackgroundMusic.indexOf(backgroundMusicName)
                if(nextMusicIndex !== -1) {
                    nextMusicIndex++
                    while(nextMusicIndex < filteredBackgroundMusic.length)
                        backgroundMusic.append(ApplicationInfo.getAudioFilePath("backgroundMusic/" + filteredBackgroundMusic[nextMusicIndex++]))
                }
                else {
                    nextMusicIndex = allBackgroundMusic.indexOf(backgroundMusicName) + 1
                    while(nextMusicIndex < allBackgroundMusic.length) {
                        if(filteredBackgroundMusic.indexOf(allBackgroundMusic[nextMusicIndex]) !== -1) {
                            nextMusicIndex = filteredBackgroundMusic.indexOf(allBackgroundMusic[nextMusicIndex])
                            break
                        }
                        nextMusicIndex++
                    }

                    while(nextMusicIndex < filteredBackgroundMusic.length)
                        backgroundMusic.append(ApplicationInfo.getAudioFilePath("backgroundMusic/" + filteredBackgroundMusic[nextMusicIndex++]))
                    backgroundMusic.nextAudio()
                }
                home()
            }

            BackgroundMusicList {
                id: backgroundMusicList
                onClose: {
                    visible = false
                    dialogActivityConfig.configItem.visible = true
                }
            }
        }
    }
    // splash screen when using --launch <activity> option
    Rectangle {
        visible: ActivityInfoTree.startingActivity != ""
        anchors.fill: parent
        color: "#16B8EA"
        Image {
            source: "qrc:/gcompris/src/core/resource/gcompris-logo-full.svg"
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 20 * ApplicationInfo.ratio
            width: parent.width * 0.3
            sourceSize.width: width
            fillMode: Image.PreserveAspectFit
        }
    }
}
