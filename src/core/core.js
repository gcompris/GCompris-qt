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

function selectActivity(activity) {
    console.log("selected activity: " + activity.name);
    if(activity.type != 'menu') {
        startActivity(activity)
    }
}

function startActivity(activity) {
    stopMenu()
    stopDialogs()
    currentActivityInfo = activity
    var qmlActivityFile = "../../src/activities/" + activity.name + "/Activity.qml"
    var qmlActivity = Qt.createComponent(qmlActivityFile)
    console.log(qmlActivity.errorString())
    if (qmlActivity.status === Quick.Component.Ready) {
        currentActivity = qmlActivity.createObject(main);
        if (currentActivity === null) {
            console.log("error creating activity " + activityName);
            console.log(component.errorString());
            return false;
        }
    } else {
        console.log("failed to load activity: " + qmlActivityFile);
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
                 currentActivityInfo.title,
                 currentActivityInfo.description,
                 currentActivityInfo.prerequisite,
                 currentActivityInfo.goal,
                 currentActivityInfo.manual,
                 currentActivityInfo.credit)
}
