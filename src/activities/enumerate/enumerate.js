.pragma library
.import QtQuick 2.0 as Quick

var currentLevel = 0
var numberOfLevel = 9
var main
var background
var bar
var bonus
var currentIndex=0
var nbDiffrentTypes=0
var number_of_types=16
var number_of_item_type=0
var number_of_item_max=5
var nbValidations
var userAnswerInput
var items
var itemTypes = {
                "baby_bottle": 0,
                "banana":1 ,
                "butter": 2,
                "chocolate" : 3,
                "chocolate_cake": 4,
                "cookie" : 5,
                "french_croissant": 6,
                "grapefruit": 7,
                "marmelade": 8,
                "milk_cup": 9,
                "milk_shake": 10,
                "orange": 11,
                "pear": 12,
                "round_cookie":13,
                "suggar_box": 14,
                "yahourt": 15
}
var itemIcons = [   "qrc:/gcompris/src/activities/enumerate/resource/baby_bottle.png",
                    "qrc:/gcompris/src/activities/enumerate/resource/banana.png",
                    "qrc:/gcompris/src/activities/enumerate/resource/butter.png",
                    "qrc:/gcompris/src/activities/enumerate/resource/chocolate.png",
                    "qrc:/gcompris/src/activities/enumerate/resource/chocolate_cake.png",
                    "qrc:/gcompris/src/activities/enumerate/resource/cookie.png",
                    "qrc:/gcompris/src/activities/enumerate/resource/french_croissant.png",
                    "qrc:/gcompris/src/activities/enumerate/resource/grapefruit.png",
                    "qrc:/gcompris/src/activities/enumerate/resource/marmelade.png",
                    "qrc:/gcompris/src/activities/enumerate/resource/milk_cup.png",
                    "qrc:/gcompris/src/activities/enumerate/resource/milk_shake.png",
                    "qrc:/gcompris/src/activities/enumerate/resource/orange.png",
                    "qrc:/gcompris/src/activities/enumerate/resource/pear.png",
                    "qrc:/gcompris/src/activities/enumerate/resource/round_cookie.png",
                    "qrc:/gcompris/src/activities/enumerate/resource/suggar_box.png",
                    "qrc:/gcompris/src/activities/enumerate/resource/yahourt.png"
]
var userAnswers = new Array(number_of_types)
var answerToFind = new Array(number_of_types)
var typesInUse= new Array(number_of_types)

function start(main_, background_, bar_, bonus_) {
    console.log("enumerate activity: start")
    main = main_
    background = background_
    bar = bar_
    bonus = bonus_
    currentLevel = 0
    initLevel()
}

function stop() {
    cleanUp()
    console.log("enumerate activity: stop")
}

function initLevel() {
    console.log("enumerate activity: create some content in my activity")
    bar.level = currentLevel + 1
    cleanUp()
    items = new Array()
    userAnswerInput = new Array()
    background.source="qrc:/gcompris/src/activities/enumerate/resource/enumerate_background.png"
    var nbItems=0
    var type=0
    for(var i=0;i<number_of_item_type;i++){
        nbItems=getRandomInt(1,number_of_item_max)
        type=getRandomInt(0,number_of_types)
        addItems(type,nbItems)
    }
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}

function cleanUp(){
    var userAnswers = new Array(number_of_types)
    var answerToFind = new Array(number_of_types)
    if(items){
        for (var i = 0; i < items.length; i++) {
                items[i].destroy()
                items[i]=null
        }
        items.length=0
    }
    if(userAnswerInput){
        for (var j=0;j<userAnswerInput.length;j++){
                userAnswerInput[j].destroy()
                userAnswerInput[j]=null
        }
        userAnswerInput.length=0
    }
    for(var l=0;l<number_of_item_type;l++){
        userAnswers[l]=0
        answerToFind[l]=0
    }
    for(var k=0;k<number_of_types;k++){
        typesInUse[k]=0
    }

    currentIndex=0
    nbDiffrentTypes=0

    switch(currentLevel)
      {
      case 0:
        number_of_item_type = 1;
        number_of_item_max  = 5;
        break;
      case 1:
        number_of_item_type = 2;
        number_of_item_max  = 5;
        break;
      case 2:
        number_of_item_type = 3;
        number_of_item_max  = 5;
        break;
      case 3:
        number_of_item_type = 3;
        number_of_item_max  = 5;
        break;
      case 4:
        number_of_item_type = 4;
        number_of_item_max  = 5;
        break;
      case 5:
        number_of_item_type = 4;
        number_of_item_max  = 6;
        break;
      case 6:
        number_of_item_type = 4;
        number_of_item_max  = 7;
        break;
      case 7:
        number_of_item_type = 4;
        number_of_item_max  = 10;
        break;
      case 8:
        number_of_item_type = 5;
        number_of_item_max  = 10;
        break;
      default:
        number_of_item_type = 5;
        number_of_item_max = 10;
      }
    nbValidations=0
}

function createAnswerArea(type){
    var component=Qt.createComponent("AnswerArea.qml")
    var area = component.createObject(background,
                     {"imgPath": itemIcons[type],
                      "anchors.right" : background.right,
                      "y" : background.height - nbDiffrentTypes*75,
                      "itemType": type,
                      "focus": true});
    return area
}

function createOneItem(type){
    var component=Qt.createComponent("ItemToEnumerate.qml");
    var newItem=component.createObject(background,
                         {"x": getRandomInt(200,background.width-200),
                         "y": getRandomInt(200,background.height-200),
                         "imgPath": itemIcons[type]});
    return newItem
}

function addItems(type,nbItems){
    if(typesInUse[type]==0){
        for(var i=currentIndex;i<currentIndex+nbItems;i++){
            items[i]=createOneItem(type)
        }
        currentIndex+=nbItems
        nbDiffrentTypes++
        userAnswerInput[nbDiffrentTypes-1]=createAnswerArea(type)
        answerToFind[type]=nbItems
        typesInUse[type]=1
    }
}

function setUserAnswer(type,userValue){
        userAnswers[type]=userValue
        nbValidations++
    console.log("Nb validations : " + nbValidations)
        if(nbValidations==number_of_item_type){
            checkAnswers()
        }
}

function checkAnswers(){
        for(var i=0;i<number_of_types;i++){
                    if(userAnswers[i]!=answerToFind[i]){
                        bonus.bad("smiley")
                        nbValidations--
                        return;
                    }
        }
        bonus.good("smiley")
}

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
}
