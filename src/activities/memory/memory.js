.pragma library
.import QtQuick 2.0 as Quick

var _currentLevel = 0
var _numberOfLevel = 9
var _main
var _background
var _bar
var _bonus
var _grid
var _containerModel
var _cardRepeater
var nb_of_pair
var _nb_of_pair_level_relation_array
var _imageList
var _line
var _column
var pictureClicked
var lastPics = new Array
var cardStillStay


function start(main, background, bar, bonus,containerModel,cardRepeater, grid) {
    console.log("memory activity: start")
    _main = main
    _background = background
    _bar = bar
    _bonus = bonus
    _grid = grid
    _currentLevel = 0
    _containerModel=containerModel
    _cardRepeater=cardRepeater
    pictureClicked = []


    //each array item is nb of line then column in memory
    _nb_of_pair_level_relation_array = new Array([3,2],[4,2],[5,2],[4,3],[6,3],[5,4],[6,4],[7,4], [8,4])

    _column = _nb_of_pair_level_relation_array[_currentLevel][0]
    //liste of picture
    _imageList = new Array("01_cat.png","02_pig.png","03_bear.png","04_hippopotamus.png","05_penguin.png","06_cow.png", "07_sheep.png", "08_turtle.png", "09_panda.png", "10_chicken.png", "11_redbird.png", "12_wolf.png", "13_monkey.png", "14_fox.png", "15_bluebirds.png", "16_elephant.png", "17_lion.png", "18_gnu.png", "19_bluebaby.png", "20_greenbaby.png", "21_frog.png")

    initLevel()
}

function stop() {
    console.log("memory activity: stop")
}

function initLevel() {

    _bar.level = _currentLevel + 1
    _containerModel.clear()

    //compute number of cards
    _line = _nb_of_pair_level_relation_array[_currentLevel][1]
    _column = _nb_of_pair_level_relation_array[_currentLevel][0]
    _grid.columns=_column
    // console.log('nb de colonnes', _column)
    nb_of_pair = _line*_column /2

    //place randomly a level-defined number of picture pair
    var cardList = new Array()
    for(var ix = 0;  ix < nb_of_pair; ++ix){
        //select  a picture randomly from 21 pictures
        if (cardList.length>0) {
            var card = _imageList[Math.floor((21)*Math.random())]
            //is card still in cardList ?
            while (cardList.indexOf(card)>=0){
                var card = _imageList[Math.floor((21)*Math.random())]

            }
            cardList[ix]= card

        }
        else {
            var card = _imageList[Math.floor((21)*Math.random())] //first run
            cardList[ix]= card

        }

    }
    cardList = shuffle(cardList.concat(cardList))
    cardStillStay = cardList.length


    //fill in with pictures
    for(var i = 0;  i < cardList.length; ++i) {
       _containerModel.append({"back" : "resource/backcard.png", "image" : "resource/"+cardList[i], "width_" : _main.width * 0.7 /_column, "height_" : _main.height * 0.6 /_line})
    }

}


function cardClicked(cardObject,imagePath){
    //launch when a card is cliked.
    if (Object.keys(pictureClicked).length==0){//first click on a card
        try{
        lastPics[0].isBack = true
        lastPics[1].isBack = true
        lastPics = []
        }
        catch(ReferenceError){

        }

        pictureClicked = {"Pic":cardObject, "imagePic" : imagePath}
    }

    else if (Object.keys(pictureClicked).length==2){ //when 2nd picture is clicked

        if (pictureClicked.imagePic == imagePath){//when 2 pictures are the same

            pictureClicked.Pic.isBack=false //stay faced
            cardObject.isBack=false
            pictureClicked.Pic.isFound=true //signal for hidden state
            cardObject.isFound=true
            cardStillStay = cardStillStay -2
            console.log("il reste encore",cardStillStay,"cartes à cliquer")
            if(cardStillStay==0){//no more card in level
                youWon()  //!!!!!!!!!!!!!!!!! YEAH !!!!!!!!!!!!!!!!!!!!!!!!!!!

            }
            }

        else{//pictures clicked are not the same

            lastPics = [pictureClicked.Pic, cardObject] //keep them to back them on next click

        }
        pictureClicked = {}


    }

}

function youWon(){
    _bonus.good("flower")
}

function nextLevel() {
    if(_numberOfLevel <= ++_currentLevel ) {
        _currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    if(--_currentLevel < 0) {
        _currentLevel = _numberOfLevel - 1
    }
    initLevel();
}

function shuffle(o) {
    for(var j, x, i = o.length; i;
        j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
    return o;
}

function getColumn(){
    console.log('GetColumn : nb de colonnes', _column, _currentLevel)
    if(_column){return _column}
    else {return 3}

}
