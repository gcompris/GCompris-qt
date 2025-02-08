/* GCompris
 *
 * SPDX-FileCopyrightText: 2024 Nidhish Chauhan <rch246chauhan@gmail.com>
 *
 * Authors:
 *   Nidhish Chauhan <rch246chauhan@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

QtObject {
    property string backgroundImage: "qrc:/gcompris/src/activities/explore_monuments/resource/china/china.svg"
    property var tab: [
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Forbidden City"),
            "text": qsTr("The Forbidden City, located in the heart of Beijing, China, is a magnificent imperial palace complex that served as the home of Chinese emperors and the political center of the nation for nearly 500 years, from the Ming dynasty (1368–1644) to the end of the Qing dynasty (1644–1912). Built between 1406 and 1420, this sprawling architectural masterpiece spans 180 acres and features over 980 preserved buildings with 8,700 rooms, showcasing traditional Chinese palatial design. Surrounded by a moat and a massive wall, the Forbidden City was once inaccessible to the general public, symbolizing imperial power and exclusivity."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/china/forbiddenCity.webp",
            "text2": qsTr("Forbidden City"),
            "x": "0.689",
            "y": "0.450 ",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Leshan Giant Buddha"),
            "text": qsTr("The Leshan Giant Buddha, located in Sichuan Province, China, is a colossal statue carved into a cliff at the confluence of the Min, Dadu, and Qingyi rivers. Standing at 71 meters (233 feet), it is the tallest pre-modern statue in the world and a UNESCO World Heritage Site. Built during the Tang Dynasty (713–803 AD), the statue represents Maitreya, the Buddha of the future, and was created to calm the turbulent waters threatening local boat traffic. Ingeniously designed, the statue includes a hidden drainage system to prevent erosion. Its serene expression and intricate craftsmanship make it a symbol of spiritual and artistic achievement."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/china/leshanGiantBuddha.webp",
            "text2": qsTr("Leshan Giant Buddha"),
            "x": "0.500",
            "y": "0.600",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Potala Palace"),
            "text": qsTr("The Potala Palace, perched on Red Hill in Lhasa, Tibet, is an iconic symbol of Tibetan culture and a UNESCO World Heritage Site. Originally built in the 7th century and expanded in the 17th century, it served as the winter residence of the Dalai Lamas and the center of Tibetan governance. Rising 13 stories high with over 1,000 rooms, the palace combines intricate Tibetan architecture, vibrant murals, and sacred relics. It is divided into the White Palace, housing administrative areas, and the Red Palace, dedicated to religious studies and prayer. The Potala Palace stands as a testament to Tibet's spiritual and historical legacy."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/china/potalaPalace.webp",
            "text2": qsTr("Potala Palace"),
            "x": "0.300",
            "y": "0.600",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Terracotta Army"),
            "text": qsTr("The Terracotta Army is a collection of thousands of life-sized clay soldiers, horses, and chariots buried with China's first emperor, Qin Shi Huang, to accompany him in the afterlife. Discovered in 1974 near Xi'an, the figures date back to approximately 210 BCE and are celebrated for their incredible detail, with each warrior uniquely crafted to represent the diverse ranks and roles of an ancient Chinese army."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/china/terracottaArmy.webp",
            "text2": qsTr("Terracotta Army"),
            "x": "0.609",
            "y": "0.510 ",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Sun and Moon Pagodas"),
            "text": qsTr("The Sun and Moon Pagodas, located in Guilin, China, are iconic twin towers that symbolize the city's cultural and spiritual heritage. Originally built during the Tang Dynasty, they were reconstructed in the 20th century as striking landmarks on Shanhu Lake. The Sun Pagoda, standing 41 meters tall, is a bronze structure—the tallest of its kind in the world—while the Moon Pagoda, at 35 meters, is built of glazed tiles. These pagodas represent the harmony of yin and yang and are connected by an underwater glass tunnel. Illuminated at night, they are popular attractions showcasing traditional Chinese architecture and modern ingenuity."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/china/sunAndMoonPagodas.webp",
            "text2": qsTr("Sun and Moon Pagodas"),
            "x": "0.620",
            "y": "0.640",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Diaolou Towers"),
            "text": qsTr("The Diaolou Towers, found in Kaiping, Guangdong Province, China, are fortified multi-story structures built from the late 19th to early 20th centuries to protect against bandits and floods. Blending Western architectural styles like Romanesque and Baroque with traditional Chinese elements, they reflect the wealth and influence of overseas Chinese emigrants. Constructed with reinforced concrete, these towers symbolize a period of cultural and economic transition in rural China. Designated a UNESCO World Heritage Site in 2007, around 1,800 of the original 3,000 towers remain, offering insight into this unique architectural heritage."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/china/diaolouTowers.webp",
            "text2": qsTr("Diaolou Towers"),
            "x": "0.647",
            "y": "0.710",
            "height": "0.07",
            "width": "0.07"
        }
    ]

    property var instructions: [
        {
            "text": qsTr("Monuments of China")
        },
        {
            "text": qsTr("Click on the location of the given monument.")
        }
    ]
}
