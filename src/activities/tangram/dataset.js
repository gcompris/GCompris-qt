.pragma library

/* dataset format
  for each piece we have:
  - img: piece file name
  - flippable: is the piece flippable
  - flipping: target flipping state
  - x: target x position
  - y: target y position
  - width: item width
  - height: item height
  - rotation: item target rotation
  - moduloRotation: modulo rotation
  - opacity: item opacity
  - initX: initial x position
  - initY: innitial y position
  - initRotation: initial rotation
  - initFlipping: initial flipping
*/

var dataset = [
            // Level 1
            {
                'bg': 'truck/traffic_bg.svg',
                'pieces': [
                    {
                        'img': 'truck/engine.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.860,
                        'y': 0.573,
                        'width': 0.233,
                        'height': 0.109,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'opacity': 0.7,
                        'initX': 0.866,
                        'initY': 0.754,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
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
                        'opacity': 0.7,
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
                        'opacity': 0.7,
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
                        'opacity': 0.7,
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
                        'moduloRotation': 360,
                        'opacity': 0.7,
                        'initX': 0.501,
                        'initY': 0.760,
                        'initRotation': 0,
                        'initFlipping': 0
                    }
                ]
            },
            // Level 2
            {
                'bg': 'truck/traffic_bg.svg',
                'pieces': [
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
                        'opacity': 0.7,
                        'initX': 0.866,
                        'initY': 0.754,
                        'initRotation': 0,
                        'initFlipping': 1
                    },
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
                        'opacity': 0.7,
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
                        'opacity': 0.7,
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
                        'opacity': 0.7,
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
                        'opacity': 0.7,
                        'initX': 0.501,
                        'initY': 0.760,
                        'initRotation': 90,
                        'initFlipping': 1
                    }
                ]
            },
            // Level 3
            {
                'bg': 'truck/traffic_bg.svg',
                'pieces': [
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
                        'opacity': 0,
                        'initX': 0.866,
                        'initY': 0.754,
                        'initRotation': 0,
                        'initFlipping': 1
                    },
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
                        'opacity': 0,
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
                        'opacity': 0,
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
                        'opacity': 0,
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
                        'opacity': 0,
                        'initX': 0.501,
                        'initY': 0.760,
                        'initRotation': 270,
                        'initFlipping': 0
                    }
                ]
            },
            // Level 4
            {
                'bg': 'car1/car.svg',
                'pieces': [
                    {
                        'img': 'car1/windshield.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.492,
                        'y': 0.309,
                        'width': 0.563,
                        'height': 0.227,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'opacity': 0.7,
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
                        'opacity': 0.7,
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
                        'opacity': 0.7,
                        'initX': 0.663,
                        'initY': 0.123,
                        'initRotation': 0,
                        'initFlipping': 1
                    },
                    {
                        'img': 'car1/bumper.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.502,
                        'y': 0.656,
                        'width': 0.710,
                        'height': 0.184,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'opacity': 0.7,
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
                        'opacity': 0.7,
                        'initX': 0.382,
                        'initY': 0.825,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'car1/headlights.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.782,
                        'y': 0.506,
                        'width': 0.134,
                        'height': 0.125,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'opacity': 0.7,
                        'initX': 0.90,
                        'initY': 0.85,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'car1/headlights.svg',
                        'flippable': 0,
                        'flipping': 1,
                        'x': 0.222,
                        'y': 0.506,
                        'width': 0.134,
                        'height': 0.125,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'opacity': 0.7,
                        'initX': 0.90,
                        'initY': 0.30,
                        'initRotation': 0,
                        'initFlipping': 1
                    }
                ]
            },
            // Level 5 Real Tangram
            {
                'bg': '',
                'pieces': [
                    {
                        'img': 'tangram/p0.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.500,
                        'y': 0.349,
                        'width': 0.429,
                        'height': 0.214,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'opacity': 0.7,
                        'initX': 0.22,
                        'initY': 0.12,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'tangram/p0.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.714,
                        'y': 0.349,
                        'width': 0.429,
                        'height': 0.214,
                        'rotation': 180,
                        'moduloRotation': 360,
                        'opacity': 0.7,
                        'initX': 0.216,
                        'initY': 0.80,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'tangram/p1.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.664,
                        'y': 0.608,
                        'width': 0.304,
                        'height': 0.152,
                        'rotation': 90,
                        'moduloRotation': 360,
                        'opacity': 0.7,
                        'initX': 0.45,
                        'initY': 0.110,
                        'initRotation': 180,
                        'initFlipping': 0
                    },
                    {
                        'img': 'tangram/p2.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.511,
                        'y': 0.533,
                        'width': 0.152,
                        'height': 0.152,
                        'rotation': 0,
                        'moduloRotation': 90,
                        'opacity': 0.7,
                        'initX': 0.7,
                        'initY': 0.110,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'tangram/p3.svg',
                        'flippable': 1,
                        'flipping': 0,
                        'x': 0.749,
                        'y': 0.509,
                        'width': 0.322,
                        'height': 0.108,
                        'rotation': 0,
                        'moduloRotation': 180,
                        'opacity': 0.7,
                        'initX': 0.94,
                        'initY': 0.17,
                        'initRotation': -90,
                        'initFlipping': 1
                    },
                    {
                        'img': 'tangram/p4.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.178,
                        'y': 0.403,
                        'width': 0.215,
                        'height': 0.108,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'opacity': 0.7,
                        'initX': 0.60,
                        'initY': 0.85,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'tangram/p4.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.399,
                        'y': 0.495,
                        'width': 0.215,
                        'height': 0.108,
                        'rotation': 45,
                        'moduloRotation': 360,
                        'opacity': 0.7,
                        'initX': 0.80,
                        'initY': 0.85,
                        'initRotation': 180,
                        'initFlipping': 0
                    }
                ]
            }
        ]

