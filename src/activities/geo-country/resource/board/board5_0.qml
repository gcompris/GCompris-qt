/* GCompris
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (new SVG map)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9

QtObject {
   property int numberOfSubLevel: 1
   property string instruction: qsTr("Western Provinces of Turkey")
   property var levels: [
      {
         "pixmapfile" : "turkey/turkey_west.svgz",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "turkey/zonguldak.svgz",
         //: District of Turkey: Zonguldak
         "toolTipText" : qsTr("Zonguldak"),
         "x" : "0.537",
         "y" : "0.1641"
      },
      {
         "pixmapfile" : "turkey/yozgat.svgz",
         //: District of Turkey: Yozgat
         "toolTipText" : qsTr("Yozgat"),
         "x" : "0.8127",
         "y" : "0.4043"
      },
      {
         "pixmapfile" : "turkey/yalova.svgz",
         //: District of Turkey: Yalova
         "toolTipText" : qsTr("Yalova"),
         "x" : "0.319",
         "y" : "0.2642"
      },
      {
         "pixmapfile" : "turkey/usak.svgz",
         //: District of Turkey: Uşak
         "toolTipText" : qsTr("Uşak"),
         "x" : "0.3377",
         "y" : "0.5576"
      },
      {
         "pixmapfile" : "turkey/tekirdag.svgz",
         //: District of Turkey: Tekirdağ
         "toolTipText" : qsTr("Tekirdağ"),
         "x" : "0.1736",
         "y" : "0.1963"
      },
      {
         "pixmapfile" : "turkey/sinop.svgz",
         //: District of Turkey: Sinop
         "toolTipText" : qsTr("Sinop"),
         "x" : "0.7909",
         "y" : "0.1138"
      },
      {
         "pixmapfile" : "turkey/samsun.svgz",
         //: District of Turkey: Samsun
         "toolTipText" : qsTr("Samsun"),
         "x" : "0.8883",
         "y" : "0.1668"
      },
      {
         "pixmapfile" : "turkey/sakarya.svgz",
         //: District of Turkey: Sakarya
         "toolTipText" : qsTr("Sakarya"),
         "x" : "0.4285",
         "y" : "0.2452"
      },
      {
         "pixmapfile" : "turkey/nigde.svgz",
         //: District of Turkey: Niğde
         "toolTipText" : qsTr("Niğde"),
         "x" : "0.7736",
         "y" : "0.6565"
      },
      {
         "pixmapfile" : "turkey/nevsehir.svgz",
         //: District of Turkey: Nevşehir
         "toolTipText" : qsTr("Nevşehir"),
         "x" : "0.7785",
         "y" : "0.5173"
      },
      {
         "pixmapfile" : "turkey/mugla.svgz",
         //: District of Turkey: Muğla
         "toolTipText" : qsTr("Muğla"),
         "x" : "0.2599",
         "y" : "0.7873"
      },
      {
         "pixmapfile" : "turkey/mersin.svgz",
         //: District of Turkey: Mersin
         "toolTipText" : qsTr("Mersin"),
         "x" : "0.7062",
         "y" : "0.8188"
      },
      {
         "pixmapfile" : "turkey/manisa.svgz",
         //: District of Turkey: Manisa
         "toolTipText" : qsTr("Manisa"),
         "x" : "0.2322",
         "y" : "0.5298"
      },
      {
         "pixmapfile" : "turkey/kutahya.svgz",
         //: District of Turkey: Kütahya
         "toolTipText" : qsTr("Kütahya"),
         "x" : "0.3487",
         "y" : "0.4454"
      },
      {
         "pixmapfile" : "turkey/konya.svgz",
         //: District of Turkey: Konya
         "toolTipText" : qsTr("Konya"),
         "x" : "0.6245",
         "y" : "0.6324"
      },
      {
         "pixmapfile" : "turkey/kocaeli.svgz",
         //: District of Turkey: Kocaeli
         "toolTipText" : qsTr("Kocaeli"),
         "x" : "0.3755",
         "y" : "0.2254"
      },
      {
         "pixmapfile" : "turkey/kirsehir.svgz",
         //: District of Turkey: Kirsehir
         "toolTipText" : qsTr("Kirsehir"),
         "x" : "0.7248",
         "y" : "0.449"
      },
      {
         "pixmapfile" : "turkey/kirklareli.svgz",
         //: District of Turkey: Kırklareli
         "toolTipText" : qsTr("Kırklareli"),
         "x" : "0.1817",
         "y" : "0.1127"
      },
      {
         "pixmapfile" : "turkey/kirikkale.svgz",
         //: District of Turkey: Kırıkkale
         "toolTipText" : qsTr("Kırıkkale"),
         "x" : "0.695",
         "y" : "0.3693"
      },
      {
         "pixmapfile" : "turkey/kayseri.svgz",
         //: District of Turkey: Kayseri
         "toolTipText" : qsTr("Kayseri"),
         "x" : "0.8782",
         "y" : "0.5639"
      },
      {
         "pixmapfile" : "turkey/kastamonu.svgz",
         //: District of Turkey: Kastamonu
         "toolTipText" : qsTr("Kastamonu"),
         "x" : "0.6933",
         "y" : "0.1468"
      },
      {
         "pixmapfile" : "turkey/karaman.svgz",
         //: District of Turkey: Karaman
         "toolTipText" : qsTr("Karaman"),
         "x" : "0.6674",
         "y" : "0.7787"
      },
      {
         "pixmapfile" : "turkey/karabuk.svgz",
         //: District of Turkey: Karabük
         "toolTipText" : qsTr("Karabük"),
         "x" : "0.6002",
         "y" : "0.1773"
      },
      {
         "pixmapfile" : "turkey/izmir.svgz",
         //: District of Turkey: İzmir
         "toolTipText" : qsTr("İzmir"),
         "x" : "0.1674",
         "y" : "0.5505"
      },
      {
         "pixmapfile" : "turkey/istanbul.svgz",
         //: District of Turkey: İstanbul
         "toolTipText" : qsTr("İstanbul"),
         "x" : "0.3021",
         "y" : "0.1796"
      },
      {
         "pixmapfile" : "turkey/isparta.svgz",
         //: District of Turkey: Isparta
         "toolTipText" : qsTr("Isparta"),
         "x" : "0.4557",
         "y" : "0.6474"
      },
      {
         "pixmapfile" : "turkey/eskisehir.svgz",
         //: District of Turkey: Eskişehir
         "toolTipText" : qsTr("Eskişehir"),
         "x" : "0.471",
         "y" : "0.4051"
      },
      {
         "pixmapfile" : "turkey/edirne.svgz",
         //: District of Turkey: Edirne
         "toolTipText" : qsTr("Edirne"),
         "x" : "0.0999",
         "y" : "0.1645"
      },
      {
         "pixmapfile" : "turkey/duzce.svgz",
         //: District of Turkey: Düzce
         "toolTipText" : qsTr("Düzce"),
         "x" : "0.4991",
         "y" : "0.2256"
      },
      {
         "pixmapfile" : "turkey/denizli.svgz",
         //: District of Turkey: Denizli
         "toolTipText" : qsTr("Denizli"),
         "x" : "0.3324",
         "y" : "0.6828"
      },
      {
         "pixmapfile" : "turkey/corum.svgz",
         //: District of Turkey: Çorum
         "toolTipText" : qsTr("Çorum"),
         "x" : "0.7821",
         "y" : "0.2574"
      },
      {
         "pixmapfile" : "turkey/cankiri.svgz",
         //: District of Turkey: Çankırı
         "toolTipText" : qsTr("Çankırı"),
         "x" : "0.6676",
         "y" : "0.2539"
      },
      {
         "pixmapfile" : "turkey/canakkale.svgz",
         //: District of Turkey: Çanakkale
         "toolTipText" : qsTr("Çanakkale"),
         "x" : "0.1062",
         "y" : "0.3347"
      },
      {
         "pixmapfile" : "turkey/bursa.svgz",
         //: District of Turkey: Bursa
         "toolTipText" : qsTr("Bursa"),
         "x" : "0.3054",
         "y" : "0.3352"
      },
      {
         "pixmapfile" : "turkey/burdur.svgz",
         //: District of Turkey: Burdur
         "toolTipText" : qsTr("Burdur"),
         "x" : "0.3979",
         "y" : "0.7336"
      },
      {
         "pixmapfile" : "turkey/bolu.svgz",
         //: District of Turkey: Bolu
         "toolTipText" : qsTr("Bolu"),
         "x" : "0.5192",
         "y" : "0.268"
      },
      {
         "pixmapfile" : "turkey/bilecik.svgz",
         //: District of Turkey: Bilecik
         "toolTipText" : qsTr("Bilecik"),
         "x" : "0.4039",
         "y" : "0.3346"
      },
      {
         "pixmapfile" : "turkey/bartin.svgz",
         //: District of Turkey: Bartın
         "toolTipText" : qsTr("Bartın"),
         "x" : "0.597",
         "y" : "0.1241"
      },
      {
         "pixmapfile" : "turkey/balikesir.svgz",
         //: District of Turkey: Balıkesir
         "toolTipText" : qsTr("Balıkesir"),
         "x" : "0.2021",
         "y" : "0.3683"
      },
      {
         "pixmapfile" : "turkey/aydin.svgz",
         //: District of Turkey: Aydın
         "toolTipText" : qsTr("Aydın"),
         "x" : "0.2179",
         "y" : "0.6757"
      },
      {
         "pixmapfile" : "turkey/antalya.svgz",
         //: District of Turkey: Antalya
         "toolTipText" : qsTr("Antalya"),
         "x" : "0.4663",
         "y" : "0.814"
      },
      {
         "pixmapfile" : "turkey/ankara.svgz",
         //: District of Turkey: Ankara
         "toolTipText" : qsTr("Ankara"),
         "x" : "0.584",
         "y" : "0.3919"
      },
      {
         "pixmapfile" : "turkey/amasya.svgz",
         //: District of Turkey: Amasya
         "toolTipText" : qsTr("Amasya"),
         "x" : "0.8651",
         "y" : "0.2564"
      },
      {
         "pixmapfile" : "turkey/aksaray.svgz",
         //: District of Turkey: Aksaray
         "toolTipText" : qsTr("Aksaray"),
         "x" : "0.7065",
         "y" : "0.5626"
      },
      {
         "pixmapfile" : "turkey/afyon.svgz",
         //: District of Turkey: Afyon
         "toolTipText" : qsTr("Afyon"),
         "x" : "0.4459",
         "y" : "0.5617"
      },
      {
         "pixmapfile" : "turkey/adana.svgz",
         //: District of Turkey: Adana
         "toolTipText" : qsTr("Adana"),
         "x" : "0.8522",
         "y" : "0.7121"
      }
   ]
}
