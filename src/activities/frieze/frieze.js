/* GCompris - frieze.js
 *
 * SPDX-FileCopyrightText: 2023 Bruno ANSELME <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * Token encoding rules for levels'data
 *  3 letters for shape, color and size (shapes, colors and sizes below)
 *    "sGb" = square, green and big
 *    "tRs" = triangle, red and small
 */
.pragma library
.import core 1.0 as GCompris // for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

const svgUrl = "qrc:/gcompris/src/activities/frieze/resource/svg/"

var numberOfLevel
var items
var friezeSize = 10
var innerColor = "burlywood"
var outerColor = "brown"
var svgHeader = "data:image/svg+xml;utf8,"
var started = false

var emptyToken = "eBb"  // Empty shape, any color, any size
var tokenSvg = {
    "e": "empty.svg",
    "s": "square.svg",
    "t": "triangle.svg",
    "c": "circle.svg",
    "f": "star.svg"
}

var shapes = {}
var smallShapes = {}

var palette = {
        "R": "#da4343",   // red
        "G": "#52d460",   // green
        "B": "#48cbdf",   // blue
        "Y": "#f1c43c"    // yellow
    }
var darkPalette = {
        "R": "#8a2828",
        "G": "#3c7942",
        "B": "#34747e",
        "Y": "#9b7c17"
    }
var colorChars = {
        "R": "R.svg",
        "G": "G.svg",
        "B": "B.svg",
        "Y": "Y.svg"
    }

var tokenSizes = [ "b", "s"]  // Big, small

var tokenPatterns = {}
var noDupPatterns = {}      // Non-duplicate pattern (never use the same symbol twice consecutively)

function start(items_) {
    items = items_;
    numberOfLevel = items.levels.length;
    items.currentLevel = Core.getInitialLevel(numberOfLevel);
    for(var symbol in tokenSvg) {   // Load svg as source code
        shapes[symbol] = items.file.read(svgUrl + tokenSvg[symbol]);
        if (symbol === "e")
            smallShapes[symbol] = items.file.read(svgUrl + tokenSvg[symbol]);
        else
            smallShapes[symbol] = items.file.read(svgUrl + tokenSvg[symbol].replace(".svg", "-small.svg"));
    }
    createPatterns();
    started = true;
    initLevel();
}

function stop() {
}

function addPattern(patterns, str, limit, depth) {
    var len = str.length;
    if (len === depth) {
        patterns.push(str);
        return;
    }
    var newStr = str + "A";
    for (var j = 0; j <= limit; j++) {
        addPattern(patterns, newStr, j, depth);
        if (j === 0)
            limit++;
        var charCode = newStr.charCodeAt(len);
        newStr = newStr.slice(0, len);
        newStr += String.fromCharCode(charCode + 1);
    }
}

function removeDuplicate(patterns) {    // Remove patterns with duplicate symbols consecutively
    var noDup = [];
    for (var i = 0; i < patterns.length; i++) {
        var last = "";
        var first = patterns[i][0];
        var ok = true;
        for (var j = 0; j < patterns[i].length; j++) {
            if (patterns[i][j] === last) {
                ok = false;
            } else {
                last = patterns[i][j];
            }
        }
        ok = ok && (patterns[i][patterns[i].length - 1] !== first);   // when last equal first, it's a duplicated symbol
        if (ok) noDup.push(patterns[i]);
    }
    return noDup;
}

function createPatterns() {
    for (var depth = 2; depth < 9; depth++) {
        var patterns = [];
        addPattern(patterns, "A", 0, depth);
        patterns.shift();        // remove first pattern (AAAAA)
        tokenPatterns[depth] = patterns;
        noDupPatterns[depth] = removeDuplicate(patterns);
    }
}

function createFrieze() {
    items.solutionModel.clear();
    items.answerModel.clear();
    items.tokensModel.clear();

    // Build random arrays of shapes and colors
    var randShapes = Object.keys(shapes);
    randShapes.shift();
    Core.shuffle(randShapes);
    var randColors = Object.keys(palette);
    Core.shuffle(randColors);
    // Build random tokens from data description
    var theTokens = [];
    var level = items.levels[items.currentLevel].subLevels[items.currentSubLevel];
    friezeSize = level.count;
    for (var i = 0; i < level.tokens.length; i++) {
        theTokens[i] = randShapes[level.tokens[i][0] - 1] + randColors[level.tokens[i][1] - 1] + tokenSizes[level.tokens[i][2] - 1];
    }
    // Insert theTokens into tokensModel
    for (i = 0; i < theTokens.length; i++) {
        items.tokensModel.append({ "content_": theTokens[i],
                                   "clickable_": true,
                                   "shown_": true,
                                   "animated_": false});
    }
    // Select a random pattern with patLength size or tokensModel's
    var pattern =  (items.levels[items.currentLevel].duplicate)
            ? tokenPatterns[level.patLength][Math.floor(Math.random() * tokenPatterns[level.patLength].length)]
            : noDupPatterns[level.patLength][Math.floor(Math.random() * noDupPatterns[level.patLength].length)];

    while (items.solutionModel.count < friezeSize) {  // Repeat pattern to fill model
        for (var j = 0; j < pattern.length; j++) {
            var tok = JSON.parse(JSON.stringify(items.tokensModel.get(pattern.charCodeAt(j) - 'A'.charCodeAt(0))));
            tok.shown_ = (items.solutionModel.count < items.levels[items.currentLevel].shown);
            tok.clickable_ = false;
            items.solutionModel.append(tok);
        }
    }
    while (items.solutionModel.count > friezeSize) {
        items.solutionModel.remove(friezeSize, 1);     // Remove last element while too long
    }
    items.tokensModel.shuffleModel()    // Shuffle tokens when solution is built
    for (i = 0; i < friezeSize; i++)
        items.answerModel.append({ "content_": emptyToken,
                                   "clickable_": false,
                                   "shown_": true,
                                   "animated_": false });
    items.currentAnswer = 0;
    items.currentToken = 0;
    items.solution.visible = true;
    items.tokens.visible = !items.levels[items.currentLevel].hidden;
    items.readyButton.enabled = items.levels[items.currentLevel].hidden;
}

