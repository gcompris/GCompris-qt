import QtQuick 2.1

// Smarty is smart enough to follow the muncher. So he will go after him.
Monster {
    id: smarty

    frames: 3
    frameW: 66
    widthRatio: 0.93

    function goAfterMuncher() {
        // Number of cells between muncher and smarty.
        var horizontalCells = muncher.index % 6 - index % 6
        var verticalCells = ((muncher.index - muncher.index % 6) / 6) - ((index - index % 6) / 6)

        if (horizontalCells == 0 && verticalCells == 0)
            return

        if ( Math.abs(horizontalCells) >= Math.abs(verticalCells)) {
            direction = 0.5 - (horizontalCells / Math.abs(horizontalCells))/2
        } else {
            direction = 2.5 - (verticalCells / Math.abs(verticalCells))/2
        }
    }

    monsterType: "smarty"

    onMovingOnChanged: {
        if (movingOn == false) {
            goAfterMuncher()
        }
    }
}
