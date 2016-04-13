/* GCompris - mirrorgame.js
 *
 * Copyright (C) 2016 Shubham Nagaria shubhamrnagaria@gmail.com
 *
 * Authors:
 *  Shubham Nagaria shubhamrnagaria@gmail.com
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
                    for(var row = 0; row < 5;row++) {
                        for(var column = 0; column < 5; column++) {
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

function min(a,b)
{return (a<=b)?a:b;}

function max(a,b)
{return (a<=b)?b:a;}

function createLightgrid()
{
    for(var x = 0;x < items.rows; x++) {
         for(var y = 0;  y < items.columns; y++){
             for(var w = x+1; w < items.rows; w++){
                 for(var z = y+1; z < items.columns; z++){
                     if((x-w) === (y-z) && x!==w && y!==z)
                     {
                 var component = Qt.createComponent("Light-45.qml");
                 if (component.status === 1) {
                 Light[count++] = component.createObject(items.grid,{
                                                      "x" : min(y,z) * items.cellSize + items.cellSize/2+items.grid.spacing,
                                                      "y" : min(x,w) * items.cellSize + items.cellSize/2+items.grid.spacing,
                                                       "height" : mod(y,z)*items.cellSize*1.414,
                                                       "visible" : false,
                                                        "uniquename" : "lightpath" +x+y+w+z
                                                      }); }}

}}}}

    for( x = 0;x < items.rows; x++) {
         for( y = 1;  y < items.columns; y++){
             for( w = x+1; w < items.rows; w++){
                 for( z = y-1; z >=0; z--){

                    if((x-w) === (z-y) && x!==w && y!==z )
                     {
                  component = Qt.createComponent("Light45.qml");
                 if (component.status === 1) {
                 Light[count++] = component.createObject(items.grid,{
                                                      "x" : max(y,z) * items.cellSize + items.cellSize/2+items.grid.spacing,
                                                      "y" : min(x,w) * items.cellSize + items.cellSize/2+items.grid.spacing,
                                                       "height" : mod(y,z)*items.cellSize*1.414,
                                                       "visible" : false,
                                                        "uniquename" : "lightpath" +x+y+w+z
                                                      }); }}



                 }}}}

}
function createMirror(column, row) {

         var component = Qt.createComponent("Mirror.qml");
    if (component.status === 1) {
         mirror[row][column] = component.createObject(items.grid,
                                                   {"x":column * items.cellSize+items.grid.spacing,
                                                    "y":row * items.cellSize+2*items.grid.spacing,
                                                    "width":items.cellSize,
                                                    "height":items.cellSize
                                                   })

    } else {
        console.log("error loading block component");
        console.log(component.errorString());
        return false;
    }
    return true;
}
function createTorch(column, row) {

         var component = Qt.createComponent("Torch.qml");
    if (component.status === 1) {
         torch = component.createObject(items.grid,
                                                   {"x":column * items.cellSize+items.grid.spacing,
                                                    "y":row * items.cellSize+items.grid.spacing,
                                                    "width":items.cellSize,
                                                    "height":items.cellSize
                                                   })

    } else {
        console.log("error loading block component");
        console.log(component.errorString());
        return false;
    }
    return true;
}

function createBulb(column, row) {

         var component = Qt.createComponent("BulbOn.qml");
    if (component.status === 1) {
         bulbon[num] = component.createObject(items.grid,
                                                   {"x":column * items.cellSize+items.grid.spacing,
                                                    "y":row * items.cellSize+items.grid.spacing,
                                                    "width":items.cellSize,
                                                    "height":items.cellSize,
                                                    "uniquename" : "bulbon" + row+column,
                                                     "visible":false
                                                   });

    }
    component = Qt.createComponent("BulbOff.qml");
        if (component.status === 1) {
             bulboff[num++] = component.createObject(items.grid,
                                                       {"x":column * items.cellSize+items.grid.spacing,
                                                        "y":row * items.cellSize+items.grid.spacing,
                                                        "width":items.cellSize,
                                                        "height":items.cellSize,
                                                        "uniquename" : "bulboff" + row+column
                                                       });
        }

    return true;
}
function checkLightPath()
{var i,j,k


for(var z = 0;z<numberofmirrors;z++){
  for(i=0;i<5;i++) {
    for(j=0;j<5;j++) {
    var lightavailable = false;
    if(mirror[i][j])
    {
        for( var row = 0; row < 5; row++){
             for( var column = 0; column < 5; column++){
                 for(k = 0; k < count; k++) {

             if((Light[k].uniquename === "lightpath"+row+column+i+j ||
                     Light[k].uniquename === "lightpath"+i+j+row+column)
                     && Light[k].visible ===true)
             {lightavailable = true;

             break;}}
                 if(lightavailable)break;}
             if(lightavailable)break;}
        if(!lightavailable)continue;

        for( row = 0; row < 5; row++){
            for( column = 0; column < 5; column++){
                for(k = 0; k < count; k++) {

            if(Light[k].uniquename === "lightpath"+row+column+i+j && Light[k].visible ===true)
            {
                for(var row1 = 0; row1 < 5; row1++){
                    for(var column1 = 0; column1 < 5; column1++){
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
                for(row1 = 0; row1 < 5; row1++){
                    for(column1 = 0; column1 < 5; column1++){
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
            for(row = 0; row < 5; row++){var done = 0
                for(column = 0; column < 5; column++){
                    for(k = 0; k < count; k++) {

              if(Light[k].uniquename === "lightpath"+row+column+i+j && Light[k].visible === true
                  && row<i && column>j)
                {
                 for(var a =0; a < 5;a++) {
                     for(var b = 0; b < 5; b++) {
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
                  for( a =0; a < 5;a++) {
                      for( b = 0; b < 5; b++) {
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
              for(row = 0; row < 5; row++){
                  for(column = 0; column < 5; column++){
                      for(k = 0; k < count; k++) {


                 if(Light[k].uniquename === "lightpath"+i+j+row+column && Light[k].visible === true)
                {
                    for(  a =0; a < 5;a++) {done = 0
                        for(  b = 0; b < 5; b++) {
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

              for(row = 0; row < 5; row++){ done = 0
                  for(column = 0; column < 5; column++){
                      for(k = 0; k < count; k++) {
                if(Light[k].uniquename === "lightpath"+row+column+i+j && Light[k].visible === true
                        && row<i && column<j)
                  {
                   for( a =0; a < 5;a++) {
                       for( b = 0; b < 5; b++) {
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
                    for( a =0; a < 5;a++) {
                        for( b = 0; b < 5; b++) {
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
              for(row = 0; row < 5; row++){done = 0
                  for(column = 0; column < 5; column++){
                      for(k = 0; k < count; k++) {


                 if(Light[k].uniquename === "lightpath"+row+column+i+j && Light[k].visible === true)
                {
                    for( a =0; a < 5;a++) {
                        for( b = 0; b < 5; b++) {
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
    for( var a =0; a < 5;a++) {
        for( var b = 0; b < 5; b++) {
           for( var c = 0; c < 5 ; c++) {
               for(var d = 0;d < 5; d++){
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

   currLight = new Array(5)
   for(i=0;i<5;i++)
       currLight[i] = new Array(5)
   for(i=0;i<5;i++)
       for(j=0;j<5;j++)
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
