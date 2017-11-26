/* GCompris - Dataset.js
 *
 * Copyright (C) 2017 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
function get() {
    return [
                {
                    "clipImg": "qrc:/gcompris/src/activities/solar_system/resource/sun_clip.svg",
                    "realImg": "qrc:/gcompris/src/activities/solar_system/resource/sun_real.svg",
                    "bodyName": qsTr("Sun"),
                    "levels": [
                        { 	//sub-level 1
                            "question": qsTr("The sun is the_____ largest object in our solar system"),
                            "options": [qsTr("Sixth"),qsTr("Third"),qsTr("First"),qsTr("Seventh")],
                            "closeness": [17.5,67,100,1]
                        },
                        { 	//sub-level 2
                            "question": qsTr("The temperature of the sun is around _____degrees"),
                            "options": ["1000","4500","5505","3638"],
                            "closeness": [1,78,100,60]
                        },
                        { 	//sub-level 3
                            "question": qsTr("Sun is ___ years old"),
                            "options": [qsTr("1.2 billion"),qsTr("3 billion"),qsTr("7 billion"),qsTr("4.5 billion")],
                            "closeness": [1,55,25,100]
                        },
                        { 	//sub-level 4
                            "question": qsTr("How long does it take the Sun’s light to reach the earth"),
                            "options": [qsTr("8 minutes"),qsTr("30 minutes"),qsTr("60 minutes"),qsTr("15 minutes")],
                            "closeness": [100,58,1,86.6]
                        },
                        { 	//sub-level 5
                            "question": qsTr("Sun is as big as ____ Earths"),
                            "options": [qsTr("1 million"),qsTr("2.6 million"),qsTr("1.3 million"),qsTr("5 million")],
                            "closeness": [92,65,100,1]
                        }
                    ]
                },
                {
                    "clipImg": "qrc:/gcompris/src/activities/solar_system/resource/mercury_clip.svg",
                    "realImg": "qrc:/gcompris/src/activities/solar_system/resource/mercury_real.svg",
                    "bodyName": qsTr("Mercury"),
                    "levels": [
                        { 	//sub-level 1
                            "question": qsTr("Mercury is the ______ planet in the Solar System"),
                            "options": [qsTr("Seventh"),qsTr("Sixth"),qsTr("First"),qsTr("Fourth")],
                            "closeness": [1,17.5,100,50.5]
                        },
                        { 	//sub-level 2
                            "question": qsTr("On Mercury, we can survive only for"),
                            "options": [qsTr("2 minutes"),qsTr("4 minutes"),qsTr("1 minute"),qsTr("60 minutes")],
                            "closeness": [100,96.6,98,1]
                        },
                        { 	//sub-level 3
                            "question": qsTr("How many moons does Mercury has?"),
                            "options": ["5","200","0","10"],
                            "closeness": [97.5,1,100,95]
                        },
                        { 	//sub-level 4
                            "question": qsTr("The maximum temperature on Mercury is"),
                            "options": [qsTr("145 Degrees"),qsTr("35 Degrees"),qsTr("427 Degrees"),qsTr("273 Degrees")],
                            "closeness": [28.8,1,100,61]
                        },
                        { 	//sub-level 5
                            "question": qsTr("How many days makes an year on Mercury ?"),
                            "options": [qsTr("365 Days"),qsTr("433 Days"),qsTr("88 Days"),qsTr("107 Days")],
                            "closeness": [20.5,1,100,94.5]
                        },
                        { 	//sub-level 6
                            "question": qsTr("How long is a day on Mercury?"),
                            "options": [qsTr("50 Earth days"),qsTr("365 Earth days"),qsTr("59 Earth days"),qsTr("107 Earth days")],
                            "closeness": [97,1,100,84.4]
                        }
                    ]
                },
                {
                    "clipImg": "qrc:/gcompris/src/activities/solar_system/resource/venus_clip.svg",
                    "realImg": "qrc:/gcompris/src/activities/solar_system/resource/venus_real.svg",
                    "bodyName": qsTr("Venus"),
                    "levels": [
                        { 	//sub-level 1
                            "question": qsTr("Venus is the ______ planet in the Solar System."),
                            "options": [qsTr("Seventh"),qsTr("Sixth"),qsTr("Second"),qsTr("Fourth")],
                            "closeness": [1,20.8,100,60.4]
                        },
                        { 	//sub-level 2
                            "question": qsTr("Venus is as heavy as"),
                            "options": [qsTr("0.7 Earths"),qsTr("0.8 Earths "),qsTr("1.3 Earths "),qsTr("2.5 Earths ")],
                            "closeness": [94,100,71,1]
                        },
                        { 	//sub-level 3
                            "question": qsTr("Venus is the _____________ largest planet"),
                            "options": [qsTr("Seventh"),qsTr("Sixth"),qsTr("Fifth"),qsTr("Fourth")],
                            "closeness": [50.5,100,50.5,1]
                        },
                        { 	//sub-level 4
                            "question": qsTr("How long is an year on Venus? "),
                            "options": [qsTr("225 days"),qsTr("365 days"),qsTr("116 days"),qsTr("100 days")],
                            "closeness": [100,1,23,11.6]
                        },
                        { 	//sub-level 5
                            "question": qsTr("How long is a day on Venus?"),
                            "options": [qsTr("117 Earth days"),qsTr("365 Earth days"),qsTr("88 Earth days"),qsTr("107 Earth days")],
                            "closeness": [100,1,88.8,96.4]
                        },
                        { 	//sub-level 6
                            "question": qsTr("Maximum temperature on Venus is"),
                            "options": [qsTr("100 Degrees"),qsTr("500 Degrees"),qsTr("467 Degrees"),qsTr("45 Degrees")],
                            "closeness": [14,92,100,1]
                        }
                    ]
                },
                {
                    "clipImg": "qrc:/gcompris/src/activities/solar_system/resource/earth_clip.svg",
                    "realImg": "qrc:/gcompris/src/activities/solar_system/resource/earth_real.svg",
                    "bodyName": qsTr("Earth"),
                    "levels": [
                        { 	//sub-level 1
                            "question": qsTr("Earth is the ______ planet in the Solar System"),
                            "options": [qsTr("Sixth"),qsTr("Third"),qsTr("First"),qsTr("Fifth")],
                            "closeness": [1,100,35,35]
                        },
                        { 	//sub-level 2
                            "question": qsTr("How long does it take Earth to complete one year?"),
                            "options": [qsTr("200 Days"),qsTr("30 Days"),qsTr("7 Days"),qsTr("365 Days")],
                            "closeness": [54.3,7.3,1,100]
                        },
                        { 	//sub-level 3
                            "question": qsTr("How many moons does Earth has?"),
                            "options": ["1","5","2","3"],
                            "closeness": [100,15,75,50.5]
                        },
                        { 	//sub-level 4
                            "question": qsTr("How long is a day on Earth?"),
                            "options": [qsTr("12 Hours"),qsTr("24 Hours"),qsTr("365 Hours"),qsTr("48 Hours")],
                            "closeness": [96.5,100,1,93]
                        },
                        { 	//sub-level 5
                            "question": qsTr("Earth has ____ seasons."),
                            "options": ["2","4","6","1"],
                            "closeness": [34,100,34,1]
                        },
                        { 	//sub-level 6
                            "question": qsTr("Maximum temperature on Earth is"),
                            "options": [qsTr("100 Degrees"),qsTr("58 Degrees"),qsTr("0 Degrees"),qsTr("45 Degrees")],
                            "closeness": [28.3,100,1,77.8]
                        }
                    ]
                },
                {
                    "clipImg": "qrc:/gcompris/src/activities/solar_system/resource/mars_clip.svg",
                    "realImg": "qrc:/gcompris/src/activities/solar_system/resource/mars_real.svg",
                    "bodyName": qsTr("Mars"),
                    "levels": [
                        { 	//sub-level 1
                            "question": qsTr("Mars is the ______ planet in the Solar System"),
                            "options": [qsTr("Sixth"),qsTr("Fourth"),qsTr("First"),qsTr("Fifth")],
                            "closeness": [34,100,1,67]
                        },
                        { 	//sub-level 2
                            "question": qsTr("The maximum temperature on Mars is"),
                            "options": [qsTr("20 Degrees"),qsTr("35 Degrees"),qsTr("100 Degrees"),qsTr("0 Degrees")],
                            "closeness": [100,81.4,1,75]
                        },
                        { 	//sub-level 3
                            "question": qsTr("Mars is about __________ the size of Earth"),
                            "options": [qsTr("The same"),qsTr("Half"),qsTr("Two times"),qsTr("Three times")],
                            "closeness": [80,100,40.6,1]
                        },
                        { 	//sub-level 4
                            "question": qsTr("How many moons does Mars has?"),
                            "options": ["1","5","2","3"],
                            "closeness": [67,1,100,50.5]
                        },
                        { 	//sub-level 5
                            "question": qsTr("How long is a day on Mars?"),
                            "options": [qsTr("12 Hours"),qsTr("24 Hours"),qsTr("24.5 Hours"),qsTr("48 Hours")],
                            "closeness": [47.3,91,100,1]
                        },
                        { 	//sub-level 6
                            "question": qsTr("How long does it take Mars to complete one year?"),
                            "options": [qsTr("687 Days"),qsTr("30 Days"),qsTr("7 Days"),qsTr("365 Days")],
                            "closeness": [100,4.3,1,53]
                        }
                    ]
                },
                {
                    "clipImg": "qrc:/gcompris/src/activities/solar_system/resource/jupiter_clip.svg",
                    "realImg": "qrc:/gcompris/src/activities/solar_system/resource/jupiter_real.svg",
                    "bodyName": qsTr("Jupiter"),
                    "levels": [
                        { 	//sub-level 1
                            "question": qsTr("Jupiter is the ______ planet in the Solar System"),
                            "options": [qsTr("Sixth"),qsTr("Fifth"),qsTr("First"),qsTr("Fourth")],
                            "closeness": [75,100,1,75]
                        },
                        { 	//sub-level 2
                            "question": qsTr("Jupiter is the ______  largest planet in the Solar System"),
                            "options": [qsTr("Third"),qsTr("First"),qsTr("Fifth"),qsTr("Second")],
                            "closeness": [50.5,100,1,75]
                        },
                        { 	//sub-level 3
                            "question": qsTr("Jupiter is as big as ____ Earths"),
                            "options": ["100","764","300","1300"],
                            "closeness": [1,63,24.7,100]
                        },
                        { 	//sub-level 4
                            "question": qsTr("How many moons does Jupiter has?"),
                            "options": ["1","20","25","16"],
                            "closeness": [70,92.5,1,100]
                        },
                        { 	//sub-level 5
                            "question": qsTr("How long is one day on Jupiter?"),
                            "options": [qsTr("10 Hours"),qsTr("24 Hours"),qsTr("12 Hours"),qsTr("48 Hours")],
                            "closeness": [100,63.5,94.8,1]
                        },
                        { 	//sub-level 6
                            "question": qsTr("How long does it take Jupiter to complete one year?"),
                            "options": [qsTr("5 years"),qsTr("12 years"),qsTr("20 years"),qsTr("1 year")],
                            "closeness": [37,100,28,1]
                        }
                    ]
                },
                {
                    "clipImg": "qrc:/gcompris/src/activities/solar_system/resource/saturn_clip.svg",
                    "realImg": "qrc:/gcompris/src/activities/solar_system/resource/saturn_real.png",
                    "bodyName": qsTr("Saturn"),
                    "levels": [
                        { 	//sub-level 1
                            "question": qsTr("Saturn is the ______ planet in the Solar System"),
                            "options": [qsTr("Sixth"),qsTr("Fourth"),qsTr("First"),qsTr("Fifth")],
                            "closeness": [100,60.4,1,80]
                        },
                        { 	//sub-level 2
                            "question": qsTr("Saturn is the ______ largest  planet in the Solar System"),
                            "options": [qsTr("Third"),qsTr("First"),qsTr("Fifth"),qsTr("Second")],
                            "closeness": [67,67,1,100]
                        },
                        { 	//sub-level 3
                            "question": qsTr("How many moons does Saturn has?"),
                            "options": ["120","1","150","200"],
                            "closeness": [80,1,100,60.8]
                        },
                        { 	//sub-level 4
                            "question": qsTr("How long is one day on Saturn?"),
                            "options": [qsTr("10.5 Hours"),qsTr("24 Hours"),qsTr("12 Hours"),qsTr("48 Hours")],
                            "closeness": [100,64.3,96,1]
                        },
                        { 	//sub-level 5
                            "question": qsTr("Saturn is as big as ____ Earths"),
                            "options": ["100","764","300","1300"],
                            "closeness": [1,100,30.8,20]
                        },
                        { 	//sub-level 6
                            "question": qsTr("How long does it take Saturn to complete one year?"),
                            "options": [qsTr("29.5 years"),qsTr("20 years"),qsTr("30.5 years"),qsTr("1 year")],
                            "closeness": [100,67,96.5,1]
                        }
                    ]
                },
                {
                    "clipImg": "qrc:/gcompris/src/activities/solar_system/resource/uranus_clip.svg",
                    "realImg": "qrc:/gcompris/src/activities/solar_system/resource/uranus_real.svg",
                    "bodyName": qsTr("Uranus"),
                    "levels": [
                        { 	//sub-level 1
                            "question": qsTr("Uranus is the ______ planet in the Solar System"),
                            "options": [qsTr("Seventh"),qsTr("Fourth"),qsTr("Eighth"),qsTr("Fifth")],
                            "closeness": [100,1,67,34]
                        },
                        { 	//sub-level 2
                            "question": qsTr("How many years does it take Uranus to go once around the Sun?"),
                            "options": ["1","24","68","84"],
                            "closeness": [1,28.4,81,100]
                        },
                        { 	//sub-level 3
                            "question": qsTr("How many moons does Uranus has?"),
                            "options": ["120","87","27","50"],
                            "closeness": [1,36,100,75.5]
                        },
                        { 	//sub-level 4
                            "question": qsTr("How long is one day on Uranus?"),
                            "options": [qsTr("10 Hours"),qsTr("27 Hours"),qsTr("17 Hours"),qsTr("48 Hours")],
                            "closeness": [77.6,68,100,1]
                        },
                        { 	//sub-level 5
                            "question": qsTr("Uranus is the ______ largest planet in the Solar System."),
                            "options": [qsTr("Third"),qsTr("First"),qsTr("Seventh"),qsTr("Second")],
                            "closeness": [100,50.5,1,75]
                        },
                        { 	//sub-level 6
                            "question": qsTr("The maximum temperature on Uranus is"),
                            "options": [qsTr("100 Degrees"),qsTr("-216 Degrees"),qsTr("0 Degrees"),qsTr("-100 Degrees")],
                            "closeness": [54,1,100,54]
                        }
                    ]
                },
                {
                    "clipImg": "qrc:/gcompris/src/activities/solar_system/resource/neptune_clip.svg",
                    "realImg": "qrc:/gcompris/src/activities/solar_system/resource/neptune_real.svg",
                    "bodyName": qsTr("Neptune"),
                    "levels": [
                        { 	//sub-level 1
                            "question": qsTr("Neptune is the ______ planet in the Solar System"),
                            "options": [qsTr("Seventh"),qsTr("Fourth"),qsTr("Eighth"),qsTr("Fifth")],
                            "closeness": [75,1,100,25.7]
                        },
                        { 	//sub-level 2
                            "question": qsTr("How long does it take Neptune to make one revolution around the Sun?"),
                            "options": [qsTr("165 Years"),qsTr("3 Years"),qsTr("100 Years"),qsTr("1 Year")],
                            "closeness": [100,2,60.7,1]
                        },
                        { 	//sub-level 3
                            "question": qsTr("How many moons does Neptune has?"),
                            "options": ["120","87","14","50"],
                            "closeness": [1,31.8,100,66.3]
                        },
                        { 	//sub-level 4
                            "question": qsTr("How long is one day on Neptune?"),
                            "options": [qsTr("16 Hours"),qsTr("27 Hours"),qsTr("17 Hours"),qsTr("48 Hours")],
                            "closeness": [100,66,97,1]
                        },
                        { 	//sub-level 5
                            "question": qsTr("The temperature on Neptune is"),
                            "options": [qsTr("100 Degrees"),qsTr("30 Degrees"),qsTr("-214 Degrees"),qsTr("-100 Degrees")],
                            "closeness": [1,23,100,64]
                        },
                        { 	//sub-level 6
                            "question": qsTr("Neptune is as big as ____ Earths"),
                            "options": ["100","57","5","500"],
                            "closeness": [90.4,100,88.4,1]
                        }
                    ]
                }
            ];
}
