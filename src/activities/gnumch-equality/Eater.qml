import QtQuick 2.1

Monster {
    id: eater

    monsterType: "eater"
    frames: 3
    frameW: 64
    widthRatio: 0.9

    onMovingOnChanged: {
        if (movingOn == false) {
            if (Math.random() > 0.666) {
                modelCells.get(index).show = false
                gridPart.isLevelDone()
            }
        }
    }
}
