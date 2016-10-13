/* GCompris
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 */
import QtQuick 2.0

QtObject {
   property string instruction: qsTr("Easy_04")
   property variant levels: [
      {
          "pixmapfile": "images/a.png",
          "x": 0.15,
          "y": 0.5,
          "width": 0.4,
          "height": 0.319
      },
      {
          "pixmapfile": "images/e.png",
          "x": 0.35,
          "y": 0.5,
          "width": 0.4,
          "height": 0.319
      },
      {
          "pixmapfile": "images/m.png",
          "x": 0.55,
          "y": 0.5,
          "width": 0.4,
          "height": 0.319
      },
      {
          "pixmapfile": "images/s.png",
          "x": 0.75,
          "y": 0.5,
          "width": 0.4,
          "height": 0.319
      },
      {
          "text": qsTr("1"),
          "x": "0.15",
          "y": 0.5,
          "width": "0.4",
          "type": "DisplayText"
      },
      {
          "text": qsTr("2"),
          "x": "0.35",
          "y": 0.5,
          "width": "0.4",
          "type": "DisplayText"
      },
      {
          "text": qsTr("3"),
          "x": "0.55",
          "y": 0.5,
          "width": "0.4",
          "type": "DisplayText"
      },
      {
          "text": qsTr("4"),
          "x": "0.75",
          "y": 0.5,
          "width": "0.4",
          "type": "DisplayText"
      },
        {
            "text": qsTr("A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z"),
            "x": 0.65,
            "y": 1.05,
            "width": "1.0",
            "type": "DisplayText"
        }

   ]
}
