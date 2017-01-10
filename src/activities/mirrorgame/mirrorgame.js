/* GCompris - mirrorgame.js
 *
 * Copyright (C) 2016 Shubham Nagaria <shubhamrnagaria@gmail.com>
 *
 * Authors:
 *  Shubham Nagaria <shubhamrnagaria@gmail.com>
 *
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
.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core
var data = [// 1 is for light source,2 is for mirror and 3 is for bulb
              [//level1
             [1,0,0,0,3],
             [0,0,0,0,0],
             [0,0,2,0,0],
             [0,0,0,0,0],
             [0,0,0,0,0]
              ]
            ,
            [//level2
             [0,0,0,0,0],
             [0,1,0,0,0],
             [0,0,2,0,0],
             [0,2,0,0,0],
             [0,0,3,0,0]
            ],
            [//level3
             [1,0,3,0,0],
             [0,0,0,0,0],
             [0,0,0,0,2],
             [0,0,0,2,0],
             [0,0,0,0,0]
            ],
            [//level4
             [0,0,1,0,0],
             [0,0,0,2,0],
             [0,0,2,0,0],
             [0,0,0,2,0],
             [0,0,3,0,0]
            ],
            [//level5
             [0,0,0,0,0],
             [1,0,0,0,3],
             [0,2,0,0,0],
             [2,0,0,0,0],
             [0,2,0,0,0]
            ]
                    ]
var currentLevel = 0
var numberOfLevel = 5
var arr
var items
var count = 0
var num = 0
var numberofmirrors = 0
var i,j
var Light
var currLight
var mirror
var torch
var bulbon
var bulboff
var component1 = Qt.createComponent("Light-45.qml");
var component2 = Qt.createComponent("Light45.qml");
var component3 = Qt.createComponent("Mirror.qml");
var component4 = Qt.createComponent("Torch.qml");
var component5 = Qt.createComponent("BulbOn.qml");
var component6 = Qt.createComponent("BulbOff.qml");

function start(items_) {
    items = items_
    currentLevel = 0
     Light = new Array
    items.ok.visible = false;


    createLightgrid()
    initLevel()

}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
            arr = data[currentLevel]
    currLight = new Array
    for(i=0;i<items.rows;i++)
        currLight[i] = new Array

    for(i=0;i<items.rows;i++)
        for(j=0;j<items.columns;j++)
        currLight[i][j] = new Array

    mirror = new Array
    for(i=0;i<items.rows;i++)
        mirror[i] = new Array


    bulbon = new Array
    bulboff = new Array
    items.ok.visible = false;
    for(var y = 0;  y < items.rows; y++) {
        for(var x = 0;  x < items.columns; x++) {

            items.pieces.append({'stateTemp': "invisible"})
            if(arr[y][x]===1)
            {createTorch(x,y);
                for(var k = 0;k < count;k++) {
                    for(var row = 0; row < items.rows;row++) {
                        for(var column = 0; column < items.columns; column++) {
                    if(Light[k].uniquename === "lightpath"+y+x+row+column)
                        Light[k].visible =true;
                        }
                     }
                }
            }
            if(arr[y][x]===2)
            {createMirror(x,y);numberofmirrors++;}
            if(arr[y][x]===3)
            {createBulb(x,y);}

            }

        }
    checkLightPath();
    }

function mod(a,b)
{   return (a>=b)? (a-b):(b-a);}


function createLightgrid()
{
    for(var x = 0;x < items.rows; x++) {
         for(var y = 0;  y < items.columns; y++){
             for(var w = x+1; w < items.rows; w++){
                 for(var z = y+1; z < items.columns; z++){
                     if((x-w) === (y-z) && x!==w && y!==z)
                     {

                 if (component1.status === 1) {
                 Light[count++] = component1.createObject(items.grid,{
                                                      "x" : Math.min(y,z) * items.cellSize + items.cellSize/2+items.grid.spacing,
                                                      "y" : Math.min(x,w) * items.cellSize + items.cellSize/2+items.grid.spacing,
                                                       "height" : mod(y,z)*items.cellSize*1.414,
                                                       "visible" : false,
                                                        "uniquename" : "lightpath" +x+y+w+z
                                                      }); }}

}

               for( z = y-1; z >=0; z--){

                    if((x-w) === (z-y) && x!==w && y!==z )
                     {

                 if (component2.status === 1) {
                 Light[count++] = component2.createObject(items.grid,{
                                                      "x" : Math.max(y,z) * items.cellSize + items.cellSize/2+items.grid.spacing,
                                                      "y" : Math.min(x,w) * items.cellSize + items.cellSize/2+items.grid.spacing,
                                                       "height" : mod(y,z)*items.cellSize*1.414,
                                                       "visible" : false,
                                                        "uniquename" : "lightpath" +x+y+w+z
                                                      }); }}



                 }}}}

}
function createMirror(column, row) {


    if (component3.status === 1) {
         mirror[row][column] = component3.createObject(items.grid,
                                                   {"x":column * items.cellSize+items.grid.spacing,
                                                    "y":row * items.cellSize+2*items.grid.spacing,
                                                    "width":items.cellSize,
                                                    "height":items.cellSize
                                                   })

    } else {
        console.log("error loading block component");
        console.log(component3.errorString());
        return false;
    }
    return true;
}
function createTorch(column, row) {


    if (component4.status === 1) {
         torch = component4.createObject(items.grid,
                                                   {"x":column * items.cellSize+items.grid.spacing,
                                                    "y":row * items.cellSize+items.grid.spacing,
                                                    "width":items.cellSize,
                                                    "height":items.cellSize
                                                   })

    } else {
        console.log("error loading block component");
        console.log(component4.errorString());
        return false;
    }
    return true;
}

function createBulb(column, row) {

    if (component5.status === 1) {
         bulbon[num] = component5.createObject(items.grid,{"x":column * items.cellSize+items.grid.spacing,
                                                    "y":row * items.cellSize+items.grid.spacing,
                                                    "width":items.cellSize,
                                                    "height":items.cellSize,
                                                    "uniquename" : "bulbon" + row+column,
                                                    "visible":false
                                                   });

    }
        if (component6.status === 1) {
             bulboff[num++] = component6.createObject(items.grid,{"x":column * items.cellSize+items.grid.spacing,
                                                        "y":row * items.cellSize+items.grid.spacing,
                                                        "width":items.cellSize,
                                                        "height":items.cellSize,
                                                        "uniquename" : "bulboff" + row+column
                                                       });
        }

    return true;
}
function checkLightPath()
{   var i,j,k

for(var z = 0;z<numberofmirrors;z++){
  for(i=0;i<items.rows;i++) {
    for(j=0;j<items.columns;j++) {
    var lightavailable = false;
    if(mirror[i][j])
    {
        for( var row = 0; row < items.rows; row++){
             for( var column = 0; column < items.columns; column++){
                 for(k = 0; k < count; k++) {

             if((Light[k].uniquename === "lightpath"+row+column+i+j ||
                     Light[k].uniquename === "lightpath"+i+j+row+column)
                     && Light[k].visible ===true)
             {lightavailable = true;

             break;}}
                 if(lightavailable)break;}
             if(lightavailable)break;}
        if(!lightavailable)continue;

        for( row = 0; row < items.rows; row++){
            for( column = 0; column < items.columns; column++){
                for(k = 0; k < count; k++) {

            if(Light[k].uniquename === "lightpath"+row+column+i+j && Light[k].visible ===true)
            {
                for(var row1 = 0; row1 < items.rows; row1++){
                    for(var column1 = 0; column1 < items.columns; column1++){
                        for(var k1 = 0; k1 < count; k1++) {
                            if(Light[k1].uniquename === "lightpath"+row+column+row1+column1 &&
                                    Light[k1].uniquename !== "lightpath"+row+column+i+j &&
                                    Light[k1].visible===true)
                            {
                                Light[k1].visible = false;
                            }
                        }}}
            }
            else if(Light[k].uniquename === "lightpath"+i+j+row+column && Light[k].visible ===true)
            {
                for(row1 = 0; row1 < items.rows; row1++){
                    for(column1 = 0; column1 < items.columns; column1++){
                        for(k1 = 0; k1 < count; k1++) {
                            if(Light[k1].uniquename === "lightpath"+row+column+row1+column1 &&
                                    Light[k1].uniquename !== "lightpath"+row+column+i+j &&
                                    Light[k1].visible===true)
                            {
                                Light[k1].visible = false;
                            }
                        }}}
            }
        }}}

  switch(mirror[i][j].pos)
        {
            case 1:
            while(currLight[i][j].length!==0)
            {
                var x = currLight[i][j].pop()
                x.visible = false
            }
            for(row = 0; row < items.rows; row++){var done = 0
                for(column = 0; column < items.columns; column++){
                    for(k = 0; k < count; k++) {

              if(Light[k].uniquename === "lightpath"+row+column+i+j && Light[k].visible === true
                  && row<i && column>j)
                {
                 for(var a =0; a < items.rows;a++) {
                     for(var b = 0; b < items.columns; b++) {
                        for(var c = 0; c < count ; c++) {
                     if(Light[c].uniquename === "lightpath"+i+j+a+b && i<a && j<b)
                        {
                          Light[c].visible = true
                         currLight[i][j].push(Light[c])
                         done = 1
                        }
                 }}}}
              else if(Light[k].uniquename === "lightpath"+i+j+row+column && Light[k].visible === true
                      && row>i && column>j)
              {
                  for( a =0; a < items.rows;a++) {
                      for( b = 0; b < items.columns; b++) {
                         for( c = 0; c < count ; c++) {
                      if(Light[c].uniquename === "lightpath"+a+b+i+j && i<a && j>b)
                         {
                          Light[c].visible = true;
                         currLight[i][j].push(Light[c])
                          done = 1
                      }
                  }}}


              }}if(done)break}if(done)break}
              break

          case 2:
              while(currLight[i][j].length!==0)
              {
                  var x = currLight[i][j].pop()
                  x.visible = false
              }
              for(row = 0; row < items.rows; row++){
                  for(column = 0; column < items.columns; column++){
                      for(k = 0; k < count; k++) {


                 if(Light[k].uniquename === "lightpath"+i+j+row+column && Light[k].visible === true)
                {
                    for(  a =0; a < items.rows;a++) {done = 0
                        for(  b = 0; b < items.columns; b++) {
                           for(  c = 0; c < count ; c++) {
                        if(Light[c].uniquename === "lightpath"+a+b+i+j && row<i && column>j
                                && a>i && b>j)
                           {
                            Light[c].visible = true;
                            currLight[i][j].push(Light[c])
                            done = 1
                        }
                        else if(Light[c].uniquename === "lightpath"+a+b+i+j && row>i && column>j
                                && a<i && b>j)
                           {
                            Light[c].visible = true;
                            currLight[i][j].push(Light[c])
                            done = 1
                        }
                }}}


                }
                }if(done)break}if(done)break}
                break
          case 3:
              while(currLight[i][j].length!==0)
              {
                  var x = currLight[i][j].pop()
                  x.visible = false
              }

              for(row = 0; row < items.rows; row++){ done = 0
                  for(column = 0; column < items.columns; column++){
                      for(k = 0; k < count; k++) {
                if(Light[k].uniquename === "lightpath"+row+column+i+j && Light[k].visible === true
                        && row<i && column<j)
                  {
                   for( a =0; a < items.rows;a++) {
                       for( b = 0; b < items.columns; b++) {
                          for( c = 0; c < count ; c++) {
                       if(Light[c].uniquename === "lightpath"+i+j+a+b && a>i && j>b)
                          {
                           Light[c].visible = true
                           done=1
                           currLight[i][j].push(Light[c])}
                   }}}}
                else if(Light[k].uniquename === "lightpath"+i+j+row+column && Light[k].visible === true
                        && row>i && column<j)
                {
                    for( a =0; a < items.rows;a++) {
                        for( b = 0; b < items.columns; b++) {
                           for( c = 0; c < count ; c++) {
                        if(Light[c].uniquename === "lightpath"+a+b+i+j && i>a && j>b)
                           {
                            Light[c].visible = true;done=1
                            currLight[i][j].push(Light[c])}
                    }}}


                }}if(done)break;}if(done)break;}
                break
          case 4:
              while(currLight[i][j].length!==0)
              {
                  var x = currLight[i][j].pop()
                  x.visible = false
              }
              for(row = 0; row < items.rows; row++){done = 0
                  for(column = 0; column < items.columns; column++){
                      for(k = 0; k < count; k++) {


                 if(Light[k].uniquename === "lightpath"+row+column+i+j && Light[k].visible === true)
                {
                    for( a =0; a < items.rows;a++) {
                        for( b = 0; b < items.columns; b++) {
                           for( c = 0; c < count ; c++) {
                        if(Light[c].uniquename === "lightpath"+a+b+i+j && row<i && column<j
                                && a<i && b>j)
                           {
                            Light[c].visible = true;
                            currLight[i][j].push(Light[c])
                          }
                        else if(Light[c].uniquename === "lightpath"+a+b+i+j && row>i && column<j
                                && a<i && b<j)
                           {
                            Light[c].visible = true;
                            currLight[i][j].push(Light[c])
                        }
                }}}
                }
                }if(done)break}if(done)break}
                break
    }
    }

}}
}
checkAnswer();
}
function checkAnswer()
{
    for( var a =0; a < items.rows;a++) {
        for( var b = 0; b < items.columns; b++) {
           for( var c = 0; c < items.rows ; c++) {
               for(var d = 0;d < items.columns; d++){
                   for(var e = 0;e < count;e++){
                    for(var f = 0;f < num;f++){
                        if(bulboff[f].uniquename === "bulboff"+a+b &&
                                (Light[e].uniquename === "lightpath"+a+b+c+d||
                                 Light[e].uniquename === "lightpath"+c+d+a+b)
                               &&
                                Light[e].visible === true)
                        {
                            bulboff[f].visible = false;
                            bulbon[f].visible = true;
                            items.ok.visible = true;
                            break
                        }
                 }}
               }
           }
        }
     }
 }
function destroyEverything()
{
   for(var a = 0; a < count ; a++)
   Light[a].visible = false;

   currLight = new Array(items.rows)
   for(i=0;i<items.columns;i++)
       currLight[i] = new Array(items.columns)
   for(i=0;i<items.rows;i++)
       for(j=0;j<items.columns;j++)
       currLight[i][j] = new Array

   for(i = 0;i<num;i++)
   {bulbon[i].destroy();bulbon[i] = 0}
   for(i = 0;i<num;i++)
   {bulboff[i].destroy();bulboff[i] = 0}
   for (i = 0;i < items.rows; i++)
       for(j = 0;j < items.columns; j++){
           if(mirror[i][j])
           { mirror[i][j].destroy();}
           mirror[i][j]=0;
       }
   torch.destroy();
   num = 0;
}
function win() {
    items.bonus.good("tux")
}
function nextLevel() {
    destroyEverything();
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    destroyEverything();
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}
