/* GCompris
 *
 * Copyright (C) 2014 Bruno Coudoin
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

var url = "qrc:/gcompris/src/activities/memory/resource/"

var images = [
                [url + '01_cat.png', url + '01_cat.png'],
                [url + '02_pig.png', url + '02_pig.png'],
                [url + '03_bear.png', url + '03_bear.png'],
                [url + '04_hippopotamus.png', url + '04_hippopotamus.png'],
                [url + '05_penguin.png', url + '05_penguin.png'],
                [url + '06_cow.png', url + '06_cow.png'],
                [url + '07_sheep.png', url + '07_sheep.png'],
                [url + '08_turtle.png', url + '08_turtle.png'],
                [url + '09_panda.png', url + '09_panda.png'],
                [url + '10_chicken.png', url + '10_chicken.png'],
                [url + '11_redbird.png', url + '11_redbird.png'],
                [url + '12_wolf.png', url + '12_wolf.png'],
                [url + '13_monkey.png', url + '13_monkey.png'],
                [url + '14_fox.png', url + '14_fox.png'],
                [url + '15_bluebirds.png', url + '15_bluebirds.png'],
                [url + '16_elephant.png', url + '16_elephant.png'],
                [url + '17_lion.png', url + '17_lion.png'],
                [url + '18_gnu.png', url + '18_gnu.png'],
                [url + '19_bluebaby.png', url + '19_bluebaby.png'],
                [url + '20_greenbaby.png', url + '20_greenbaby.png'],
                [url + '21_frog.png', url + '21_frog.png']
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
