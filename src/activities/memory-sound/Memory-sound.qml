import QtQuick 2.1

import "qrc:/gcompris/src/activities/memory"
import "qrc:/gcompris/src/core"

import "memorysounddataset.js" as Dataset

MemoryCommon {
    dataset: Dataset.get()
    backgroundImg: "qrc:/gcompris/src/activities/memory-sound/resource/gcompris_band.svgz"
    displayWidthRatio:0.2
    displayHeightRatio:0.2
    displayX:250
    displayY:25
    type:"sound"
}
