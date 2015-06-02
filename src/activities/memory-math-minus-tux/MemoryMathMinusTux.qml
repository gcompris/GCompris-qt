import QtQuick 2.1

import "../memory"
import "../memory-math-minus/memory-minusdataset.js" as Dataset

MemoryCommon {
    dataset: Dataset.get()
    backgroundImg: "qrc:/gcompris/src/activities/memory/resource/scenery_background.png"
    withTux: true
}
