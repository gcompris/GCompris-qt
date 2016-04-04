/* GCompris
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 */
import QtQuick 2.0

QtObject {
   property string instruction: qsTr("Easy-01")
   property variant levels: [
      {
          "pixmapfile": "images/a.png",
          "x": 0.15,
          "y": 0.5,
          "width": 0.4,
          "height": 0.319
      },
      {
          "pixmapfile": "images/b.png",
          "x": 0.35,
          "y": 0.5,
          "width": 0.4,
          "height": 0.319
      },
      {
          "pixmapfile": "images/d.png",
          "x": 0.55,
          "y": 0.5,
          "width": 0.4,
          "height": 0.319
      },
      {
          "pixmapfile": "images/e.png",
          "x": 0.75,
          "y": 0.5,
          "width": 0.4,
          "height": 0.319
      },
      {
          "text": qsTr("a"),
          "x": "0.15",
          "y": 0.5,
          "width": "0.4",
          "type": "DisplayText"
      },
      {
          "text": qsTr("b"),
          "x": "0.35",
          "y": 0.5,
          "width": "0.4",
          "type": "DisplayText"
      },
      {
          "text": qsTr("d"),
          "x": "0.55",
          "y": 0.5,
          "width": "0.4",
          "type": "DisplayText"
      },
      {
          "text": qsTr("e"),
          "x": "0.75",
          "y": 0.5,
          "width": "0.4",
          "type": "DisplayText"
      }
   ]
}
