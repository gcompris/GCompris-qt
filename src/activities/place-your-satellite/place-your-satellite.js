/* GCompris - place-your-satellite.js
*
* Copyright (C) 2014 JB Butet
*
* Authors:
*   Matilda Bernard (seah4291@gmail.com) (GTK+ version)
*   JB Butet <ashashiwa@gmail.com> (Qt Quick port)
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

var planetDataset = [
            {
                'name': qsTr('Earth'),
                'mass': 6e24, // in kg
                'diameter': '12800000', // in meters
                'imgName': 'earth.svg'
            },
            {
                'name': qsTr('Saturn'),
                'mass': 6e26,
                'diameter': '116464000',
                'imgName': 'saturn.svg'
            },
            {
                'name': qsTr('Jupiter'),
                'mass': 2e27,
                'diameter': '139822000',
                'imgName': 'jupiter.svg'
            },
            {
                'name': qsTr('Sun'),
                'mass': 2e30,
                'diameter': '1391684000',
                'imgName': 'sun.svg'
            },
            {
                'name': qsTr('67PComet'),
                'mass': 1e13,
                'diameter': '4000',
                'imgName': '67PComet.svg'
            }
        ]

var satelliteDataset = [
            ['InternationalSpaceShip', '400000'],
            ['Rosetta', '3000'],
            ['Hubble','11000']
        ]

var url = "qrc:/gcompris/src/activities/place-your-satellite/"

var currentLevel = 0
var numberOfLevel = planetDataset.length
var items

var massObjectMass = planetDataset[0].mass

var satObjectName = satelliteDataset[0][0]
var satObjectMass = satelliteDataset[0][1]
var satObjectDiameter = satelliteDataset[0][2]

var distance
var speedX, speedY
var position, speed, points
var t, dt, listPoints = [], listPointsPix
var y0 = []
var x0 = []

function start(items_) {
    items = items_
    currentLevel = 0


    items.satList.clear()
    //feed left Menu : satellite Menu
    for (var i = 0; i < satelliteDataset.length; i++) {
        items.satList.append({
                                 name: satelliteDataset[i][0],
                                 image: satelliteDataset[i][1]
                             })
    }

    initLevel()
}

function stop() {}

function initLevel() {
    items.bar.level = currentLevel + 1
    massObjectMass = planetDataset[currentLevel].mass
}

function calcparameters() {
    // distance in m
    distance = items.slidDistance.value

    // X and Y speed composantes
    speedX = items.slidSpeed.value*Math.cos(items.arrowSatAngle/180*Math.PI)
    speedY = items.slidSpeed.value*Math.sin(items.arrowSatAngle/180*Math.PI)

    // G
    var G = 0.0000000000667259

    // Energy calculation
    var Ec_mass = 0.5*(Math.pow(speedX, 2) + Math.pow(speedY, 2))
    var Ep_mass = -massObjectMass*G/distance

    var Em_mass = Ec_mass + Ep_mass
    if (Em_mass >= 0) {
        // too much energy. It can't satelize
        items.isEllipse = false

        items.instructions.text = qsTr("It's too fast! Satellite won't never come back!")
        t = 2*Math.PI*Math.sqrt((Math.pow(distance, 3)/massObjectMass/G))

        dt = t / 2000
    } else {
        items.isEllipse = true

        //   Semi Major Axis "a" : Em = -k/2a with ellipse thus a = -k/2Em
        var a = -massObjectMass*G/2/Em_mass

        //   Period with 3rd Kepler's Law  T²=4pi²/MG*a³
        t = 2*Math.PI*Math.sqrt((Math.pow(a,3)/massObjectMass/G))
        items.period = t

        //nb of point to calcul. 2000 seems good. 100 is not enough
        dt = t / 2000
    }

    position = [distance, 0, 0]  //x, y,z
    speed = [speedX, speedY, 0.0]  //vx, vy, vz
    calcul()
}

//calcul 6 components derivative function : vx,vy,vz, ax, ay, az
//In: 6-uplet position and speed: x,y,z,vx,vy,vz
//Out: 6-uplet speed and acceleration: vx,vy,vz, ax, ay, az
function derivs(x,t) {
    var g = gravField(x.slice(0,3), [0,0,0], massObjectMass)

    //console.log('g', g,x,t)
    return [x[3],                // speed x
            x[4],                // speed y
            x[5],                // speed z
            g[0],                // acceleration x
            g[1],                // acceleration y
            g[2]]                // acceleration z
}

//    RK4 derivation calculation implementation
//    In :
//    y0 : 6-uplet position and speed : x,y,z,vx,vy,vz
//    t : List of dates of points.
//
//    Out :
//      List of 6-uplet position and speed : x,y,z,vx,vy,vz
function rk4(y0, t) {
    var yout = []
    yout[0] = y0

    for (var i = 0; i < t.length-1; i ++) {
        var thist = t[i]

        var dt = t[i+1] - thist
        var dt2 = dt/2.0
        y0 = yout[i]

        var k1 = derivs(y0, thist)

        var k1add = []
        var k2add = []
        var k3add = []
        var k4add = []
        for (var j = 0; j < 6; ++j) {
            k1add[j] = y0[j] + dt2*k1[j]
        }

        var k2 = derivs(k1add, thist+dt2)
        for (var j = 0; j < 6; ++j) {
            k2add[j] = y0[j] + dt2*k2[j]
        }

        var k3 = derivs(k2add, thist+dt2)
        for (var j = 0; j < 6; ++j) {
            k3add[j]  = y0[j] + dt2*k3[j]
        }

        var k4 = derivs(k3add, thist+dt)
        yout[i+1] = []
        for (var j = 0; j < 6; ++j) {
            yout[i+1][j] = y0[j] + dt/6.0*(k1[j] + 2*k2[j] + 2*k3[j] + k4[j])
        }
    }
    return yout
}

//This function takes a list of 6-uplets, with [x,y,z,vx,vy,vz] coordinates
//It transforms it in a 2D-Vector to be drawn, with coordinates in pixels.
function extractXY(yout) {
    listPoints = []
    listPointsPix = []
    //we draw only one point over 8
    for (var j = 0; j < points.length/8; ++j) {
        listPoints[j] = points[j*8].slice(0, 2)
        listPointsPix[j] = [items.pixPerMeter*listPoints[j][0],
                            items.pixPerMeter*listPoints[j][1]]
    }
    items.trajecCanvas.requestPaint()
}

//launch RK4 calculation with all points.
// Compute "points", list of 6-upplets.
function calcul() {
    var listT = []
    for (var i = 0; i < 2000; ++i) {
        listT[i] = i*dt
    }
    y0 = position.concat(speed)

    points = rk4(y0, listT)
    extractXY(points)
}

//return 3d gravitationnal field at a position x by a object positionned at x0.
function gravField(x, x0, m) {
    var xx0 = x[0]-x0[0];
    var xx1 = x[1]-x0[1];
    var xx2 = x[2]-x0[2];
    var field = Math.pow(xx0*xx0 + xx1*xx1 + xx2*xx2, 1.5)

    return  [
                -0.0000000000667*m*xx0 / field,
                -0.0000000000667*m*xx1 / field,
                -0.0000000000667*m*xx2 / field
            ]
}

function satChanged(satNb) {
    satObjectName = satelliteDataset[satNb][0]
    satObjectMass = satelliteDataset[satNb][1]
    satObjectDiameter = satelliteDataset[satNb][2]
}

function nextLevel() {
    if (numberOfLevel <= ++currentLevel) {
        currentLevel = 0
    }
    initLevel()
}

function previousLevel() {
    if (--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel()
}

function restartLevel() {
    initLevel();
}
