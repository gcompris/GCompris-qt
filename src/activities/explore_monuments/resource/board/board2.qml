/* GCompris
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
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
import QtQuick 2.0

QtObject {
    property string backgroundImage: "qrc:/gcompris/src/activities/explore_monuments/resource/india/background.png"
    //   property string instruction: qsTr("Drag and Drop the items to make them match")
    property var tab : [
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Golden Temple"),
            "text": qsTr("The Harmandir Sahib, also Darbar Sahib and informally referred to as the 'Golden Temple', is the holiest Sikh gurdwara located in the city of Amritsar, Punjab, India. The city was founded in 1574 by the fourth Sikh guru, Guru Ram Das. The Harmandir Sahib was designed by the fifth guru, Guru Arjan, who had the cornerstone laid by the Muslim Sufi saint Sai Hazrat Mian Mir on 28 December 1588. Guru Arjan completed the Adi Granth, the holy scripture of Sikhism, in 1604 and installed it in the gurdwara."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/india/goldenTemple.png",
            "text2" : qsTr("Golden Temple"),
            "x" : "0.256",
            "y" : "0.206",
            "height" : "0.07",
            "width" : "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Hawa Mahal"),
            "text": qsTr("Hawa Mahal, is a palace in Jaipur, India, so named because it was essentially a high screen wall built so the women of the royal household could observe street festivals while unseen from the outside. Constructed of red and pink sandstone, the palace sits on the edge of the City Palace, and extends to the zenana, or women's chambers."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/india/hawaMahal.PNG",
            "text2" : qsTr("Hawa Mahal"),
            "x" : "0.230",
            "y" : "0.290",
            "height" : "0.07",
            "width" : "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Taj Mahal"),
            "text": qsTr("The Taj Mahal  is a white marble mausoleum located on the southern bank of the Yamuna River in the Indian city of Agra. It was commissioned in 1632 by the Mughal emperor Shah Jahan reigned to house the tomb of his favorite wife of three, Mumtaz Mahal."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/india/tajMahal.PNG",
            "text2" : qsTr("Taj Mahal"),
            "x" : "0.416",
            "y" : "0.298",
            "height" : "0.07",
            "width" : "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Gateway of India"),
            "text": qsTr("The Gateway of India is a monument built during the British Rule in Mumbai City of Maharashtra state in Western India. It is located on the waterfront in the Apollo Bunder area in South Mumbai and overlooks the Arabian Sea. The structure is a basalt arch, 26 metres (85 feet) high. It lies at the end of Chhatrapati Shivaji Marg at the water's edge in Mumbai Harbour. It was a crude jetty used by the fishing community which was later renovated and used as a landing place for British governors and other prominent people. In earlier times, it would have been the first structure that visitors arriving by boat in Mumbai would have seen."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/india/gatewayofIndia.PNG",
            "text2" : qsTr("Gateway of India"),
            "x" : "0.179",
            "y" : "0.540",
            "height" : "0.07",
            "width" : "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Great Stupa"),
            "text": qsTr("The Great Stupa at Sanchi is the oldest stone structure in India and was originally commissioned by the emperor Ashoka the Great in the 3rd century BCE. Its nucleus was a simple hemispherical brick structure built over the relics of the Buddha. It was crowned by the chatra, a parasol-like structure symbolising high rank, which was intended to honour and shelter the relics."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/india/greatStupa.PNG",
            "text2" : qsTr("Great Stupa"),
            "x" : "0.329",
            "y" : "0.396",
            "height" : "0.07",
            "width" : "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Ajanta Caves"),
            "text": qsTr("The Ajanta Caves in Aurangabad district of Maharashtra state of India are about 30 rock-cut Buddhist cave monuments which date from the 2nd century BCE to about 480 or 650 CE. The caves include paintings and sculptures described by the government Archaeological Survey of India as 'the finest surviving examples of Indian art, particularly painting', which are masterpieces of Buddhist religious art, with figures of the Buddha and depictions of the Jataka tales."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/india/ajantaCave.PNG",
            "text2" : qsTr("Ajanta Caves"),
            "x" : "0.304",
            "y" : "0.502",
            "height" : "0.07",
            "width" : "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Konark Sun Temple"),
            "text": qsTr("Konark Sun Temple is a 13th-century Sun Temple at Konark in Odisha, India. It is believed that the temple was built by king Narasimhadeva I of Eastern Ganga Dynasty around 1250 CE. The temple is in the shape of a gigantic chariot elaborately carved stone wheels, pillars and walls. A major part of the structure is now in ruins. The temple is a UNESCO World Heritage Site and has also featured on various list of Seven Wonders of India."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/india/konarkSunTemple.PNG",
            "text2" : qsTr("Konark Sun Temple"),
            "x" : "0.506",
            "y" : "0.538",
            "height" : "0.07",
            "width" : "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Mysore Palace"),
            "text": qsTr("The Palace of Mysore is a historical palace in the city of Mysore in Karnataka, southern India. It is the official residence and seat of the Wodeyars — the Maharajas of Mysore, the royal family of Mysore, who ruled the princely state from 1350 to 1950. The palace houses two durbar halls (ceremonial meeting halls of the royal court) and incorporates a mesmerizing and gigantic array of courtyards, gardens, and buildings. The palace is in the central region of inner Mysore, facing the Chamundi Hills eastward."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/india/mysorePalace.png",
            "text2" : qsTr("Mysore Palace"),
            "x" : "0.295",
            "y" : "0.748",
            "height" : "0.07",
            "width" : "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Charminar"),
            "text": qsTr("The Charminar, constructed in 1591 CE, is a monument and mosque located in Hyderabad, Telangana, India. The landmark has become a global icon of Hyderabad, listed among the most recognized structures of India. The Charminar is situated on the east bank of Musi river. To the west lies the Laad Bazaar, and to the southwest lies the richly ornamented granite Makkah Masjid. It is listed as an archaeological and architectural treasure on the official 'List of Monuments' prepared by the Archaeological Survey of India under the The Ancient Monuments and Archaeological Sites and Remains Act."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/india/charminar.PNG",
            "text2" : qsTr("Charminar"),
            "x" : "0.360",
            "y" : "0.588",
            "height" : "0.07",
            "width" : "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Victoria Memorial"),
            "text": qsTr("The Victoria Memorial is a large marble building in Kolkata (Calcutta), West Bengal, India which was built between 1906 and 1921. It is dedicated to the memory of Queen Victoria (1819–1901) and is now a museum and tourist destination under the auspices of the Ministry of Culture. The Memorial lies on the Maidan (grounds) by the bank of the Hooghly River, near Jawaharlal Nehru road."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/india/victoriaMemorials.PNG",
            "text2" : qsTr("Victoria Memorial"),
            "x" : "0.670",
            "y" : "0.414",
            "height" : "0.07",
            "width" : "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Rang Ghar"),
            "text": qsTr("The Rang Ghar is a two-storied building which once served as the royal sports-pavilion where Ahom kings and nobles were spectators at games like buffalo fights and other sports at Rupahi Pathar - particularly during the Rongali Bihu festival in the Ahom capital of Rangpur."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/india/rangGhar.PNG",
            "text2" : qsTr("Rang Ghar"),
            "x" : "0.860",
            "y" : "0.306",
            "height" : "0.07",
            "width" : "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Qutub Minar"),
            "text": qsTr("Qutub Minar at 74 meters, is the tallest brick minaret in the world, and the second tallest minar in India after Fateh Burj at Mohali. Qutub Minar, along with the ancient and medieval monuments surrounding it, form the Qutb Complex, which is a UNESCO World Heritage Site. The tower is located in the Mehrauli area of Delhi, India. Made of red sandstone and marble."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/india/qutubMinar.PNG",
            "text2" : qsTr("Qutub Minar"),
            "x" : "0.328",
            "y" : "0.254",
            "height" : "0.07",
            "width" : "0.07"
        }
    ]

    property var instructions : [
        {
            "text": qsTr("Monuments of India.")
        },
        {
            "text": qsTr("Click on location where the given Monument is located.")
        }
    ]
}
