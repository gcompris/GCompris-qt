/* GCompris - guesscount.js
 *
 * Copyright (C) 2016 RAHUL YADAV <rahulyadav170923@gmail.com>
 *
 * Authors:
 *   <PASCAL GEORGES> (V13.11)
 *   "RAHUL YADAV" <rahulyadav170923@gmail.com> (Qt Quick port)
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
var url = "qrc:/gcompris/src/activities/guesscount/resource/"
var currentLevel = 0
var numberOfLevel = 4
var items
var images = [
            ["plus.svg","+"],
            ["minus.svg","-"],
            ["div.svg","/"],
            ["multiply.svg","*"],
        ]
var dataset=[
            {
                'level': 1,
                "data": {
                    "questions":"3",
                    "numbers":[
                        [[1,2],3],
                        [[3,1],3],
                        [[9,4],5]
                    ]
                    
                }
            },
            {
                'level': 2,
                "data": {
                    "questions":"3",
                    "numbers":[
                        [[6,7],42],
                        [[8,4],2],
                        [[10,2,2],10]
                    ]
                    
                }
            },
            {
                'level': 3,
                "data": {
                    "questions":"3",
                    "numbers":[
                        [[11,7],77],
                        [[8,16,4],2],
                        [[10,2,2,3],7]
                    ]
                    
                }
            },
            {
                'level': 4,
                "data": {
                    "questions":"3",
                    "numbers":[
                        [[9,7],63],
                        [[4,2,9],17],
                        [[15,3,2,3],21]
                    ]
                    
                }
            }
            
        ]

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    items.operators=shuffle(images)
    items.total_questions=dataset[currentLevel]["data"]["questions"]
    items.question_no=1
    items.data=dataset[currentLevel]["data"]["numbers"][items.question_no-1][0]
    items.guesscount=dataset[currentLevel]["data"]["numbers"][items.question_no-1][1]
    items.row5.visible=visibility(2)
    items.row6.visible=visibility(3)
    items.row5.enabled=false
    items.row6.enabled=false
    var no_of_rows=dataset[currentLevel]["data"]["numbers"][items.question_no-1][0].length-1
    items.no_of_rows=no_of_rows
    if(no_of_rows==1)
    {
        items.row4.children[5].color="orange"
    }
    else if(no_of_rows==2)
    {
        items.row4.children[5].color="yellow"
        items.row5.children[5].color="orange"
    }
    else
    {
        items.row4.children[5].color="yellow"
        items.row5.children[5].color="lightblue"
        items.row6.children[5].color="orange"
    }
    
}

function run() {
    
    items.question_no=items.question_no+1
    items.operators=shuffle(images)
    items.data=dataset[currentLevel]["data"]["numbers"][items.question_no-1][0]
    items.guesscount=dataset[currentLevel]["data"]["numbers"][items.question_no-1][1]
    items.row5.visible=visibility(2)
    items.row6.visible=visibility(3)
    items.row5.enabled=false
    items.row6.enabled=false
    var no_of_rows=dataset[currentLevel]["data"]["numbers"][items.question_no-1][0].length-1
    items.no_of_rows=no_of_rows
    if(no_of_rows==1)
    {
        items.row4.children[5].color="orange"
    }
    else if(no_of_rows==2)
    {
        items.row4.children[5].color="yellow"
        items.row5.children[5].color="orange"
    }
    else
    {
        items.row4.children[5].color="yellow"
        items.row5.children[5].color="lightblue"
        items.row6.children[5].color="orange"
    }
    
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel )
    {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0)
    {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}


function decidekeys(index,row){
    var keys=[]
    if(row==1)
    {
        if(index==1)
            keys=["operator"]
        else
            keys=["number"]
        return keys
    }
    else
    {
        if(index==0)
            keys=["operator"]
        else
            keys=["number"]
        return keys
    }
    
}

function visibility(row){
    if(row<dataset[currentLevel]["data"]["numbers"][items.question_no-1][0].length)
        return true
    return false
}

function shuffle(images){
    var temp=images[0]
    images[0]=images[1]
    images[1]=images[2]
    images[2]=images[3]
    images[3]=temp
    return images
}

