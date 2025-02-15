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
import core 1.0
import QtQuick.Effects
import "qrc:/gcompris/src/core/core.js" as Core

// For TextField
import QtQuick.Controls.Basic

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
    onBack: (to) => {
        if (pageView.currentItem === activity) {
            // Restore focus that has been taken by the loaded activity
            focus = true
        } else {
            pageView.pop(to)
        }

    }

    onHome: {
        if(pageView.depth === 1 && ApplicationSettings.isKioskMode) {
            return;
        }
        else if(pageView.depth === 1) {
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

    onDisplayDialog: (dialog) => pageView.pushElement(dialog)

    onDisplayDialogs: (dialogs) => {
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
                qsTr("You selected a new locale, do you want to download the corresponding sound files now?"),
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

    // @cond INTERNAL_DOCS
    property string url: "qrc:/gcompris/src/activities/menu/resource/"
    readonly property var sections: [
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
        id: activityBackground
        source: activity.url + "background.svg"
        sourceSize.width: width
        sourceSize.height: height
        height: main.height
        width: main.width
        fillMode: Image.PreserveAspectCrop

        function loadActivity() {
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
        property bool horizontal: activityBackground.width >= activityBackground.height
        property int sectionIconWidth: sectionCellWidth * 0.9
        // sectionCellWidth value is defined in states
        property real sectionCellWidth: 1
        property real categoriesHeight: Math.max(45 * ApplicationInfo.ratio, sectionCellWidth * 0.5)

        property var currentActiveGrid: activitiesGrid
        property bool keyboardMode: false
        Keys.onPressed: (event) => {
            if(loading.active) {
                return;
            }
            // Ctrl-modifiers should never be handled by the search-field
            if (event.modifiers === Qt.ControlModifier) {
                if (event.key === Qt.Key_S) {
                    // Ctrl+S toggle show / hide section
                    ApplicationSettings.sectionVisible = !ApplicationSettings.sectionVisible
                }
            } else if(activity.currentTag === "search") {
                // forward to the virtual keyboard the pressed keys
                event.accepted = true;
                if(event.key === Qt.Key_Backspace)
                    keyboard.keypress(keyboard.backspace);
                else if(event.key === Qt.Key_Escape)
                    home();
                else
                    keyboard.keypress(event.text);
            } else if(event.key === Qt.Key_Space && currentActiveGrid.currentItem) {
                currentActiveGrid.currentItem.selectCurrentItem()
            }
        }
        Keys.onReleased: (event) => {
            keyboardMode = true
            event.accepted = false
        }
        Keys.onTabPressed: (event) => {
            if(!ApplicationSettings.sectionVisible) {
                currentActiveGrid = activitiesGrid;
            }
            else if(currentActiveGrid == section) {
                if(activity.currentTagCategories && activity.currentTagCategories.length != 0) {
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
            model: activity.sections
            x: ApplicationSettings.sectionVisible ? GCStyle.halfMargins : 0
            y: ApplicationSettings.sectionVisible ? GCStyle.halfMargins : 0
            visible: ApplicationSettings.sectionVisible
            cellWidth: activityBackground.sectionCellWidth
            cellHeight: activityBackground.sectionCellWidth
            interactive: false
            keyNavigationWraps: true
            highlightMoveDuration: 0
            property int currentSectionSelected: 0

            Component {
                id: sectionDelegate
                Item {
                    id: backgroundSection
                    width: activityBackground.sectionCellWidth - GCStyle.halfMargins
                    height: width

                    Rectangle {
                        visible: section.currentSectionSelected === index
                        anchors.fill: parent
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#80FFFFFF" }
                            GradientStop { position: 1.0; color: "#40FFFFFF" }
                        }
                        border.width: GCStyle.thinnestBorder
                        border.color: GCStyle.whiteBorder
                    }

                    Image {
                        source: modelData.icon
                        sourceSize.width: activityBackground.sectionIconWidth
                        sourceSize.height: activityBackground.sectionIconWidth
                        anchors.centerIn: parent
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
                        if(section.currentSectionSelected === index) {
                            section.currentIndex = index // in case it was moved with keyboard
                            return
                        }
                        section.currentIndex = index
                        activity.currentTag = modelData.tag
                        activity.currentTagCategories = modelData.categories
                        if(modelData.categories !== undefined) {
                            activity.currentCategory = Object.keys(modelData.categories[0])[0];
                        }
                        else {
                            activity.currentCategory = ""
                        }
                        particles.burst(10)
                        if(modelData.tag === "search") {
                            ActivityInfoTree.filterBySearch(searchTextField.text);
                        }
                        else {
                            ActivityInfoTree.filterByTag(modelData.tag, activity.currentCategory, false)
                            ActivityInfoTree.filterEnabledActivities(true)
                        }
                        section.currentSectionSelected = index
                    }
                }
            }
            delegate: sectionDelegate
            highlight: Rectangle {
                    color: "transparent"
                    border.width: GCStyle.thinBorder
                    border.color: GCStyle.whiteBorder
            }
        }

        GridView {
            id: categoriesGrid
            model: activity.currentTagCategories
            x: activitiesGrid.x
            height: activity.currentCategory == "" ? 0 : activityBackground.categoriesHeight
            width: activitiesGrid.width
            interactive: false
            keyNavigationWraps: true
            highlightFollowsCurrentItem: false
            visible: activity.currentTag !== "search"
            cellWidth: activity.currentTagCategories ? categoriesGrid.width / activity.currentTagCategories.length : 0
            cellHeight: height
            property int currentCategorySelected: 0

            onModelChanged: currentCategorySelected = 0;

            delegate: GCButton {
                id: button
                selected: categoriesGrid.currentIndex === index
                down: activity.currentCategory === button.category
                theme: "categories"
                textSize: "regular"
                rightIconSize: rightIcon.width + rightIcon.anchors.rightMargin
                width: categoriesGrid.cellWidth - GCStyle.halfMargins
                height: categoriesGrid.cellHeight
                text: modelData[category]
                property string category: Object.keys(modelData)[0]
                onClicked: {
                    selectCurrentItem()
                }

                function selectCurrentItem() {
                    if(categoriesGrid.currentCategorySelected === index) {
                        categoriesGrid.currentIndex = index // in case it was moved with keyboard
                        return
                    }
                    categoriesGrid.currentIndex = index
                    activity.currentCategory = Object.keys(modelData)[0]
                    ActivityInfoTree.filterByTag(activity.currentTag, activity.currentCategory, false)
                    ActivityInfoTree.filterEnabledActivities(true)
                    categoriesGrid.currentCategorySelected = index
                }

                Image {
                    id: rightIcon
                    visible: activityBackground.horizontal
                    source: "qrc:/gcompris/src/activities/menu/resource/category-" + button.category + ".svg";
                    height: visible ? Math.floor(parent.height * 0.8) : 0
                    sourceSize.height: height
                    width: height
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: visible ? GCStyle.halfMargins : 0
                    }
                }
            }
            highlight: Item {}
        }

        // Activities
        property int iconWidth: 120 * ApplicationInfo.ratio
        property real activityCellWidth:  activitiesGrid.width / Math.max(1, Math.floor(activitiesGrid.width / iconWidth))
        property real activityCellHeight: iconWidth * 1.7

        Rectangle {
            id: activitiesMask
            visible: false
            layer.enabled: true
            anchors.fill: activitiesGrid
            // Dynamic position of the gradient used for OpacityMask
            // If the hidden bottom part of the grid is > to the maximum height of the gradient,
            // we use the maximum height.
            // Else we set the gradient start position proportionnally to the hidden bottom part,
            // until it disappears.
            // And if using software renderer, the mask is disabled, so we save the calculation and set it to 1
            property real gradientStartValue:
            !ApplicationInfo.useSoftwareRenderer ?
            (activitiesGrid.hiddenBottom > activitiesGrid.height * 0.08 ?
            0.92 : 1 - (activitiesGrid.hiddenBottom / activitiesGrid.height)) :
            1
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#FFFFFFFF" }
                GradientStop { position: activitiesMask.gradientStartValue; color: "#FFFFFFFF" }
                GradientStop { position: activitiesMask.gradientStartValue + 0.04; color: "#00FFFFFF"}
            }
        }

        GridView {
            id: activitiesGrid
            anchors {
                top: {
                    if(searchBar.visible)
                        return searchBar.bottom
                    else if (activity.currentCategory != "")
                        return categoriesGrid.bottom
                    else if(activityBackground.horizontal)
                        return section.bottom
                    else
                        return activityBackground.top
                }
                bottom: bar.top
                right: activityBackground.right
                margins: GCStyle.halfMargins
                rightMargin: 0
                topMargin: anchors.top == section.bottom ? 0 : GCStyle.halfMargins
            }
            cellWidth: activityCellWidth
            cellHeight: activityCellHeight
            clip: true
            model: ActivityInfoTree.menuTree
            keyNavigationWraps: true
            maximumFlickVelocity: activity.height
            boundsBehavior: Flickable.StopAtBounds
            // Needed to calculate the OpacityMask offset
            // If using software renderer, this value is not used, so we save the calculation and set it to 1
            property real hiddenBottom: ApplicationInfo.useSoftwareRenderer ? 1 : contentHeight - height - contentY

            delegate: Item {
                id: delegateItem
                width: activityCellWidth - GCStyle.halfMargins
                height: activityCellHeight - GCStyle.halfMargins
                enabled: activity.clickMode === "play" || (activityInfoTreeItem.hasConfig || activityInfoTreeItem.hasDataset)
                property var activityInfoTreeItem: ActivityInfoTree.menuTree[index]
                Rectangle {
                    id: activityCard
                    width: parent.width
                    height: parent.height
                    color: GCStyle.whiteBg
                    opacity: 0.5
                }
                Image {
                    id: activityIcon
                    source: "qrc:/gcompris/src/activities/" + icon
                    anchors.top: activityCard.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: iconWidth - GCStyle.halfMargins
                    height: width
                    sourceSize.width: width
                    fillMode: Image.PreserveAspectFit
                    anchors.margins: GCStyle.halfMargins
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
                }
                GCText {
                    id: title
                    anchors.top: activityIcon.bottom
                    anchors.bottom: activityCard.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: GCStyle.tinyMargins
                    horizontalAlignment: Text.AlignHCenter
                    fontSizeMode: Text.Fit
                    minimumPointSize: 7
                    fontSize: regularSize
                    elide: Text.ElideRight
                    wrapMode: Text.WordWrap
                    text: activityInfoTreeItem.title
                    textFormat: Text.PlainText
                    opacity: activityIcon.opacity
                }
                ParticleSystemStarLoader {
                    id: particles
                    anchors.fill: activityCard
                }
                MouseArea {
                    anchors.fill: activityCard
                    onClicked: selectCurrentItem()
                }

                Image {
                    source: activity.url + (favorite ? "all.svg" : "all_disabled.svg");
                    anchors {
                        top: parent.top
                        right: parent.right
                        rightMargin: GCStyle.halfMargins
                    }
                    sourceSize.width: iconWidth * 0.25
                    visible: ApplicationSettings.sectionVisible
                    opacity: activityIcon.opacity
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
                            activity.clickMode = "play"
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

                    if(activity.clickMode === "play") {
                        particles.burst(50)
                        ActivityInfoTree.currentActivity = activityInfoTreeItem
                        activityLoader.setSource("qrc:/gcompris/src/activities/" + ActivityInfoTree.currentActivity.name,
                        {
                            'menu': activity,
                            'activityInfo': ActivityInfoTree.currentActivity,
                            'levelFolder': currentLevels,
                            'audioVoices': audioVoices,
                            'loading': loading
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
                width: activityCellWidth - GCStyle.halfMargins
                height: activityCellHeight - GCStyle.halfMargins
                color:  "#AAFFFFFF"
                border.width: GCStyle.thinBorder
                border.color: GCStyle.whiteBorder
                visible: activityBackground.keyboardMode
                Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
                Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }
            }
            layer.enabled: !ApplicationInfo.useSoftwareRenderer
            layer.effect: MultiEffect {
                id: activitiesOpacity
                maskEnabled: true
                maskSource: activitiesMask
                maskThresholdMin: 0.5
                maskSpreadAtMin: 1.0
            }
        }

        Loader {
            id: warningOverlay
            anchors.fill: activitiesGrid
            active: (ActivityInfoTree.menuTree.length === 0) && (activity.currentTag === "favorite")
            sourceComponent: Item {
                GCText {
                    id: instructionTxt
                    fontSize: smallSize
                    y: 2 * GCStyle.baseMargins
                    z: 2
                    width: parent.width * 0.7 - 2 * GCStyle.baseMargins
                    height: parent.height - 3 * GCStyle.baseMargins
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    font.weight: Font.DemiBold
                    color: GCStyle.whiteText
                    text: qsTr("Put your favorite activities here by clicking on the " +
                    "sun at the top right of that activity.")
                }
                Rectangle {
                    y: GCStyle.baseMargins
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: instructionTxt.contentWidth + 2 * GCStyle.baseMargins
                    height: instructionTxt.contentHeight + 2 * GCStyle.baseMargins
                    z: 1
                    radius: GCStyle.halfMargins
                    border.width: GCStyle.thinnestBorder
                    border.color: GCStyle.whiteBorder
                    color: "#527482"
                }
            }
        }

        // The scroll buttons
        GCButtonScroll {
            visible: ApplicationInfo.useSoftwareRenderer
            anchors.right: parent.right
            anchors.bottom: activitiesGrid.bottom
            anchors.margins: GCStyle.halfMargins
            onUp: activitiesGrid.flick(0, 1127)
            onDown: activitiesGrid.flick(0, -1127)
            upVisible: activitiesGrid.atYBeginning ? false : true
            downVisible: activitiesGrid.atYEnd ? false : true
        }

        Rectangle {
            id: searchBar
            visible: activity.currentTag === "search"
            height: activityBackground.categoriesHeight
            radius: GCStyle.halfMargins
            border.width: GCStyle.thinnestBorder
            border.color: GCStyle.darkBorder
            color: GCStyle.lightBg

            Connections {
                // On mobile with GCompris' virtual keyboard activated:
                // Force invisibility of Androids virtual keyboard:
                target: (ApplicationInfo.isMobile && activity.currentTag === "search"
                         && ApplicationSettings.isVirtualKeyboard) ? Qt.inputMethod : null
                function onVisibleChanged() {
                    if (ApplicationSettings.isVirtualKeyboard && visible)
                        Qt.inputMethod.hide();
                }
                function onAnimatingChanged() {
                    // note: seems to be never fired!
                    if (ApplicationSettings.isVirtualKeyboard && Qt.inputMethod.visible)
                        Qt.inputMethod.hide();
                }
            }

            Connections {
                target: activity
                function onCurrentTagChanged() {
                    if (activity.currentTag === 'search') {
                        if(ApplicationSettings.isVirtualKeyboard && !keyboard.isPopulated) {
                            keyboard.populate();
                            keyboard.isPopulated = true;
                        }
                        searchTextField.focus = true;
                    } else
                        activity.focus = true;
                }

                function onStartActivity(activityName: string, level: int) {
                    ActivityInfoTree.setCurrentActivityFromName(activityName)
                    var currentLevels
                    if (ApplicationSettings.filterLevelOverridedByCommandLineOption)
                        currentLevels = ActivityInfoTree.currentActivity.currentLevels
                    else
                        currentLevels = ApplicationSettings.currentLevels(ActivityInfoTree.currentActivity.name)
                    activityLoader.setSource("qrc:/gcompris/src/activities/" + ActivityInfoTree.currentActivity.name,
                    {
                        'menu': activity,
                        'audioVoices': audioVoices,
                        'loading': loading,
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
                color: GCStyle.darkText
                font.pixelSize: height * 0.5
                font.bold: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                font.family: GCSingletonFontLoader.fontName
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
            height: activitySettingsLabel.contentHeight + GCStyle.baseMargins
            width: activitySettingsLabel.contentWidth + GCStyle.baseMargins * 2
            visible: activity.clickMode === "activityConfig"
            anchors {
                horizontalCenter: activitiesGrid.horizontalCenter
                bottom: bar.top
                bottomMargin: height * 0.3
            }
            radius: GCStyle.halfMargins
            border.width: GCStyle.thinBorder
            border.color: "#8b66b2"
            color: GCStyle.lightBg

            GCText {
                id: activitySettingsLabel
                text: qsTr("Activity Settings")
                width: activitiesGrid.width - GCStyle.baseMargins * 2
                fontSizeMode: Text.Fit
                minimumPointSize: 7
                visible: parent.visible
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: GCStyle.darkText
            }
        }

        states: [
            State {
                name: "horizontalState"; when: activityBackground.horizontal
                PropertyChanges {
                    activityBackground {
                        sectionCellWidth: Math.min(110 * ApplicationInfo.ratio, section.width / activity.sections.length)
                    }
                    section {
                        width: ApplicationSettings.sectionVisible ? categoriesGrid.width : 0
                        height: ApplicationSettings.sectionVisible ? activityBackground.sectionCellWidth : 0
                    }
                    categoriesGrid {
                        anchors.topMargin: 0
                    }
                    activitiesGrid {
                        width: activityBackground.width - GCStyle.halfMargins
                    }
                    searchBar {
                        width: activityBackground.width * 0.6
                        anchors.topMargin: 0
                    }
                }
                AnchorChanges {
                    target: categoriesGrid
                    anchors.top: section.bottom
                }
                AnchorChanges {
                    target: activitiesGrid
                    anchors.left: activityBackground.left
                }
                AnchorChanges {
                    target: searchBar
                    anchors.top: section.bottom
                    anchors.horizontalCenter: activitiesGrid.horizontalCenter
                    anchors.left: undefined
                }
            },
            State {
                name: "verticalState"; when: !activityBackground.horizontal
                PropertyChanges {
                    activityBackground {
                        sectionCellWidth: Math.min(110 * ApplicationInfo.ratio, section.height / activity.sections.length)
                    }
                    section {
                        width: ApplicationSettings.sectionVisible ? activityBackground.sectionCellWidth : 0
                        height:  ApplicationSettings.sectionVisible ? activityBackground.height - bar.height : 0
                    }
                    categoriesGrid {
                        anchors.topMargin: GCStyle.halfMargins
                    }
                    activitiesGrid {
                        width: activityBackground.width - section.width - section.x
                    }
                    searchBar {
                        width: activitiesGrid.width - GCStyle.halfMargins
                        anchors.topMargin: GCStyle.halfMargins
                    }
                }
                AnchorChanges {
                    target: categoriesGrid
                    anchors.top: activityBackground.top
                }
                AnchorChanges {
                    target: activitiesGrid
                    anchors.left: section.right
                }
                AnchorChanges {
                    target: searchBar
                    anchors.top: activityBackground.top
                    anchors.horizontalCenter: undefined
                    anchors.left: activitiesGrid.left
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
            onKeypress: (text) => {
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
                var numberOfLetters = letter.length
                while(offset < numberOfLetters-1) {
                   if(numberOfLetters <= 100) {
                       cols = Math.ceil((numberOfLetters-offset) / (3 - row));
                   }
                   else {
                       cols = activityBackground.horizontal ? (Math.ceil((numberOfLetters-offset) / (15 - row)))
                                                       :(Math.ceil((numberOfLetters-offset) / (22 - row)))
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
               if(numberOfLetters <= 100) {
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
                if(activity.clickMode == "play") {
                    activity.clickMode = "activityConfig"
                }
                else {
                    activity.clickMode = "play"
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
                    ActivityInfoTree.filterByTag(activity.currentTag, activity.currentCategory, false)
                    ActivityInfoTree.filterEnabledActivities(true)
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
}
