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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6

QtObject {
   property string instruction: qsTr("Districts of Turkey")
   property var levels: [
      {
         "pixmapfile" : "turkey/turkey.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "turkey/van.png",
         "toolTipText" : "Van",
         "x" : "0.85",
         "y" : "0.495"
      },
      {
         "pixmapfile" : "turkey/tunceli.png",
         "toolTipText" : "Tunceli",
         "x" : "0.677",
         "y" : "0.449"
      },
      {
         "pixmapfile" : "turkey/trabzon.png",
         "toolTipText" : "Trabzon",
         "x" : "0.686",
         "y" : "0.269"
      },
      {
         "pixmapfile" : "turkey/tokat.png",
         "toolTipText" : "Tokat",
         "x" : "0.553",
         "y" : "0.331"
      },
      {
         "pixmapfile" : "turkey/sivas.png",
         "toolTipText" : "Sivas",
         "x" : "0.579",
         "y" : "0.426"
      },
      {
         "pixmapfile" : "turkey/sirnak.png",
         "toolTipText" : "Sirnak",
         "x" : "0.803",
         "y" : "0.631"
      },
      {
         "pixmapfile" : "turkey/siirt.png",
         "toolTipText" : "Siirt",
         "x" : "0.791",
         "y" : "0.579"
      },
      {
         "pixmapfile" : "turkey/sanliurfa.png",
         "toolTipText" : "Sanliurfa",
         "x" : "0.659",
         "y" : "0.654"
      },
      {
         "pixmapfile" : "turkey/rize.png",
         "toolTipText" : "Rize",
         "x" : "0.728",
         "y" : "0.244"
      },
      {
         "pixmapfile" : "turkey/ordu.png",
         "toolTipText" : "Ordu",
         "x" : "0.589",
         "y" : "0.287"
      },
      {
         "pixmapfile" : "turkey/mus.png",
         "toolTipText" : "Mus",
         "x" : "0.778",
         "y" : "0.456"
      },
      {
         "pixmapfile" : "turkey/mardin.png",
         "toolTipText" : "Mardin",
         "x" : "0.736",
         "y" : "0.649"
      },
      {
         "pixmapfile" : "turkey/malatya.png",
         "toolTipText" : "Malatya",
         "x" : "0.621",
         "y" : "0.523"
      },
      {
         "pixmapfile" : "turkey/kilis.png",
         "toolTipText" : "Kilis",
         "x" : "0.576",
         "y" : "0.721"
      },
      {
         "pixmapfile" : "turkey/kars.png",
         "toolTipText" : "Kars",
         "x" : "0.814",
         "y" : "0.279"
      },
      {
         "pixmapfile" : "turkey/kahramanmaras.png",
         "toolTipText" : "Kahramanmaras",
         "x" : "0.569",
         "y" : "0.597"
      },
      {
         "pixmapfile" : "turkey/igdir.png",
         "toolTipText" : "Igdir",
         "x" : "0.86",
         "y" : "0.338"
      },
      {
         "pixmapfile" : "turkey/hatay.png",
         "toolTipText" : "Hatay",
         "x" : "0.543",
         "y" : "0.769"
      },
      {
         "pixmapfile" : "turkey/hakkari.png",
         "toolTipText" : "Hakkari",
         "x" : "0.869",
         "y" : "0.608"
      },
      {
         "pixmapfile" : "turkey/gumushane.png",
         "toolTipText" : "gümüshane",
         "x" : "0.664",
         "y" : "0.323"
      },
      {
         "pixmapfile" : "turkey/giresun.png",
         "toolTipText" : "Giresun",
         "x" : "0.632",
         "y" : "0.303"
      },
      {
         "pixmapfile" : "turkey/gaziantep.png",
         "toolTipText" : "Gaziantep",
         "x" : "0.583",
         "y" : "0.697"
      },
      {
         "pixmapfile" : "turkey/erzurum.png",
         "toolTipText" : "Erzurum",
         "x" : "0.752",
         "y" : "0.333"
      },
      {
         "pixmapfile" : "turkey/erzincan.png",
         "toolTipText" : "Erzincan",
         "x" : "0.67",
         "y" : "0.408"
      },
      {
         "pixmapfile" : "turkey/elazig.png",
         "toolTipText" : "Elazig",
         "x" : "0.667",
         "y" : "0.492"
      },
      {
         "pixmapfile" : "turkey/diyarbakir.png",
         "toolTipText" : "Diyarbakir",
         "x" : "0.708",
         "y" : "0.564"
      },
      {
         "pixmapfile" : "turkey/bitlis.png",
         "toolTipText" : "Bitlis",
         "x" : "0.796",
         "y" : "0.505"
      },
      {
         "pixmapfile" : "turkey/bingol.png",
         "toolTipText" : "Bingöl",
         "x" : "0.722",
         "y" : "0.462"
      },
      {
         "pixmapfile" : "turkey/bayburt.png",
         "toolTipText" : "Bayburt",
         "x" : "0.702",
         "y" : "0.326"
      },
      {
         "pixmapfile" : "turkey/batman.png",
         "toolTipText" : "Batman",
         "x" : "0.757",
         "y" : "0.564"
      },
      {
         "pixmapfile" : "turkey/artvin.png",
         "toolTipText" : "Artvin",
         "x" : "0.765",
         "y" : "0.231"
      },
      {
         "pixmapfile" : "turkey/ardahan.png",
         "toolTipText" : "Ardahan",
         "x" : "0.805",
         "y" : "0.213"
      },
      {
         "pixmapfile" : "turkey/agri.png",
         "toolTipText" : "Agri",
         "x" : "0.836",
         "y" : "0.397"
      },
      {
         "pixmapfile" : "turkey/adiyaman.png",
         "toolTipText" : "Adiyaman",
         "x" : "0.628",
         "y" : "0.603"
      },
      {
         "pixmapfile" : "turkey/zonguldak.png",
         "toolTipText" : "Zonguldak",
         "x" : "0.356",
         "y" : "0.221"
      },
      {
         "pixmapfile" : "turkey/yozgat.png",
         "toolTipText" : "Yozgat",
         "x" : "0.489",
         "y" : "0.421"
      },
      {
         "pixmapfile" : "turkey/yalova.png",
         "toolTipText" : "Yalova",
         "x" : "0.243",
         "y" : "0.292"
      },
      {
         "pixmapfile" : "turkey/usak.png",
         "toolTipText" : "Usak",
         "x" : "0.244",
         "y" : "0.513"
      },
      {
         "pixmapfile" : "turkey/tekirdag.png",
         "toolTipText" : "Tekirdag",
         "x" : "0.18",
         "y" : "0.226"
      },
      {
         "pixmapfile" : "turkey/sinop.png",
         "toolTipText" : "Sinop",
         "x" : "0.483",
         "y" : "0.192"
      },
      {
         "pixmapfile" : "turkey/samsun.png",
         "toolTipText" : "Samsun",
         "x" : "0.527",
         "y" : "0.231"
      },
      {
         "pixmapfile" : "turkey/sakarya.png",
         "toolTipText" : "Sakarya",
         "x" : "0.299",
         "y" : "0.277"
      },
      {
         "pixmapfile" : "turkey/osmaniye.png",
         "toolTipText" : "Osmaniye",
         "x" : "0.538",
         "y" : "0.656"
      },
      {
         "pixmapfile" : "turkey/nigde.png",
         "toolTipText" : "Nigde",
         "x" : "0.469",
         "y" : "0.613"
      },
      {
         "pixmapfile" : "turkey/nevsehir.png",
         "toolTipText" : "Nevsehir",
         "x" : "0.469",
         "y" : "0.503"
      },
      {
         "pixmapfile" : "turkey/mugla.png",
         "toolTipText" : "Mugla",
         "x" : "0.198",
         "y" : "0.687"
      },
      {
         "pixmapfile" : "turkey/mersin.png",
         "toolTipText" : "Mersin",
         "x" : "0.431",
         "y" : "0.738"
      },
      {
         "pixmapfile" : "turkey/manisa.png",
         "toolTipText" : "Manisa",
         "x" : "0.193",
         "y" : "0.482"
      },
      {
         "pixmapfile" : "turkey/kutahya.png",
         "toolTipText" : "Kütahya",
         "x" : "0.254",
         "y" : "0.431"
      },
      {
         "pixmapfile" : "turkey/konya.png",
         "toolTipText" : "Konya",
         "x" : "0.39",
         "y" : "0.597"
      },
      {
         "pixmapfile" : "turkey/kocaeli.png",
         "toolTipText" : "Kocaeli",
         "x" : "0.277",
         "y" : "0.259"
      },
      {
         "pixmapfile" : "turkey/kirsehir.png",
         "toolTipText" : "Kirsehir",
         "x" : "0.446",
         "y" : "0.446"
      },
      {
         "pixmapfile" : "turkey/kirklareli.png",
         "toolTipText" : "Kirklareli",
         "x" : "0.185",
         "y" : "0.156"
      },
      {
         "pixmapfile" : "turkey/kirikkale.png",
         "toolTipText" : "Kirikkale",
         "x" : "0.43",
         "y" : "0.39"
      },
      {
         "pixmapfile" : "turkey/kayseri.png",
         "toolTipText" : "Kayseri",
         "x" : "0.518",
         "y" : "0.536"
      },
      {
         "pixmapfile" : "turkey/kastamonu.png",
         "toolTipText" : "Kastamonu",
         "x" : "0.432",
         "y" : "0.215"
      },
      {
         "pixmapfile" : "turkey/karaman.png",
         "toolTipText" : "Karaman",
         "x" : "0.401",
         "y" : "0.7"
      },
      {
         "pixmapfile" : "turkey/karabuk.png",
         "toolTipText" : "Karabuk",
         "x" : "0.384",
         "y" : "0.251"
      },
      {
         "pixmapfile" : "turkey/izmir.png",
         "toolTipText" : "Izmir",
         "x" : "0.161",
         "y" : "0.49"
      },
      {
         "pixmapfile" : "turkey/istanbul.png",
         "toolTipText" : "Istanbul",
         "x" : "0.24",
         "y" : "0.226"
      },
      {
         "pixmapfile" : "turkey/isparta.png",
         "toolTipText" : "Isparta",
         "x" : "0.302",
         "y" : "0.595"
      },
      {
         "pixmapfile" : "turkey/eskisehir.png",
         "toolTipText" : "Eskisehir",
         "x" : "0.32",
         "y" : "0.405"
      },
      {
         "pixmapfile" : "turkey/edirne.png",
         "toolTipText" : "Edirne",
         "x" : "0.145",
         "y" : "0.185"
      },
      {
         "pixmapfile" : "turkey/duzce.png",
         "toolTipText" : "Düzce",
         "x" : "0.329",
         "y" : "0.262"
      },
      {
         "pixmapfile" : "turkey/denizli.png",
         "toolTipText" : "Denizli",
         "x" : "0.239",
         "y" : "0.608"
      },
      {
         "pixmapfile" : "turkey/corum.png",
         "toolTipText" : "Çorum",
         "x" : "0.475",
         "y" : "0.313"
      },
      {
         "pixmapfile" : "turkey/cankiri.png",
         "toolTipText" : "Çankiri",
         "x" : "0.42",
         "y" : "0.297"
      },
      {
         "pixmapfile" : "turkey/canakkale.png",
         "toolTipText" : "Çanakkale",
         "x" : "0.139",
         "y" : "0.318"
      },
      {
         "pixmapfile" : "turkey/bursa.png",
         "toolTipText" : "Bursa",
         "x" : "0.243",
         "y" : "0.346"
      },
      {
         "pixmapfile" : "turkey/burdur.png",
         "toolTipText" : "Burdur",
         "x" : "0.271",
         "y" : "0.646"
      },
      {
         "pixmapfile" : "turkey/bolu.png",
         "toolTipText" : "Bolu",
         "x" : "0.341",
         "y" : "0.295"
      },
      {
         "pixmapfile" : "turkey/bilecik.png",
         "toolTipText" : "Bilecik",
         "x" : "0.283",
         "y" : "0.349"
      },
      {
         "pixmapfile" : "turkey/bartin.png",
         "toolTipText" : "Bartin",
         "x" : "0.385",
         "y" : "0.192"
      },
      {
         "pixmapfile" : "turkey/balikesir.png",
         "toolTipText" : "Balikesir",
         "x" : "0.186",
         "y" : "0.359"
      },
      {
         "pixmapfile" : "turkey/aydin.png",
         "toolTipText" : "Aydin",
         "x" : "0.182",
         "y" : "0.59"
      },
      {
         "pixmapfile" : "turkey/antalya.png",
         "toolTipText" : "Antalya",
         "x" : "0.304",
         "y" : "0.726"
      },
      {
         "pixmapfile" : "turkey/ankara.png",
         "toolTipText" : "Ankara",
         "x" : "0.376",
         "y" : "0.408"
      },
      {
         "pixmapfile" : "turkey/amasya.png",
         "toolTipText" : "Amasya",
         "x" : "0.516",
         "y" : "0.303"
      },
      {
         "pixmapfile" : "turkey/aksaray.png",
         "toolTipText" : "Aksaray",
         "x" : "0.435",
         "y" : "0.544"
      },
      {
         "pixmapfile" : "turkey/afyon.png",
         "toolTipText" : "Afyon",
         "x" : "0.298",
         "y" : "0.531"
      },
      {
         "pixmapfile" : "turkey/adana.png",
         "toolTipText" : "Adana",
         "x" : "0.505",
         "y" : "0.651"
      }
   ]
}
