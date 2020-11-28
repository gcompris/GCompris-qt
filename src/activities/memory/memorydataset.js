/* GCompris
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

var url = "qrc:/gcompris/src/activities/memory/resource/"

var images = [
                [url + '01_cat.svg', url + '01_cat.svg'],
                [url + '02_pig.svg', url + '02_pig.svg'],
                [url + '03_bear.svg', url + '03_bear.svg'],
                [url + '04_hippopotamus.svg', url + '04_hippopotamus.svg'],
                [url + '05_penguin.svg', url + '05_penguin.svg'],
                [url + '06_cow.svg', url + '06_cow.svg'],
                [url + '07_sheep.svg', url + '07_sheep.svg'],
                [url + '08_turtle.svg', url + '08_turtle.svg'],
                [url + '09_panda.svg', url + '09_panda.svg'],
                [url + '10_chicken.svg', url + '10_chicken.svg'],
                [url + '11_redbird.svg', url + '11_redbird.svg'],
                [url + '12_wolf.svg', url + '12_wolf.svg'],
                [url + '13_monkey.svg', url + '13_monkey.svg'],
                [url + '14_fox.svg', url + '14_fox.svg'],
                [url + '15_bluebirds.svg', url + '15_bluebirds.svg'],
                [url + '16_elephant.svg', url + '16_elephant.svg'],
                [url + '17_lion.svg', url + '17_lion.svg'],
                [url + '18_gnu.svg', url + '18_gnu.svg'],
                [url + '19_bluebaby.svg', url + '19_bluebaby.svg'],
                [url + '20_greenbaby.svg', url + '20_greenbaby.svg'],
                [url + '21_frog.svg', url + '21_frog.svg']
            ]

var memory_cards = [
            { // Level 1
                columns: 3,
                rows: 2,
                images: images
            },
            { // Level 2
                columns: 4,
                rows: 2,
                images: images
            },
            { // Level 3
                columns: 5,
                rows: 2,
                images: images
            },
            { // Level 4
                columns: 4,
                rows: 3,
                images: images
            },
            { // Level 5
                columns: 6,
                rows: 3,
                images: images
            },
            { // Level 6
                columns: 5,
                rows: 4,
                images: images
            }
        ]

function get() {
    return memory_cards
}
