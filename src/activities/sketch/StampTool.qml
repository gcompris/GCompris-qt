/* GCompris - StampTool.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick

Item {
    id: stampTool
    property alias selectedMode: stampTool
    readonly property bool usePositionChanged: true
    property int selectedStampIndex: 0

    property real toolOpacity: 1
    readonly property real defaultToolOpacity: 1
    property int toolRotation: 0
    readonly property int defaultToolRotation: 0
    readonly property int maxToolRotation: 360
    readonly property int rotationSliderStepSize: 15
    property int toolSize: 200
    readonly property int defaultToolSize: 200
    readonly property int minToolSize: 20
    readonly property int maxToolSize: 500
    readonly property int sizeSliderStepSize: 10
    readonly property real actualToolSize: toolSize / items.devicePixelRatio
    property bool toolMirror: false

    readonly property list<string> stamps: [
        "qrc:/gcompris/src/activities/babymatch/resource/images/star.svg",
        "qrc:/gcompris/src/activities/babymatch/resource/images/sun.svg",
        "qrc:/gcompris/src/activities/sketch/resource/moon.svg",
        "qrc:/gcompris/src/activities/sketch/resource/heart.svg",

        "qrc:/gcompris/src/core/resource/player_1.svg",
        "qrc:/gcompris/src/activities/ballcatch/resource/tux.svg",
        "qrc:/gcompris/src/activities/memory/resource/child.svg",
        "qrc:/gcompris/src/activities/positions/resource/boy.svg",
        "qrc:/gcompris/src/activities/memory/resource/01_cat.svg",
        "qrc:/gcompris/src/activities/memory/resource/02_pig.svg",
        "qrc:/gcompris/src/activities/memory/resource/03_bear.svg",
        "qrc:/gcompris/src/activities/memory/resource/04_hippopotamus.svg",
        "qrc:/gcompris/src/activities/memory/resource/05_penguin.svg",
        "qrc:/gcompris/src/activities/memory/resource/06_cow.svg",
        "qrc:/gcompris/src/activities/memory/resource/07_sheep.svg",
        "qrc:/gcompris/src/activities/memory/resource/08_turtle.svg",
        "qrc:/gcompris/src/activities/memory/resource/09_panda.svg",
        "qrc:/gcompris/src/activities/memory/resource/10_chicken.svg",
        "qrc:/gcompris/src/activities/memory/resource/11_redbird.svg",
        "qrc:/gcompris/src/activities/memory/resource/12_wolf.svg",
        "qrc:/gcompris/src/activities/memory/resource/13_monkey.svg",
        "qrc:/gcompris/src/activities/memory/resource/14_fox.svg",
        "qrc:/gcompris/src/activities/memory/resource/15_bluebirds.svg",
        "qrc:/gcompris/src/activities/memory/resource/16_elephant.svg",
        "qrc:/gcompris/src/activities/memory/resource/17_lion.svg",
        "qrc:/gcompris/src/activities/memory/resource/18_gnu.svg",
        "qrc:/gcompris/src/activities/memory/resource/19_bluebaby.svg",
        "qrc:/gcompris/src/activities/memory/resource/20_greenbaby.svg",
        "qrc:/gcompris/src/activities/memory/resource/21_frog.svg",
        "qrc:/gcompris/src/activities/submarine/resource/whale.svg",
        "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/cat.svg",
        "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/chicken.svg",
        "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/cow.svg",
        "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/dog.svg",
        "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/duck.svg",
        "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/horse.svg",
        "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/owl.svg",
        "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/pig.svg",
        "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/sheep.svg",

        "qrc:/gcompris/src/activities/algorithm/resource/apple.svg",
        "qrc:/gcompris/src/activities/algorithm/resource/banana.svg",
        "qrc:/gcompris/src/activities/algorithm/resource/cherries.svg",
        "qrc:/gcompris/src/activities/algorithm/resource/lemon.svg",
        "qrc:/gcompris/src/activities/algorithm/resource/orange.svg",
        "qrc:/gcompris/src/activities/algorithm/resource/pear.svg",
        "qrc:/gcompris/src/activities/algorithm/resource/pineapple.svg",
        "qrc:/gcompris/src/activities/algorithm/resource/plum.svg",
        "qrc:/gcompris/src/activities/enumerate/resource/grapes.svg",
        "qrc:/gcompris/src/activities/enumerate/resource/peach.svg",
        "qrc:/gcompris/src/activities/enumerate/resource/strawberry.svg",
        "qrc:/gcompris/src/activities/enumerate/resource/watermelon.svg",

        "qrc:/gcompris/src/activities/ballcatch/resource/ball.svg",
        "qrc:/gcompris/src/activities/mosaic/resource/oil_paint.svg",
        "qrc:/gcompris/src/activities/mosaic/resource/pencil.svg",
        "qrc:/gcompris/src/activities/babymatch/resource/images/bell.svg",
        "qrc:/gcompris/src/activities/babymatch/resource/images/bicycle.svg",
        "qrc:/gcompris/src/activities/babymatch/resource/images/bottle.svg",
        "qrc:/gcompris/src/activities/babymatch/resource/images/car.svg",
        "qrc:/gcompris/src/activities/babymatch/resource/images/carrot.svg",
        "qrc:/gcompris/src/activities/babymatch/resource/images/egg.svg",
        "qrc:/gcompris/src/activities/babymatch/resource/images/flower.svg",
        "qrc:/gcompris/src/activities/babymatch/resource/images/flowerpot.svg",
        "qrc:/gcompris/src/activities/babymatch/resource/images/football.svg",
        "qrc:/gcompris/src/activities/babymatch/resource/images/fusee.svg",
        "qrc:/gcompris/src/activities/babymatch/resource/images/glass.svg",
        "qrc:/gcompris/src/activities/babymatch/resource/images/house.svg",
        "qrc:/gcompris/src/activities/babymatch/resource/images/lamp.svg",
        "qrc:/gcompris/src/activities/babymatch/resource/images/sofa.svg",
        "qrc:/gcompris/src/activities/babymatch/resource/images/tree.svg",
        "qrc:/gcompris/src/activities/babymatch/resource/images/tuxhelico.svg",
        "qrc:/gcompris/src/activities/babymatch/resource/images/tuxplane.svg"
    ]

    function toolInit() {
        items.outlineCursorRadius = 0;
        tempCanvas.opacity = 1;
        stampImage.source = stamps[selectedStampIndex];
        stampImage.width = actualToolSize;
        stampImage.rotation = toolRotation;
        stampImage.mirror = toolMirror;
    }

    function placeImage() {
        canvasInput.lastPoint = canvasInput.savePoint();
        stampImage.x = canvasInput.lastPoint.x - actualToolSize * 0.5;
        stampImage.y = canvasInput.lastPoint.y - actualToolSize * 0.5;
    }

    function toolStart() {
        placeImage();
        stampImage.opacity = 0.5;
        stampImage.visible = true;
    }

    function toolProcess() {
        placeImage();
    }

    function toolStop() {
        stampImage.opacity = toolOpacity;
        canvasInput.resetPoints();
        tempCanvas.paintActionFinished();
    }

}
