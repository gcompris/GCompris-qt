.pragma library
.import QtQuick 2.0 as Quick

var currentActivity;
var currentActivityInfo;
var pageView;

function init(thePageView) {
    pageView = thePageView
}

function selectActivity(activity) {
    console.log("selected activity: " + activity.name);
    if(activity.type !== 'menu') {
        startActivity(activity)
    }
}

function startActivity(activity) {
    if(currentActivity !== undefined) {
        currentActivity.destroy()
    }
    currentActivityInfo = activity
    console.log("activity.dir=" + activity.dir);
    var qmlActivityFile = "qrc:/gcompris/src/activities/" + activity.name + "/Activity.qml"
    var qmlActivity = Qt.createComponent(qmlActivityFile)
    console.log(qmlActivity.errorString())
    if (qmlActivity.status === Quick.Component.Ready) {
        currentActivity = qmlActivity.createObject(pageView);
        if (currentActivity === null) {
            console.log("error creating activity " + activityName);
            console.log(component.errorString());
            return false;
        }
        pageView.push(currentActivity)
    } else {
        console.log("failed to load activity: " + qmlActivityFile);
    }
}

function stopActivity() {
    if(currentActivity !== undefined) {
        pageView.pop()
    }
}

function getCurrentActivityInfo() {
    return currentActivityInfo
}

function pagePop()
{
    pageView.pop()
}

function pagePush(item)
{
    pageView.push(item)
}

