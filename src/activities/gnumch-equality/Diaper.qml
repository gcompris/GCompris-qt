import QtQuick 2.1

Monster {
    id: diaper

    monsterType: "diaper"
    frames: 3
    frameW: 54
    widthRatio: 0.81

    onMovingOnChanged: {
        if (movingOn == false && opacity == 1) {
            if (Math.random() > 0.5) {
                direction = Math.floor(Math.random()*4)
            }
            modelCells.regenCell(index)
        }
    }
}