function initShape(tokenItem) {
    var content = tokenItem.content;
    var svgText = (content[2] === "b") ? shapes[content[0]] : smallShapes[content[0]];
    tokenItem.image.source = svgHeader + svgText.replace(innerColor, palette[content[1]]).replace(outerColor, darkPalette[content[1]]);
    tokenItem.colorChar.source = (content[0] === "e") ? svgUrl + "empty.svg" : svgUrl + colorChars[content[1]];
}

function tokenClicked(idx, content) {
    if (items.currentAnswer === items.answerModel.count)
        return;
    items.currentToken = idx;
    items.animationToken.x = items.tokens.currentItem.x;    // Start position for animationToken
    items.animationToken.y = items.tokens.currentItem.y;
    items.animationToken.content = content;
    items.tokens.currentItem.opacity = 0.0;
    items.animationToken.state = "moveto";
    items.buttonsBlocked = true;
}

function cancelDrop() {
    if (items.currentAnswer > 0 && !items.buttonsBlocked) {
        items.currentAnswer--;
        items.answer.children[items.currentAnswer].state = "fade";
        items.buttonsBlocked = true;
    }
}

function checkResult() {
    items.buttonsBlocked = true;

    var ok = true;
    for (var i = 0 ; i < friezeSize; i++) {
        var sol = items.solutionModel.get(i);
        var ans = items.answerModel.get(i);
        if (sol.content_ !== ans.content_)
            ok = false;
    }
    if (ok) {
        items.solution.visible = true;
        items.currentSubLevel++;
        for (var j= 0; j < friezeSize; j++) {
            items.solutionModel.setProperty(j, "shown_", true);
        }
        items.goodAnswerSound.play();
        items.score.playWinAnimation();
    } else {
        items.badAnswerSound.play();
        items.errorRectangle.startAnimation();
        items.buttonsBlocked = false;
    }
}

function initLevel() {
    items.buttonsBlocked = false;
    numberOfLevel = items.levels.length;
    items.instructionItem.text = items.levels[items.currentLevel].title;
    items.subLevelCount = items.levels[items.currentLevel].subLevels.length;
    if (items.levels[items.currentLevel].shuffle)
        Core.shuffle(items.levels[items.currentLevel].subLevels);
    createFrieze();
}

function nextLevel() {
    items.score.stopWinAnimation();
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    items.currentSubLevel = 0;
    initLevel();
}

function previousLevel() {
    items.score.stopWinAnimation();
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    items.currentSubLevel = 0;
    initLevel();
}

function nextSubLevel() {
    items.errorRectangle.resetState();
    items.buttonsBlocked = false;
    if(items.currentSubLevel >= items.subLevelCount)
        items.bonus.good("smiley");
    else
        createFrieze();
}

function handleKeys(event) {
    if (items.buttonsBlocked)
        return
    switch (event.key) {
    case Qt.Key_Left:
        if (!items.readyButton.enabled)
            items.tokens.moveCurrentIndexLeft();
        break
    case Qt.Key_Right:
        if (!items.readyButton.enabled)
            items.tokens.moveCurrentIndexRight();
        break
    case Qt.Key_Up:
        if (!items.readyButton.enabled)
            items.tokens.moveCurrentIndexUp();
        break
    case Qt.Key_Down:
        if (!items.readyButton.enabled)
            items.tokens.moveCurrentIndexDown();
        break
    case Qt.Key_Space:
        if (!items.readyButton.enabled)
            tokenClicked(items.currentToken, items.tokens.currentItem.content);
        break
    case Qt.Key_Delete:
    case Qt.Key_Backspace:
        if (!items.readyButton.enabled)
            cancelDrop();
        break
    case Qt.Key_Enter:
    case Qt.Key_Return:
        if (items.currentAnswer === items.answerModel.count)
            checkResult();
        break
    case Qt.Key_Tab:
        if (items.levels[items.currentLevel].hidden)
            items.toggleReady();
        break
    }
}
