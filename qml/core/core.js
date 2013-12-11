.pragma library
.import QtQuick 2.0 as Quick

var currentActivity;
var currentActivityInfo;
var main;
var bar;
var barPreviousCallback;
var barNextCallback;
var menu;

function init(theMain, theMenu, theBar) {
    main = theMain
    menu = theMenu
    bar = theBar
}

function startBar(content) {
    bar.visible = true
    bar.content.value = content
}

function stopBar() {
    bar.visible = false
}

function setBarPreviousCallback(thePreviousCallback) {
    barPreviousCallback = thePreviousCallback
}

function setBarNextCallback(theNextCallback) {
    barNextCallback = theNextCallback
}

function setBarLevel(theLevel) {
    bar.level = theLevel
}

function startMenu() {
    menu.visible = true
    setBarLevel(0)
    startBar(bar.content.exit | bar.content.about | bar.content.help)
    main.focus = true
}

function stopMenu() {
    menu.visible = false
    bar.visible = false
    main.focus = false
}

function stopDialogs() {
    main.stopDialogs()
}

function startActivity(activityName) {
    stopMenu()
    stopDialogs()
    var qmlActivityInfo = Qt.createComponent("../" + activityName + "/ActivityInfo.qml")
    if (qmlActivityInfo.status == Quick.Component.Ready) {
        currentActivityInfo = qmlActivityInfo.createObject(main);
        if (currentActivityInfo == null) {
            console.log("error creating activityInfo" + activityName);
            console.log(component.errorString());
            return false;
        }
    }

    var qmlActivity = Qt.createComponent("../" + activityName + "/Activity.qml")
    if (qmlActivity.status == Quick.Component.Ready) {
        currentActivity = qmlActivity.createObject(main);
        if (currentActivity == null) {
            console.log("error creating activity " + activityName);
            console.log(component.errorString());
            return false;
        }
    }
}

function stopActivity() {
    if(currentActivity != null)
        currentActivity.destroy()
    startMenu()
}

function previousLevel() {
    barPreviousCallback()
}

function nextLevel() {
    barNextCallback()
}

function getCurrentActivityInfo() {
    return currentActivityInfo
}

function displayHelp() {
    bar.showHelp(currentActivityInfo.section,
                 currentActivityInfo.prerequisite,
                 currentActivityInfo.goal,
                 currentActivityInfo.manual,
                 currentActivityInfo.credit)
}
