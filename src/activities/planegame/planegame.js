.pragma library
.import QtQuick 2.0 as Quick

var planeLastTarget = 10;
var main
var background
var bar
var bonus
var score
var activity
var plane

var cloudComponent = Qt.createComponent("qrc:/gcompris/src/activities/planegame/Cloud.qml");
var clouds = new Array;

function start(main_, background_, bar_, bonus_, score_, activity_, plane_) {
    console.log("planegame activity: start")
    main = main_
    background = background_
    bar = bar_
    bonus = bonus_
    score = score_;
    activity = activity_
    plane = plane_
    activity.currentLevel = 0
    initLevel()

    score.numberOfSublevels = planeLastTarget
}

function stop() {
    console.log("planegame activity: stop")
}

function increaseSpeedX() {
    if(plane.speedX < activity.max_speed)
        plane.speedX ++;
}

function decreaseSpeedX() {
    if(plane.speedX > -activity.max_speed)
        plane.speedX --;
}

function increaseSpeedY() {
    if(plane.speedY < activity.max_speed)
        plane.speedY ++;
}

function decreaseSpeedY() {
    if(plane.speedY > -activity.max_speed)
        plane.speedY --;
}

function initLevel() {
    console.log("planegame activity: init level")
    bar.level = activity.currentLevel + 1;
    score.currentSubLevel = 1

    plane.x = 100
    plane.y = background.height/2-plane.height/2
    plane.speedX = 0
    plane.speedY = 0

    for(var i = clouds.length - 1; i >= 0 ; --i) {
        var cloud = clouds[i];
        // Remove the cloud
        cloud.destroy()
        // Remove the element from the list
        clouds.splice(i, 1)
    }
}

function nextLevel() {
    if(activity.numberOfLevel-1 <= ++activity.currentLevel) {
        activity.currentLevel = activity.numberOfLevel-1
    }

    initLevel();
}

function previousLevel() {
    if(--activity.currentLevel < 0) {
        activity.currentLevel = activity.numberOfLevel - 1
    }
    initLevel();
}

function repositionObjectsOnWidthChanged(factor) {

    plane.x *= factor
    for(var i = clouds.length - 1; i >= 0 ; --i) {
        var cloud = clouds[i];
        cloud.x *= factor
    }
}

function repositionObjectsOnHeightChanged(factor) {
    plane.y *= factor
    for(var i = clouds.length - 1; i >= 0 ; --i) {
        var cloud = clouds[i];
        cloud.y *= factor
    }
}

function createCloud() {
    var cloud = cloudComponent.createObject(background, {"activity": activity});

    cloud.x = background.width - cloud.width
    cloud.y = getRandomInt(0, background.height - cloud.height)

    /* Random cloud number */
    if(getRandomInt(0, 1) == 0) {
        /* Put the target */
        cloud.number = score.currentSubLevel;
    }
    else {
        var min = Math.max(1, score.currentSubLevel - 1);
        cloud.number = min + getRandomInt(0, score.currentSubLevel - min + 3);
    }

    clouds.push(cloud);
}

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
}
