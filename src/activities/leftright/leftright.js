.import QtQuick 2.0 as Quick

var currentHands = []
var levels = [
    { "images": [
        "main_droite_dessus_0.png",
        "main_droite_paume_0.png" ,
        "main_gauche_dessus_0.png",
        "main_gauche_paume_0.png" ],
      "rotations": [-90]
    },
    { "images": [
        "main_droite_dessus_0.png",
        "main_droite_paume_0.png",
        "main_gauche_dessus_0.png",
        "main_gauche_paume_0.png" ],
      "rotations": [0, 180]
    },
    { "images": [
        "main_droite_dessus_0.png",
        "main_droite_paume_0.png",
        "main_gauche_dessus_0.png",
        "main_gauche_paume_0.png" ],
        "rotations": [90]
     },
    { "images": [
        "poing_droit_dessus_0.png",
        "poing_droit_paume_0.png",
        "poing_gauche_dessus_0.png",
        "poing_gauche_paume_0.png" ],
        "rotations": [-90]
    },
    { "images": [
        "poing_droit_dessus_0.png",
        "poing_droit_paume_0.png",
        "poing_gauche_dessus_0.png",
        "poing_gauche_paume_0.png" ],
        "rotations": [0, 180]
    },
    { "images": [
        "poing_droit_dessus_0.png",
        "poing_droit_paume_0.png",
        "poing_gauche_dessus_0.png",
        "poing_gauche_paume_0.png" ],
        "rotations": [90]
    },
]


var currentImageId;
var currentLevel;
var bar;
var bonus;
var imageAnimOff;
var leftButton;
var rightButton;

function start(bar_, bonus_, imageAnimOff_,
               leftButton_, rightButton_) {
    bar = bar_
    bonus = bonus_
    imageAnimOff = imageAnimOff_
    leftButton = leftButton_
    rightButton = rightButton_
    currentLevel = 0
    initLevel()
}

function stop() {

}

function initLevel() {
    bar.level = currentLevel + 1
    currentImageId = 0
    currentHands = new Array()
    var level = levels[currentLevel]
    var counter = 0
    for (var i = 0 ; i < level.images.length ; i++) {
        for (var r = 0 ; r < level.rotations.length ; r++) {
            currentHands[counter++] = {
                'image': level.images[i],
                'rotation': level.rotations[r] }
        }
    }
    currentHands = shuffle(currentHands)
    displayHand()
}

function nextLevel() {
    if(levels.length <= ++currentLevel ) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = levels.length - 1
    }
    initLevel();
}

function displayHand() {
    leftButton.isCorrectAnswer = isLeft()
    rightButton.isCorrectAnswer = isRight()
    imageAnimOff.start()
}

function getCurrentHandImage() {
    return "qrc:/gcompris/src/activities/leftright/resource/" +
            currentHands[currentImageId].image
}

function getCurrentHandRotation() {
    return currentHands[currentImageId].rotation
}

function displayNextHand() {
    if(currentHands.length <= ++currentImageId ) {
        bonus.good("flower")
        nextLevel()
    }
    displayHand()
}

function isLeft() {
    return (currentHands[currentImageId].image.indexOf("gauche") !== -1) ? true : false
}

function leftClick() {
    if(currentHands[currentImageId].image.indexOf("gauche") !== -1) {
        displayNextHand()
    }
}

function isRight() {
    return (currentHands[currentImageId].image.indexOf("droit") !== -1) ? true : false
}

function rightClick() {
    if(currentHands[currentImageId].image.indexOf("droit") !== -1) {
        displayNextHand()
    }
}

function leftClickPressed() {
    leftButton.pressed()
}

function rightClickPressed() {
    rightButton.pressed()
}

function shuffle(o) {
    for(var j, x, i = o.length; i;
        j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
    return o;
};
