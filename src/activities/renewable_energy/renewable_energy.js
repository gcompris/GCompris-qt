/* GCompris - renewable_energy.js
 *
 * Copyright (C) 2015 Sagar Chand Agarwal <atomsagar@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Sagar Chand Agarwal <atomsagar@gmail.com> (Qt Quick port)
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
var numberOfLevel = 3
var items
var power = 0
var count = 0
var pow
var voltage = 0
var solar
var click = false
var tux_meter
var tuxreached = false
var scene = false
var panel_activate = false
var stepdown_info

function start(items_,pow_,solar_,tux_meter_,stepdown_info_) {
    items = items_
    currentLevel = 0
    initLevel()
    pow = pow_
    solar = solar_
    panel_activate= false
    tux_meter = tux_meter_
    tux_meter.visible = false
    tuxreached = false
    stepdown_info = stepdown_info_
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    items.background.initiate()
    power = 0
    count = 0
    voltage = 0
    scene = false
    panel_activate = false
    click = false
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0 ) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}

function win() {
    items.bonus.good("flower")
}

function add(power_) {
    power = power + power_
}

function volt(voltage_) {
    voltage = voltage + voltage_
}

function consume(count_) {
    count = count + count_
}


function update() {
    pow.text = "%1 W".arg(voltage)
    stepdown_info.text = "%1 W".arg(count)
}

function verify() {
    if(power < count) {
        items.background.reset()
    }
}

function paneloff() {
    solar.source = ""
    solar.source = "Solar.qml"
    if(click == true) {
        add(-400)
        volt(-400)
        update()
        verify()
        click = false
    }
}

function panel() {
    panel_activate = true
}

function showtuxmeter() {
    if(tuxreached == true)
    {
        tux_meter.visible = true
    }
}

function sceneload(scene_) {
    scene = scene_
    if(scene == false) {
        items.daysky.source = "resource/sky.svg"
    }
    else {
        items.daysky.source = "../intro_gravity/resource/background.svg"
    }
}
