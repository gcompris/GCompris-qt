import QtQuick 2.1

import "qrc:/gcompris/src/activities/memory"
import "qrc:/gcompris/src/core"
import "memory-math-minus-tux.js" as Activity
import "qrc:/gcompris/src/activities/memory-math-minus/memory-minusdataset.js" as Dataset

MemoryCommon {
    dataset: Dataset.get()
    backgroundImg: "qrc:/gcompris/src/activities/memory/resource/scenery_background.png"
    displayWidthRatio:0.7
    displayHeightRatio:0.6
    displayX:50
    displayY:50
    type:"math"
    tux:true
    additionnalPath:""
}
