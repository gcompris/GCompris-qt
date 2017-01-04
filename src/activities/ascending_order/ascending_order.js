/* GCompris - ascending_order.js
 *
 * Copyright (C) 2016 Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com> (Qt Quick port)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
.pragma library
.import QtQuick 2.0 as Quick

var currentLevel = 0
var numberOfLevel = 4
var items

// num[] will contain the random numbers
var num=[]
var hash=[] // hash[i]=1 => ith grid is already pressed. =0 => it is not yet pressed
var entered=[] // the numbers entered by the user

var initColor = "#0000FF"
var visitedColor="#7CFC00"

var numEntered // the number of numbers entered by the user

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    numEntered=0
    items.ansText.text=""
    initGrids()
}

function initGrids() {
    items.boxes.model = 2*(items.bar.level)+1

    generateRandomNumbers()

    hash=[]
    entered=[]
    for(var i=0;i<items.boxes.model;i++) {
        items.boxes.itemAt(i).imageX=num[i]
        items.boxes.itemAt(i).color=initColor
        hash[i]=0
    }
}

function generateRandomNumbers() {
    var n=items.boxes.model
    // generate n random numbers and store it in num[]
    num=[]
    var upperBound = (items.bar.level)*100
    while(num.length < n) {
        var randomNumber=Math.ceil(Math.random()*upperBound)
        if(num.indexOf(randomNumber) > -1) {
            continue;
        }
        num[num.length]=randomNumber
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

function check(currentNum) {
    for(var i=0;i<items.boxes.model;i++) {
        if(items.boxes.itemAt(i).imageX ==currentNum) {
            if(hash[i]===1) {
                continue
            } else {

                items.boxes.itemAt(i).color=visitedColor
                hash[i]=1
                entered[numEntered++]=currentNum
                if(numEntered===num.length) {
                    items.ansText.text=items.ansText.text.concat(currentNum.toString(), " .")
                    result()
                } else {
                    items.ansText.text=items.ansText.text.concat(currentNum.toString(), ", ")
                }
            }
        }
    }
}

function result() {
    for(var i=0;i<entered.length-1;i++) {
        if(Number(entered[i])>Number(entered[i+1])) {
            //WRONG answer
            items.ok.visible=true
            items.ansText.text=items.ansText.text.concat("\n")
            printSorted()
            items.bonus.bad("lion")
            return
        }
    }
    // CORRECT answer
    items.bonus.good("lion")
}

function printSorted() {
    for(var i=0;i<entered.length-1;i++) {
        for(var j=0;j<entered.length-i-1;j++) {
            if(Number(entered[j]>Number(entered[j+1]))) {
                var temp=entered[j+1];
                entered[j+1]=entered[j]
                entered[j]=temp
            }
        }
    }
    for(i=0;i<entered.length;i++) {
        if(i!=entered.length-1) {
            items.ansText.text=items.ansText.text.concat(entered[i], ", ");
        } else {
            items.ansText.text=items.ansText.text.concat(entered[i], " .");
        }
    }
}

function retry() {
    items.ok.visible=false
    initLevel()
}
