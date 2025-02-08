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
    property string backgroundImage: "qrc:/gcompris/src/activities/explore_monuments/resource/italy/italy.svg"
    property var tab: [
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("The Pantheon"),
            "text": qsTr("The Pantheon in Rome, Italy, is an iconic ancient temple built around 126 AD during Emperor Hadrian's reign, on the site of earlier structures commissioned by Marcus Agrippa. Renowned for its architectural brilliance, it features a massive domed roof with a central oculus, symbolizing the heavens, allowing natural light to illuminate the interior. Originally dedicated to all Roman gods, it was later converted into a Christian church, known as the Basilica of St. Mary and the Martyrs (Santa Maria ad Martyres), in 609 AD. Its dome, the largest unreinforced concrete dome in the world, showcases remarkable engineering and symmetry, inspiring architects for centuries. The Pantheon’s harmonious proportions and historical significance make it a timeless masterpiece of classical architecture."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/italy/pantheon.webp",
            "text2": qsTr("The Pantheon"),
            "x": "0.500",
            "y": "0.500",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Duomo Di Milano"),
            "text": qsTr("The Duomo di Milano, also known as the Milan Cathedral, is an iconic Gothic masterpiece located in the heart of Milan, Italy. Constructed over nearly six centuries, it is one of the largest cathedrals in the world and a symbol of Milan's artistic and cultural heritage. Its intricate façade is adorned with countless statues, spires, and gargoyles, reflecting the grandeur of Gothic architecture. Visitors can explore its stunning interiors, featuring beautiful stained glass windows and intricate marble details, or ascend to the rooftop for breathtaking views of the city and the Alps. The Duomo stands as a testament to Italy's rich history and architectural brilliance."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/italy/duomoDiMilano.webp",
            "text2": qsTr("Duomo Di Milano"),
            "x": "0.220",
            "y": "0.200",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Florence Cathedral"),
            "text": qsTr("The Florence Cathedral, officially known as the Cattedrale di Santa Maria del Fiore, is a renowned masterpiece of Gothic and Renaissance architecture located in Florence, Italy. Completed in 1436, it is famous for its massive red-tiled dome designed by Filippo Brunelleschi, which remains an engineering marvel and a symbol of the city. The cathedral's intricate marble facade, added in the 19th century, complements its richly decorated interior and artistic treasures. Together with Giotto’s Campanile and the Baptistery of St. John, it forms part of a UNESCO World Heritage Site, drawing millions of visitors annually for its historical, cultural, and architectural significance."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/italy/florenceCathedral.webp",
            "text2": qsTr("Florence Cathedral"),
            "x": "0.400",
            "y": "0.360",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Leaning Tower of Pisa"),
            "text": qsTr("The Leaning Tower of Pisa, located in the Italian city of Pisa, is a globally renowned architectural marvel. Constructed as the freestanding bell tower for the city's cathedral, it is famous for its unintended tilt, caused by unstable foundation soil. Begun in 1173, the tower's construction spanned nearly 200 years, during which efforts were made to stabilize its inclination. Standing at approximately 56 meters (183 feet), the tower's Romanesque design features eight stories, including a bell chamber, adorned with intricately carved columns and arches. Recognized as a UNESCO World Heritage Site, it remains a symbol of resilience and ingenuity."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/italy/leaningTowerOfPisa.webp",
            "text2": qsTr("Leaning Tower of Pisa"),
            "x": "0.320",
            "y": "0.360",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("St Mark's Basilica"),
            "text": qsTr("St. Mark's Basilica, located in Venice, Italy, is an iconic masterpiece of Byzantine architecture and one of the city's most famous landmarks. Originally built in 828 to house the relics of St. Mark the Evangelist, it was rebuilt in its current form in the 11th century. Known for its opulent design, the basilica features a blend of Eastern and Western influences, evident in its five domes, intricate mosaics, and ornate facade adorned with statues and carvings. The interior is richly decorated with gold mosaics and marble floors, showcasing the wealth and power of the Venetian Republic. Adjacent to St. Mark's Square, it remains a symbol of Venice's historical, cultural, and religious heritage."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/italy/stMarkBasilica.webp",
            "text2": qsTr("St Mark's Basilica"),
            "x": "0.480",
            "y": "0.200",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Pompeii"),
            "text": qsTr("Pompeii was an ancient Roman city located near modern-day Naples, Italy, famously preserved after being buried by the eruption of Mount Vesuvius in 79 AD. The eruption unleashed a deadly combination of ash, pumice, and pyroclastic flows, which engulfed the city and its inhabitants, preserving buildings, artifacts, and even human remains in incredible detail. Excavations of Pompeii have provided valuable insights into daily Roman life, architecture, and society, revealing a city with well-planned streets, homes, public baths, and temples. The site is now a UNESCO World Heritage Site and remains one of the most important archaeological discoveries in history."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/italy/pompeii.webp",
            "text2": qsTr("Pompeii"),
            "x": "0.645",
            "y": "0.600",
            "height": "0.07",
            "width": "0.07"
        }
    ]

    property var instructions: [
        {
            "text": qsTr("Monuments of Italy")
        },
        {
            "text": qsTr("Click on the location of the given monument.")
        }
    ]
}
