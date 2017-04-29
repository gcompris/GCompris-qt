/* GCompris
 *
 * Copyright (C) 2015 Ayush Agrawal <ayushagrawal288@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Ayush Agrawal <ayushagrawal288@gmail.com> (Qt Quick port)
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
import QtQuick 2.6

QtObject {
    property string backgroundImage: "qrc:/gcompris/src/activities/explore_monuments/resource/india/indiabg.jpg"
    property var tab : [
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Golden Temple"),
            "text": qsTr("The Golden Temple Amritsar India (Sri Harimandir Sahib Amritsar) is not only a central religious place of the Sikhs, but also a symbol of human brotherhood and equality. Everybody, irrespective of cast, creed or race can seek spiritual solace and religious fulfillment without any hindrance. It also represents the distinct identity, glory and heritage of the Sikhs. To pen-down the philosophy, ideology, the inner and outer beauty, as well as the historical legacy of Sri Harimandir Sahib is a momentous task. It is a matter of experience rather than a of description."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/india/goldenTemple.jpg",
            "text2" : qsTr("Golden Temple"),
            "x": "0.256",
            "y": "0.206",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Hawa Mahal"),
            "text": qsTr("Hawa Mahal, is a palace in Jaipur, India, so named because it was essentially a high screen wall built so the women of the royal household could observe street festivals while unseen from the outside. Constructed of red and pink sandstone, the palace sits on the edge of the City Palace, and extends to the zenana, or women's chambers."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/india/hawaMahal.jpg",
            "text2" : qsTr("Hawa Mahal"),
            "x": "0.230",
            "y": "0.290",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Taj Mahal"),
            "text": qsTr("The Taj Mahal is a white marble mausoleum located on the southern bank of the Yamuna River in the Indian city of Agra. It was commissioned in 1632 by the Mughal emperor Shah Jahan reigned to house the tomb of his favorite wife of three, Mumtaz Mahal."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/india/tajMahal.jpg",
            "text2" : qsTr("Taj Mahal"),
            "x": "0.416",
            "y": "0.298",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Gateway of India"),
            "text": qsTr("The Gateway of India is one of India's most unique landmarks situated in the city of Mumbai. The colossal structure was constructed in 1924. Located at the tip of Apollo Bunder, the gateway overlooks the Mumbai harbor, bordered by the Arabian Sea in the Colaba district. The Gateway of India is a monument that marks India's chief ports and is a major tourist attraction for visitors who arrive in India for the first time."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/india/gatewayofIndia.jpg",
            "text2" : qsTr("Gateway of India"),
            "x": "0.179",
            "y": "0.540",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Great Stupa"),
            "text": qsTr("The Great Stupa at Sanchi is the oldest stone structure in India and was originally commissioned by the emperor Ashoka the Great in the 3rd century BCE. Its nucleus was a simple hemispherical brick structure built over the relics of the Buddha. It was crowned by the chatra, a parasol-like structure symbolizing high rank, which was intended to honor and shelter the relics."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/india/greatStupa.jpg",
            "text2" : qsTr("Great Stupa"),
            "x": "0.329",
            "y": "0.396",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Ajanta Caves"),
            "text": qsTr("Ajanta is world's greatest historical monument recognized by UNESCO located just 55kms from Jalgaon city and 105kms from Aurangabad City of Maharashtra, India. There are 30 caves in Ajanta of which 9, 10, 19, 26 and 29 are chaitya-grihas and the rest are monasteries."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/india/ajantaCave.jpg",
            "text2" : qsTr("Ajanta Caves"),
            "x": "0.304",
            "y": "0.502",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Konark Sun Temple"),
            "text": qsTr("The Konark Sun Temple (also spelled Konarak) is a 13th-century Hindu temple dedicated to the Sun god. Shaped like a giant chariot, the temple is known for the exquisite stone carvings that cover the entire structure."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/india/konarkSunTemple.jpg",
            "text2" : qsTr("Konark Sun Temple"),
            "x": "0.506",
            "y": "0.538",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Mysore Palace"),
            "text": qsTr("Mysore Palace or Mysore Maharaja Palace is one of the largest and most spectacular monuments in the country. Also known as Amba Vilas, it is located in the heart of the city of Mysore. The palace was initially built by the Wodeyar kings in the 14th century."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/india/mysorePalace.jpg",
            "text2" : qsTr("Mysore Palace"),
            "x": "0.295",
            "y": "0.748",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Charminar"),
            "text": qsTr("The Charminar in Hyderabad was constructed in 1591 by Mohammed Quli Qutab Shah. He built the Charminar to mark the end of plague in the Hyderabad city. Since the construction of the Charminar, the Hyderabad city has almost become synonymous with the monument. The Charminar is a massive and impressive structure with four minarets. In the evening, with illumination, the great Charminar looks even greater."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/india/charminar.jpg",
            "text2" : qsTr("Charminar"),
            "x": "0.360",
            "y": "0.588",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Victoria Memorial"),
            "text": qsTr("The Victoria Memorial was built to commemorate the peak of the British Empire in India. The Victoria Memorial, conceived by Lord Curzon, represents the architectural climax of Kolkata city. Lord Curzon, the then Viceroy specified its classical style but the actual plan of Victoria Memorial was laid down by the well-known architect, Sir William Emerson. The Victoria Memorial blends the best of the British and Mughal architecture. The Victoria Memorial hall was built with white Makrana marbles."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/india/victoriaMemorials.jpg",
            "text2" : qsTr("Victoria Memorial"),
            "x": "0.670",
            "y": "0.414",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Rang Ghar"),
            "text": qsTr("The Rang Ghar is a two-storied building which once served as the royal sports-pavilion where Ahom kings and nobles were spectators at games like buffalo fights and other sports at Rupahi Pathar - particularly during the Rongali Bihu festival in the Ahom capital of Rangpur."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/india/rangGhar.jpg",
            "text2" : qsTr("Rang Ghar"),
            "x": "0.860",
            "y": "0.306",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Qutub Minar"),
            "text": qsTr("Qutub Minar at 74 meters, is the tallest brick minaret in the world, and the second tallest minar in India after Fateh Burj at Mohali. Qutub Minar, along with the ancient and medieval monuments surrounding it, form the Qutb Complex, which is a UNESCO World Heritage Site. The tower is located in the Mehrauli area of Delhi, India. Made of red sandstone and marble."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/india/qutubMinar.jpg",
            "text2" : qsTr("Qutub Minar"),
            "x": "0.328",
            "y": "0.254",
            "height": "0.07",
            "width": "0.07"
        }
    ]

    property var instructions : [
        {
            "text": qsTr("Monuments of India")
        },
        {
            "text": qsTr("Click on location where the given monument is located.")
        }
    ]
}
