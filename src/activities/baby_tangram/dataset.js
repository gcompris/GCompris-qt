/* GCompris - dataset.js
 *
 * SPDX-FileCopyrightText: 2016 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library

/* dataset format
  - for each level we have:
    - bg: an optional background image
    - colorMask: the color of the shadowed target items
    - a list of pieces that each holds:
      - img: piece file name
      - flippable: is the piece flippable
      - flipping: target flipping state
      - x: target x position
      - y: target y position
      - width: item width
      - height: item height
      - rotation: item target rotation
      - moduloRotation: modulo rotation
      - initX: initial x position
      - initY: innitial y position
      - initRotation: initial rotation
      - initFlipping: initial flipping
*/

var dataset = [
            {
                'bg': '',
                'name': 'train1',
                'colorMask': '#999',
                'pieces': [
                    {
                        'img': 'train/loco.svg',
                        'flippable': 0,
                        'flipping': false,
                        'height': 0.238,
                        'initFlipping': 0,
                        'initRotation': 0,
                        'initX': 0.84868,
                        'initY': 0.14357,
                        'moduloRotation': 0,
                        'rotation': 0,
                        'width': 0.237,
                        'x': 0.16136986301369866,
                        'y': 0.5003377010125074
                    },
                    {
                        'img': 'train/coal.svg',
                        'flippable': 0,
                        'flipping': false,
                        'height': 0.144,
                        'initFlipping': 0,
                        'initRotation': 0,
                        'initX': 0.40198,
                        'initY': 0.10248,
                        'moduloRotation': 0,
                        'rotation': 0,
                        'width': 0.221,
                        'x': 0.38829064919595,
                        'y': 0.5456027397260274
                    },
                    {
                        'img': 'train/wood.svg',
                        'flippable': 0,
                        'flipping': false,
                        'height': 0.141,
                        'initFlipping': 0,
                        'initRotation': 0,
                        'initX': 0.58434,
                        'initY': 0.23488,
                        'moduloRotation': 0,
                        'rotation': 0,
                        'width': 0.235,
                        'x': 0.6111453245979751,
                        'y': 0.5469714115544966
                    },
                    {
                        'img': 'train/passenger.svg',
                        'flippable': 0,
                        'flipping': false,
                        'height': 0.213,
                        'initFlipping': 0,
                        'initRotation': 0,
                        'initX': 0.15311,
                        'initY': 0.15368,
                        'moduloRotation': 0,
                        'rotation': 0,
                        'width': 0.238,
                        'x': 0.8362608695652176,
                        'y': 0.5122281119714115
                    },
                ]
            },
            {
                'bg': '',
                'name': 'train2',
                'colorMask': '#999',
                'pieces': [
                    {
                        'img': 'train/loco.svg',
                        'flippable': 0,
                        'flipping': false,
                        'height': 0.238,
                        'initFlipping': 0,
                        'initRotation': 0,
                        'initX': 0.84868,
                        'initY': 0.14357,
                        'moduloRotation': 0,
                        'rotation': 0,
                        'width': 0.237,
                        'x': 0.16136986301369866,
                        'y': 0.5003377010125074
                    },
                    {
                        'img': 'train/coal.svg',
                        'flippable': 0,
                        'flipping': false,
                        'height': 0.144,
                        'initFlipping': 0,
                        'initRotation': 0,
                        'initX': 0.40198,
                        'initY': 0.10248,
                        'moduloRotation': 0,
                        'rotation': 0,
                        'width': 0.221,
                        'x': 0.6116378796902918,
                        'y': 0.5491762954139369
                    },
                    {
                        'img': 'train/wood.svg',
                        'flippable': 0,
                        'flipping': false,
                        'height': 0.141,
                        'initFlipping': 0,
                        'initRotation': 0,
                        'initX': 0.58434,
                        'initY': 0.23488,
                        'moduloRotation': 0,
                        'rotation': 0,
                        'width': 0.235,
                        'x': 0.8368749255509234,
                        'y': 0.5493537820131029
                    },
                    {
                        'img': 'train/passenger.svg',
                        'flippable': 0,
                        'flipping': false,
                        'height': 0.213,
                        'initFlipping': 0,
                        'initRotation': 0,
                        'initX': 0.15311,
                        'initY': 0.15368,
                        'moduloRotation': 0,
                        'rotation': 0,
                        'width': 0.238,
                        'x': 0.3913531864204886,
                        'y': 0.5140148898153662
                    },
                ]
            },
            {
                'bg': '',
                'name': 'train3',
                'colorMask': '#999',
                'pieces': [
                    {
                        'img': 'train/loco.svg',
                        'flippable': 0,
                        'flipping': false,
                        'height': 0.238,
                        'initFlipping': 0,
                        'initRotation': 0,
                        'initX': 0.84868,
                        'initY': 0.14357,
                        'moduloRotation': 360,
                        'rotation': 45,
                        'width': 0.237,
                        'x': 0.19114949374627757,
                        'y': 0.22279154258487197
                    },
                    {
                        'img': 'train/coal.svg',
                        'flippable': 0,
                        'flipping': false,
                        'height': 0.144,
                        'initFlipping': 0,
                        'initRotation': 0,
                        'initX': 0.40198,
                        'initY': 0.10248,
                        'moduloRotation': 360,
                        'rotation': 45,
                        'width': 0.221,
                        'x': 0.6336748064324003,
                        'y': 0.7272584871947588
                    },
                    {
                        'img': 'train/wood.svg',
                        'flippable': 0,
                        'flipping': false,
                        'height': 0.141,
                        'initFlipping': 0,
                        'initRotation': 0,
                        'initX': 0.58434,
                        'initY': 0.23488,
                        'moduloRotation': 360,
                        'rotation': 45,
                        'width': 0.235,
                        'x': 0.4801149493746279,
                        'y': 0.5791334127456819
                    },
                    {
                        'img': 'train/passenger.svg',
                        'flippable': 0,
                        'flipping': false,
                        'height': 0.213,
                        'initFlipping': 0,
                        'initRotation': 0,
                        'initX': 0.84311,
                        'initY': 0.42368,
                        'moduloRotation': 360,
                        'rotation': 45,
                        'width': 0.238,
                        'x': 0.34251459201905915,
                        'y': 0.3925139964264443
                    },
                ]
            },
            {
                'bg': '',
                'name': 'train4',
                'colorMask': '#999',
                'pieces': [
                    {
                        'img': 'train/loco.svg',
                        'flippable': 0,
                        'flipping': false,
                        'height': 0.238,
                        'initFlipping': 0,
                        'initRotation': 0,
                        'initX': 0.84868,
                        'initY': 0.14357,
                        'moduloRotation': 360,
                        'rotation': 315,
                        'width': 0.237,
                        'x': 0.20365693865396073,
                        'y': 0.4241018463371054
                    },
                    {
                        'img': 'train/coal.svg',
                        'flippable': 0,
                        'flipping': false,
                        'height': 0.144,
                        'initFlipping': 0,
                        'initRotation': 0,
                        'initX': 0.40198,
                        'initY': 0.10248,
                        'moduloRotation': 360,
                        'rotation': 90,
                        'width': 0.221,
                        'x': 0.7575580702799286,
                        'y': 0.6540005955926147
                    },
                    {
                        'img': 'train/wood.svg',
                        'flippable': 0,
                        'flipping': false,
                        'height': 0.141,
                        'initFlipping': 0,
                        'initRotation': 0,
                        'initX': 0.58434,
                        'initY': 0.23488,
                        'moduloRotation': 360,
                        'rotation': 45,
                        'width': 0.235,
                        'x': 0.6689178082191782,
                        'y': 0.4540589636688504
                    },
                    {
                        'img': 'train/passenger.svg',
                        'flippable': 0,
                        'flipping': false,
                        'height': 0.213,
                        'initFlipping': 0,
                        'initRotation': 0,
                        'initX': 0.84311,
                        'initY': 0.42368,
                        'moduloRotation': 360,
                        'rotation': 0,
                        'width': 0.238,
                        'x': 0.4550815961882075,
                        'y': 0.3317635497319833
                    },
                ]
            },
            {
                'bg': '',
                'name': 'train5',
                'colorMask': '#999',
                'pieces': [
                    {
                        'img': 'train/loco.svg',
                        'flippable': 1,
                        'flipping': true,
                        'height': 0.238,
                        'initFlipping': 0,
                        'initRotation': 0,
                        'initX': 0.84868,
                        'initY': 0.14357,
                        'moduloRotation': 0,
                        'rotation': 0,
                        'width': 0.237,
                        'x': 0.8474925550923169,
                        'y': 0.48902144133412745
                    },
                    {
                        'img': 'train/coal.svg',
                        'flippable': 1,
                        'flipping': true,
                        'height': 0.144,
                        'initFlipping': 0,
                        'initRotation': 0,
                        'initX': 0.40198,
                        'initY': 0.10248,
                        'moduloRotation': 0,
                        'rotation': 0,
                        'width': 0.221,
                        'x': 0.619976176295414,
                        'y': 0.5354776652769506
                    },
                    {
                        'img': 'train/wood.svg',
                        'flippable': 1,
                        'flipping': true,
                        'height': 0.141,
                        'initFlipping': 0,
                        'initRotation': 0,
                        'initX': 0.58434,
                        'initY': 0.2348,
                        'moduloRotation': 0,
                        'rotation': 0,
                        'width': 0.235,
                        'x': 0.39375402025014905,
                        'y': 0.5374419297200713
                    },
                    {
                        'img': 'train/passenger.svg',
                        'flippable': 1,
                        'flipping': true,
                        'height': 0.213,
                        'initFlipping': 0,
                        'initRotation': 0,
                        'initX': 0.15311,
                        'initY': 0.15368,
                        'moduloRotation': 0,
                        'rotation': 0,
                        'width': 0.238,
                        'x': 0.16741036331149514,
                        'y': 0.5015074449076831
                    },
                ]
            },
            {
                'name': 'Level 1',
                'bg': 'truck/traffic_bg.svg',
                'colorMask': '#999',
                'pieces': [
                    {
                        'img': 'truck/cabin.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.847,
                        'y': 0.435,
                        'width': 0.207,
                        'height': 0.178,
                        'rotation': 0,
                        'moduloRotation': 0,
                        'initX': 0.153,
                        'initY': 0.789,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'truck/container.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.358,
                        'y': 0.489,
                        'width': 0.676,
                        'height': 0.271,
                        'rotation': 0,
                        'moduloRotation': 0,
                        'initX': 0.338,
                        'initY': 0.135,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'truck/back_road.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.181,
                        'y': 0.633,
                        'width': 0.198,
                        'height': 0.092,
                        'rotation': 0,
                        'moduloRotation': 0,
                        'initX': 0.799,
                        'initY': 0.146,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'truck/front_road.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.766,
                        'y': 0.617,
                        'width': 0.403,
                        'height': 0.121,
                        'rotation': 0,
                        'moduloRotation': 0,
                        'initX': 0.501,
                        'initY': 0.760,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'truck/engine.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.860,
                        'y': 0.573,
                        'width': 0.233,
                        'height': 0.109,
                        'rotation': 0,
                        'moduloRotation': 0,
                        'initX': 0.866,
                        'initY': 0.754,
                        'initRotation': 0,
                        'initFlipping': 0
                    }
                ]
            },
            {
                'name': 'Level 2',
                'bg': 'truck/traffic_bg.svg',
                'colorMask': '#999',
                'pieces': [
                    {
                        'img': 'truck/cabin.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.847,
                        'y': 0.435,
                        'width': 0.207,
                        'height': 0.178,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'initX': 0.153,
                        'initY': 0.789,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'truck/container.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.358,
                        'y': 0.489,
                        'width': 0.676,
                        'height': 0.271,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'initX': 0.338,
                        'initY': 0.135,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'truck/back_road.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.181,
                        'y': 0.633,
                        'width': 0.198,
                        'height': 0.092,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'initX': 0.799,
                        'initY': 0.146,
                        'initRotation': 270,
                        'initFlipping': 0
                    },
                    {
                        'img': 'truck/front_road.svg',
                        'flippable': 1,
                        'flipping': 0,
                        'x': 0.766,
                        'y': 0.617,
                        'width': 0.403,
                        'height': 0.121,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'initX': 0.501,
                        'initY': 0.760,
                        'initRotation': 90,
                        'initFlipping': 1
                    },
                    {
                        'img': 'truck/engine.svg',
                        'flippable': 1,
                        'flipping': 0,
                        'x': 0.860,
                        'y': 0.573,
                        'width': 0.233,
                        'height': 0.109,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'initX': 0.866,
                        'initY': 0.754,
                        'initRotation': 0,
                        'initFlipping': 1
                    }
                ]
            },
            {
                'name': 'Level 3',
                'bg': 'truck/traffic_bg.svg',
                'colorMask': '#999',
                'pieces': [
                    {
                        'img': 'truck/cabin.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.847,
                        'y': 0.435,
                        'width': 0.207,
                        'height': 0.178,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'initX': 0.153,
                        'initY': 0.789,
                        'initRotation': 45,
                        'initFlipping': 0
                    },
                    {
                        'img': 'truck/container.svg',
                        'flippable': 1,
                        'flipping': 0,
                        'x': 0.358,
                        'y': 0.489,
                        'width': 0.676,
                        'height': 0.271,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'initX': 0.338,
                        'initY': 0.135,
                        'initRotation': 0,
                        'initFlipping': 1
                    },
                    {
                        'img': 'truck/back_road.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.181,
                        'y': 0.633,
                        'width': 0.198,
                        'height': 0.092,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'initX': 0.799,
                        'initY': 0.146,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'truck/front_road.svg',
                        'flippable': 1,
                        'flipping': 0,
                        'x': 0.766,
                        'y': 0.617,
                        'width': 0.403,
                        'height': 0.121,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'initX': 0.501,
                        'initY': 0.760,
                        'initRotation': 270,
                        'initFlipping': 0
                    },
                    {
                        'img': 'truck/engine.svg',
                        'flippable': 1,
                        'flipping': 0,
                        'x': 0.860,
                        'y': 0.573,
                        'width': 0.233,
                        'height': 0.109,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'initX': 0.866,
                        'initY': 0.754,
                        'initRotation': 0,
                        'initFlipping': 1
                    }
                ]
            },
            {
                'name': 'Level 4',
                'bg': 'car1/car.svg',
                'colorMask': '#999',
                'pieces': [
                    {
                        'img': 'car1/windshield.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.5,
                        'y': 0.309,
                        'width': 0.563,
                        'height': 0.227,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'initX': 0.301,
                        'initY': 0.133,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'car1/tire_right.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.226,
                        'y': 0.720,
                        'width': 0.126,
                        'height': 0.147,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'initX': 0.863,
                        'initY': 0.123,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'car1/tire_right.svg',
                        'flippable': 0,
                        'flipping': 1,
                        'x': 0.782,
                        'y': 0.720,
                        'width': 0.126,
                        'height': 0.147,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'initX': 0.663,
                        'initY': 0.123,
                        'initRotation': 0,
                        'initFlipping': 1
                    },
                    {
                        'img': 'car1/bumper.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.5,
                        'y': 0.668,
                        'width': 0.710,
                        'height': 0.184,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'initX': 0.405,
                        'initY': 0.892,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'car1/grille.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.505,
                        'y': 0.600,
                        'width': 0.365,
                        'height': 0.051,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'initX': 0.382,
                        'initY': 0.825,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'car1/headlights.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.768,
                        'y': 0.513,
                        'width': 0.134,
                        'height': 0.125,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'initX': 0.90,
                        'initY': 0.85,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'car1/headlights.svg',
                        'flippable': 0,
                        'flipping': 1,
                        'x': 0.232,
                        'y': 0.513,
                        'width': 0.134,
                        'height': 0.125,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'initX': 0.90,
                        'initY': 0.30,
                        'initRotation': 0,
                        'initFlipping': 1
                    }
                ]
            }
        ]
