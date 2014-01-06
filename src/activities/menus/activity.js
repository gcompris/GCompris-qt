.import QtQuick 2.0 as Quick
.import "qrc:///core/core.js" as Core


function start() {
    Core.setBarLevel(1)
    Core.startBar(Core.bar.content.help |
                  Core.bar.content.home)
}

function stop() {

}

