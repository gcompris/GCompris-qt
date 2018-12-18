/* GCompris - Dataset.js
 *
 * Copyright (C) 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Aman Kumar Gupta <gupta2140@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
function get() {
    return [
                {
                    "realImg": "qrc:/gcompris/src/activities/solar_system/resource/sun.png",
                    "bodyName": qsTr("Sun"),
                    "bodySize": 1.3,
                    "levels": [
                        { 	// sub-level 1
                            "question": qsTr("How large is the Sun compared to the planets in our Solar System?"),
                            "options": [qsTr("Sixth largest"), qsTr("Third largest"), qsTr("Largest"), qsTr("Seventh largest")],
                            "closeness": [17.5, 67, 100, 1]
                        },
                        { 	// sub-level 2
                            "question": qsTr("The temperature of the Sun is around:"),
                            "options": [qsTr("1000 °C"), qsTr("4500 °C"), qsTr("5505 °C"), qsTr("3638 °C")],
                            "closeness": [1, 78, 100, 60]
                        },
                        { 	// sub-level 3
                            "question": qsTr("How old is the Sun?"),
                            "options": [qsTr("1.2 billion years"), qsTr("3 billion years"), qsTr("7 billion years"), qsTr("4.5 billion years")],
                            "closeness": [1, 55, 25, 100]
                        },
                        { 	// sub-level 4
                            "question": qsTr("How long does it take for the Sun’s light to reach the Earth?"),
                            "options": [qsTr("8 minutes"), qsTr("30 minutes"), qsTr("60 minutes"), qsTr("15 minutes")],
                            "closeness": [100, 58, 1, 86.6]
                        },
                        { 	// sub-level 5
                            "question": qsTr("The Sun is as big as:"),
                            "options": [qsTr("1 million Earths"), qsTr("2.6 million Earths"), qsTr("1.3 million Earths"), qsTr("5 million Earths")],
                            "closeness": [92, 65, 100, 1]
                        }
                    ]
                },
                {
                    "realImg": "qrc:/gcompris/src/activities/solar_system/resource/mercury.png",
                    "bodyName": qsTr("Mercury"),
                    "bodySize": 0.12,
                    "temperatureHint": qsTr("The maximum temperature on Earth is 58 °C."),
                    "lengthOfYearHint": qsTr("The length of a year on Venus is 225 days."),
                    "levels": [
                        { 	// sub-level 1
                            "question": qsTr("At which position is Mercury in the Solar System?"),
                            "options": [qsTr("Seventh"), qsTr("Sixth"), qsTr("First"), qsTr("Fourth")],
                            "closeness": [1, 17.5, 100, 50.5]
                        },
                        { 	// sub-level 2
                            "question": qsTr("How small is Mercury compared to other planets in our Solar System?"),
                            "options": [qsTr("Smallest"), qsTr("Second smallest"), qsTr("Third smallest"), qsTr("Fifth smallest")],
                            "closeness": [100, 75.3, 50.5, 1]
                        },
                        { 	// sub-level 3
                            "question": qsTr("How many moons has Mercury?"),
                            "options": ["5", "200", "0", "10"],
                            "closeness": [97.5, 1, 100, 95]
                        },
                        { 	// sub-level 4
                            "question": qsTr("The maximum temperature on Mercury is:"),
                            "options": [qsTr("50 °C"), qsTr("35 °C"), qsTr("427 °C"), qsTr("273 °C")],
                            "closeness": [4.8, 1, 100, 61]
                        },
                        { 	// sub-level 5
                            "question": qsTr("How many days make a year on Mercury?"),
                            "options": [qsTr("365 days"), qsTr("433 days"), qsTr("88 days"), qsTr("107 days")],
                            "closeness": [20.5, 1, 100, 94.5]
                        },
                        { 	// sub-level 6
                            "question": qsTr("How long is a day on Mercury?"),
                            "options": [qsTr("50 Earth days"), qsTr("365 Earth days"), qsTr("59 Earth days"), qsTr("107 Earth days")],
                            "closeness": [97, 1, 100, 84.4]
                        }
                    ]
                },
                {
                    "realImg": "qrc:/gcompris/src/activities/solar_system/resource/venus.png",
                    "bodyName": qsTr("Venus"),
                    "bodySize": 0.22,
                    "temperatureHint": qsTr("The maximum temperature on Earth is 58 °C."),
                    "lengthOfYearHint": qsTr("The length of a year on Earth is 365 days."),
                    "levels": [
                        { 	// sub-level 1
                            "question": qsTr("At which position is Venus in the Solar System?"),
                            "options": [qsTr("Seventh"), qsTr("Sixth"), qsTr("Second"), qsTr("Fourth")],
                            "closeness": [1, 20.8, 100, 60.4]
                        },
                        { 	// sub-level 2
                            "question": qsTr("Venus is as heavy as:"),
                            "options": [qsTr("0.7 Earths"), qsTr("0.8 Earths"), qsTr("1.3 Earths"), qsTr("2.5 Earths")],
                            "closeness": [94, 100, 71, 1]
                        },
                        { 	// sub-level 3
                            "question": qsTr("How large is Venus compared to other planets in our Solar System?"),
                            "options": [qsTr("Seventh largest"), qsTr("Sixth largest"), qsTr("Fifth largest"), qsTr("Fourth largest")],
                            "closeness": [50.5, 100, 50.5, 1]
                        },
                        { 	// sub-level 4
                            "question": qsTr("How long is a year on Venus?"),
                            "options": [qsTr("225 days"), qsTr("365 days"), qsTr("116 days"), qsTr("100 days")],
                            "closeness": [100, 1, 23, 11.6]
                        },
                        { 	// sub-level 5
                            "question": qsTr("How long is a day on Venus?"),
                            "options": [qsTr("117 Earth days"), qsTr("365 Earth days"), qsTr("88 Earth days"), qsTr("107 Earth days")],
                            "closeness": [100, 1, 88.8, 96.4]
                        },
                        { 	// sub-level 6
                            "question": qsTr("The maximum temperature on Venus is:"),
                            "options": [qsTr("100 °C"), qsTr("20 °C"), qsTr("467 °C"), qsTr("45 °C")],
                            "closeness": [18.7, 1, 100, 6.5]
                        },
                        {   // sub-level 7
                            "question": qsTr("How many moons has Venus?"),
                            "options": ["5", "10", "2", "0"],
                            "closeness": [63, 1, 100, 75.3]
                        }
                    ]
                },
                {
                    "realImg": "qrc:/gcompris/src/activities/solar_system/resource/earth.png",
                    "bodyName": qsTr("Earth"),
                    "bodySize": 0.3,
                    "temperatureHint": qsTr("The maximum temperature on Mars is 20 °C."),
                    "lengthOfYearHint": qsTr("The length of a year on Venus is 225 days."),
                    "levels": [
                        { 	// sub-level 1
                            "question": qsTr("At which position is Earth in the Solar System?"),
                            "options": [qsTr("Sixth"), qsTr("Third"), qsTr("First"), qsTr("Fifth")],
                            "closeness": [1, 100, 35, 35]
                        },
                        { 	// sub-level 2
                            "question": qsTr("How long does it take for Earth to complete one year?"),
                            "options": [qsTr("200 days"), qsTr("30 days"), qsTr("7 days"), qsTr("365 days")],
                            "closeness": [54.3, 7.3, 1, 100]
                        },
                        { 	// sub-level 3
                            "question": qsTr("How many moons has Earth?"),
                            "options": ["1", "5", "2", "3"],
                            "closeness": [100, 15, 75, 50.5]
                        },
                        { 	// sub-level 4
                            "question": qsTr("How long is a day on Earth?"),
                            "options": [qsTr("12 hours"), qsTr("24 hours"), qsTr("365 hours"), qsTr("48 hours")],
                            "closeness": [96.5, 100, 1, 93]
                        },
                        { 	// sub-level 5
                            "question": qsTr("How many seasons has Earth?"),
                            "options": ["2", "4", "6", "1"],
                            "closeness": [34, 100, 34, 1]
                        },
                        { 	// sub-level 6
                            "question": qsTr("Maximum temperature on Earth is:"),
                            "options": [qsTr("100 °C"), qsTr("58 °C"), qsTr("30 °C"), qsTr("45 °C")],
                            "closeness": [1, 100, 33, 69.3]
                        },
                        {   // sub-level 7
                            "question": qsTr("How large is Earth compared to other planets in our Solar System?"),
                            "options": [qsTr("Seventh largest"), qsTr("Sixth largest"), qsTr("Fifth largest"), qsTr("Fourth largest")],
                            "closeness": [1, 50.5, 100, 50.5]
                        }
                    ]
                },
                {
                    "realImg": "qrc:/gcompris/src/activities/solar_system/resource/mars.png",
                    "bodyName": qsTr("Mars"),
                    "bodySize": 0.15,
                    "temperatureHint": qsTr("The maximum temperature on Earth is 58 °C."),
                    "lengthOfYearHint": qsTr("The length of a year on Earth is 365 days."),
                    "levels": [
                        { 	// sub-level 1
                            "question": qsTr("At which position is Mars in the Solar System?"),
                            "options": [qsTr("Sixth"), qsTr("Fourth"), qsTr("First"), qsTr("Fifth")],
                            "closeness": [34, 100, 1, 67]
                        },
                        { 	// sub-level 2
                            "question": qsTr("The maximum temperature on Mars is:"),
                            "options": [qsTr("20 °C"), qsTr("35 °C"), qsTr("100 °C"), qsTr("60 °C")],
                            "closeness": [100, 81.4, 1, 51.5]
                        },
                        { 	// sub-level 3
                            "question": qsTr("How big is the size of Mars compared to Earth?"),
                            "options": [qsTr("The same"), qsTr("Half"), qsTr("Two times"), qsTr("Three times")],
                            "closeness": [80, 100, 40.6, 1]
                        },
                        { 	// sub-level 4
                            "question": qsTr("How many moons has Mars?"),
                            "options": ["1", "5", "2", "3"],
                            "closeness": [67, 1, 100, 50.5]
                        },
                        { 	// sub-level 5
                            "question": qsTr("How long is a day on Mars?"),
                            "options": [qsTr("12 hours"), qsTr("24 hours"), qsTr("24.5 hours"), qsTr("48 hours")],
                            "closeness": [47.3, 91, 100, 1]
                        },
                        { 	// sub-level 6
                            "question": qsTr("How long does it take for Mars to complete one year?"),
                            "options": [qsTr("687 days"), qsTr("30 days"), qsTr("7 days"), qsTr("365 days")],
                            "closeness": [100, 4.3, 1, 53]
                        },
                        {   // sub-level 7
                            "question": qsTr("How small is Mars compared to other planets in our Solar System?"),
                            "options": [qsTr("Smallest"), qsTr("Second smallest"), qsTr("Third smallest"), qsTr("Fifth smallest")],
                            "closeness": [67, 100, 67, 1]
                        }
                    ]
                },
                {
                    "realImg": "qrc:/gcompris/src/activities/solar_system/resource/jupiter.png",
                    "bodyName": qsTr("Jupiter"),
                    "bodySize": 1,
                    "temperatureHint": qsTr("The maximum temperature on Mars is 20 °C."),
                    "lengthOfYearHint": qsTr("The length of a year on Saturn is 29.5 Earth years."),
                    "levels": [
                        { 	// sub-level 1
                            "question": qsTr("At which position is Jupiter in the Solar System?"),
                            "options": [qsTr("Sixth"), qsTr("Fifth"), qsTr("First"), qsTr("Fourth")],
                            "closeness": [75, 100, 1, 75]
                        },
                        { 	// sub-level 2
                            "question": qsTr("How large is Jupiter compared to other planets in the Solar System?"),
                            "options": [qsTr("Third largest"), qsTr("Largest"), qsTr("Fifth largest"), qsTr("Second largest")],
                            "closeness": [50.5, 100, 1, 75]
                        },
                        { 	// sub-level 3
                            "question": qsTr("The minimum temperature on Jupiter is:"),
                            "options": [qsTr("-145 °C"), qsTr("100 °C"), qsTr("50 °C"), qsTr("-180 °C")],
                            "closeness": [100, 63, 24.7, 1]
                        },
                        { 	// sub-level 4
                            "question": qsTr("How many moons has Jupiter?"),
                            "options": ["1", "20", "25", "53"],
                            "closeness": [1, 37, 46.7, 100]
                        },
                        { 	// sub-level 5
                            "question": qsTr("How long is one day on Jupiter?"),
                            "options": [qsTr("10 hours"), qsTr("24 hours"), qsTr("12 hours"), qsTr("48 hours")],
                            "closeness": [100, 63.5, 94.8, 1]
                        },
                        { 	// sub-level 6
                            "question": qsTr("How long does it take for Jupiter to complete one year?"),
                            "options": [qsTr("5 Earth years"), qsTr("12 Earth years"), qsTr("30 Earth years"), qsTr("1 Earth year")],
                            "closeness": [61.5, 100, 1, 39.5]
                        }
                    ]
                },
                {
                    "realImg": "qrc:/gcompris/src/activities/solar_system/resource/saturn.png",
                    "bodyName": qsTr("Saturn"),
                    "bodySize": 1.2,
                    "temperatureHint": qsTr("The minimum temperature on Jupiter is -145 °C."),
                    "lengthOfYearHint": qsTr("The length of a year on Jupiter is 12 Earth years."),
                    "levels": [
                        { 	// sub-level 1
                            "question": qsTr("At which position is Saturn in the Solar System?"),
                            "options": [qsTr("Sixth"), qsTr("Fourth"), qsTr("First"), qsTr("Fifth")],
                            "closeness": [100, 60.4, 1, 80]
                        },
                        { 	// sub-level 2
                            "question": qsTr("How large is Saturn compared to other planets in the Solar System?"),
                            "options": [qsTr("Third largest"), qsTr("Largest"), qsTr("Fifth largest"), qsTr("Second largest")],
                            "closeness": [67, 67, 1, 100]
                        },
                        { 	// sub-level 3
                            "question": qsTr("How many moons has Saturn?"),
                            "options": ["120", "1", "150", "200"],
                            "closeness": [80, 1, 100, 60.8]
                        },
                        { 	// sub-level 4
                            "question": qsTr("How long is one day on Saturn?"),
                            "options": [qsTr("10.5 hours"), qsTr("24 hours"), qsTr("12 hours"), qsTr("48 hours")],
                            "closeness": [100, 64.3, 96, 1]
                        },
                        { 	// sub-level 5
                            "question": qsTr("The minimum temperature on Saturn is:"),
                            "options": [qsTr("0 °C"), qsTr("100 °C"), qsTr("-178 °C"), qsTr("-100 °C")],
                            "closeness": [36.6, 1, 100, 72]
                        },
                        { 	// sub-level 6
                            "question": qsTr("How long does it take for Saturn to complete one year?"),
                            "options": [qsTr("29.5 Earth years"), qsTr("20 Earth years"), qsTr("10 Earth years"), qsTr("1 Earth year")],
                            "closeness": [100, 67, 32, 1]
                        }
                    ]
                },
                {
                    "realImg": "qrc:/gcompris/src/activities/solar_system/resource/uranus.png",
                    "bodyName": qsTr("Uranus"),
                    "bodySize": 0.5,
                    "temperatureHint": qsTr("The temperature on Saturn is -178 °C."),
                    "lengthOfYearHint": qsTr("The length of a year on Saturn is 29.5 Earth years."),
                    "levels": [
                        { 	// sub-level 1
                            "question": qsTr("At which position is Uranus in the Solar System?"),
                            "options": [qsTr("Seventh"), qsTr("Fourth"), qsTr("Eighth"), qsTr("Fifth")],
                            "closeness": [100, 1, 67, 34]
                        },
                        { 	// sub-level 2
                            "question": qsTr("How many years does it take for Uranus to go once around the Sun?"),
                            "options": [qsTr("1 year"), qsTr("24 years"), qsTr("68 years"), qsTr("84 years")],
                            "closeness": [1, 28.4, 81, 100]
                        },
                        { 	// sub-level 3
                            "question": qsTr("How many moons has Uranus?"),
                            "options": ["120", "87", "27", "50"],
                            "closeness": [1, 36, 100, 75.5]
                        },
                        { 	// sub-level 4
                            "question": qsTr("How long is one day on Uranus?"),
                            "options": [qsTr("10 hours"), qsTr("27 hours"), qsTr("17 hours"), qsTr("48 hours")],
                            "closeness": [77.6, 68, 100, 1]
                        },
                        { 	// sub-level 5
                            "question": qsTr("How large is Uranus compared to other planets in the Solar System?"),
                            "options": [qsTr("Third largest"), qsTr("Largest"), qsTr("Seventh largest"), qsTr("Second largest")],
                            "closeness": [100, 50.5, 1, 75]
                        },
                        { 	// sub-level 6
                            "question": qsTr("The maximum temperature on Uranus is:"),
                            "options": [qsTr("100 °C"), qsTr("-216 °C"), qsTr("0 °C"), qsTr("-100 °C")],
                            "closeness": [1, 100, 32.3, 63.6]
                        }
                    ]
                },
                {
                    "realImg": "qrc:/gcompris/src/activities/solar_system/resource/neptune.png",
                    "bodyName": qsTr("Neptune"),
                    "bodySize": 0.4,
                    "temperatureHint": qsTr("The maximum temperature on Saturn is -178 °C."),
                    "lengthOfYearHint": qsTr("The length of a year on Uranus is 84 years."),
                    "levels": [
                        { 	// sub-level 1
                            "question": qsTr("At which position is Neptune in the Solar System?"),
                            "options": [qsTr("Seventh"), qsTr("Fourth"), qsTr("Eighth"), qsTr("Fifth")],
                            "closeness": [75, 1, 100, 25.7]
                        },
                        { 	// sub-level 2
                            "question": qsTr("How long does it take for Neptune to make one revolution around the Sun?"),
                            "options": [qsTr("165 years"), qsTr("3 years"), qsTr("100 years"), qsTr("1 year")],
                            "closeness": [100, 2, 60.7, 1]
                        },
                        { 	// sub-level 3
                            "question": qsTr("How many moons has Neptune?"),
                            "options": ["120", "87", "14", "50"],
                            "closeness": [1, 31.8, 100, 66.3]
                        },
                        { 	// sub-level 4
                            "question": qsTr("How long is one day on Neptune?"),
                            "options": [qsTr("16 hours"), qsTr("27 hours"), qsTr("17 hours"), qsTr("48 hours")],
                            "closeness": [100, 66, 97, 1]
                        },
                        { 	// sub-level 5
                            "question": qsTr("The average temperature on Neptune is:"),
                            "options": [qsTr("100 °C"), qsTr("30 °C"), qsTr("-210 °C"), qsTr("-100 °C")],
                            "closeness": [1, 23, 100, 64]
                        },
                        { 	// sub-level 6
                            "question": qsTr("How large is Neptune compared to other planets in the Solar System?"),
                            "options": [qsTr("Fourth largest"), qsTr("Largest"), qsTr("Third largest"), qsTr("Second largest")],
                            "closeness": [100, 1, 67, 34]
                        }
                    ]
                }
            ];
}
