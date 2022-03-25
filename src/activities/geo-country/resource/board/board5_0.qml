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
import QtQuick 2.12

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
         //: Province of Turkey: Zonguldak
         "toolTipText" : qsTr("Zonguldak"),
         "x" : "0.5348",
         "y" : "0.1678"
      },
      {
         "pixmapfile" : "turkey/yozgat.svgz",
         //: Province of Turkey: Yozgat
         "toolTipText" : qsTr("Yozgat"),
         "x" : "0.8118",
         "y" : "0.4125"
      },
      {
         "pixmapfile" : "turkey/yalova.svgz",
         //: Province of Turkey: Yalova
         "toolTipText" : qsTr("Yalova"),
         "x" : "0.3152",
         "y" : "0.2618"
      },
      {
         "pixmapfile" : "turkey/usak.svgz",
         //: Province of Turkey: Uşak
         "toolTipText" : qsTr("Uşak"),
         "x" : "0.3247",
         "y" : "0.5654"
      },
      {
         "pixmapfile" : "turkey/tekirdag.svgz",
         //: Province of Turkey: Tekirdağ
         "toolTipText" : qsTr("Tekirdağ"),
         "x" : "0.1754",
         "y" : "0.1813"
      },
      {
         "pixmapfile" : "turkey/sinop.svgz",
         //: Province of Turkey: Sinop
         "toolTipText" : qsTr("Sinop"),
         "x" : "0.7854",
         "y" : "0.1138"
      },
      {
         "pixmapfile" : "turkey/samsun.svgz",
         //: Province of Turkey: Samsun
         "toolTipText" : qsTr("Samsun"),
         "x" : "0.8835",
         "y" : "0.1653"
      },
      {
         "pixmapfile" : "turkey/sakarya.svgz",
         //: Province of Turkey: Sakarya
         "toolTipText" : qsTr("Sakarya"),
         "x" : "0.4255",
         "y" : "0.2477"
      },
      {
         "pixmapfile" : "turkey/nigde.svgz",
         //: Province of Turkey: Niğde
         "toolTipText" : qsTr("Niğde"),
         "x" : "0.7763",
         "y" : "0.6736"
      },
      {
         "pixmapfile" : "turkey/nevsehir.svgz",
         //: Province of Turkey: Nevşehir
         "toolTipText" : qsTr("Nevşehir"),
         "x" : "0.7793",
         "y" : "0.5298"
      },
      {
         "pixmapfile" : "turkey/mugla.svgz",
         //: Province of Turkey: Muğla
         "toolTipText" : qsTr("Muğla"),
         "x" : "0.2407",
         "y" : "0.7992"
      },
      {
         "pixmapfile" : "turkey/mersin.svgz",
         //: Province of Turkey: Mersin
         "toolTipText" : qsTr("Mersin"),
         "x" : "0.7066",
         "y" : "0.8408"
      },
      {
         "pixmapfile" : "turkey/manisa.svgz",
         //: Province of Turkey: Manisa
         "toolTipText" : qsTr("Manisa"),
         "x" : "0.2183",
         "y" : "0.5288"
      },
      {
         "pixmapfile" : "turkey/kutahya.svgz",
         //: Province of Turkey: Kütahya
         "toolTipText" : qsTr("Kütahya"),
         "x" : "0.339",
         "y" : "0.4498"
      },
      {
         "pixmapfile" : "turkey/konya.svgz",
         //: Province of Turkey: Konya
         "toolTipText" : qsTr("Konya"),
         "x" : "0.6218",
         "y" : "0.6502"
      },
      {
         "pixmapfile" : "turkey/kocaeli.svgz",
         //: Province of Turkey: Kocaeli
         "toolTipText" : qsTr("Kocaeli"),
         "x" : "0.3741",
         "y" : "0.2264"
      },
      {
         "pixmapfile" : "turkey/kirsehir.svgz",
         //: Province of Turkey: Kirsehir
         "toolTipText" : qsTr("Kirsehir"),
         "x" : "0.7237",
         "y" : "0.4605"
      },
      {
         "pixmapfile" : "turkey/kirklareli.svgz",
         //: Province of Turkey: Kırklareli
         "toolTipText" : qsTr("Kırklareli"),
         "x" : "0.1843",
         "y" : "0.0945"
      },
      {
         "pixmapfile" : "turkey/kirikkale.svgz",
         //: Province of Turkey: Kırıkkale
         "toolTipText" : qsTr("Kırıkkale"),
         "x" : "0.6927",
         "y" : "0.3794"
      },
      {
         "pixmapfile" : "turkey/kayseri.svgz",
         //: Province of Turkey: Kayseri
         "toolTipText" : qsTr("Kayseri"),
         "x" : "0.8818",
         "y" : "0.575"
      },
      {
         "pixmapfile" : "turkey/kastamonu.svgz",
         //: Province of Turkey: Kastamonu
         "toolTipText" : qsTr("Kastamonu"),
         "x" : "0.6896",
         "y" : "0.1503"
      },
      {
         "pixmapfile" : "turkey/karaman.svgz",
         //: Province of Turkey: Karaman
         "toolTipText" : qsTr("Karaman"),
         "x" : "0.666",
         "y" : "0.8003"
      },
      {
         "pixmapfile" : "turkey/karabuk.svgz",
         //: Province of Turkey: Karabük
         "toolTipText" : qsTr("Karabük"),
         "x" : "0.5973",
         "y" : "0.1818"
      },
      {
         "pixmapfile" : "turkey/izmir.svgz",
         //: Province of Turkey: İzmir
         "toolTipText" : qsTr("İzmir"),
         "x" : "0.1492",
         "y" : "0.5457"
      },
      {
         "pixmapfile" : "turkey/istanbul.svgz",
         //: Province of Turkey: İstanbul
         "toolTipText" : qsTr("İstanbul"),
         "x" : "0.3012",
         "y" : "0.1719"
      },
      {
         "pixmapfile" : "turkey/isparta.svgz",
         //: Province of Turkey: Isparta
         "toolTipText" : qsTr("Isparta"),
         "x" : "0.4451",
         "y" : "0.6628"
      },
      {
         "pixmapfile" : "turkey/eskisehir.svgz",
         //: Province of Turkey: Eskişehir
         "toolTipText" : qsTr("Eskişehir"),
         "x" : "0.4654",
         "y" : "0.4144"
      },
      {
         "pixmapfile" : "turkey/edirne.svgz",
         //: Province of Turkey: Edirne
         "toolTipText" : qsTr("Edirne"),
         "x" : "0.1011",
         "y" : "0.1432"
      },
      {
         "pixmapfile" : "turkey/duzce.svgz",
         //: Province of Turkey: Düzce
         "toolTipText" : qsTr("Düzce"),
         "x" : "0.4964",
         "y" : "0.2297"
      },
      {
         "pixmapfile" : "turkey/denizli.svgz",
         //: Province of Turkey: Denizli
         "toolTipText" : qsTr("Denizli"),
         "x" : "0.3166",
         "y" : "0.6941"
      },
      {
         "pixmapfile" : "turkey/corum.svgz",
         //: Province of Turkey: Çorum
         "toolTipText" : qsTr("Çorum"),
         "x" : "0.7794",
         "y" : "0.2634"
      },
      {
         "pixmapfile" : "turkey/cankiri.svgz",
         //: Province of Turkey: Çankırı
         "toolTipText" : qsTr("Çankırı"),
         "x" : "0.6651",
         "y" : "0.2595"
      },
      {
         "pixmapfile" : "turkey/canakkale.svgz",
         //: Province of Turkey: Çanakkale
         "toolTipText" : qsTr("Çanakkale"),
         "x" : "0.0981",
         "y" : "0.3171"
      },
      {
         "pixmapfile" : "turkey/bursa.svgz",
         //: Province of Turkey: Bursa
         "toolTipText" : qsTr("Bursa"),
         "x" : "0.3008",
         "y" : "0.3361"
      },
      {
         "pixmapfile" : "turkey/burdur.svgz",
         //: Province of Turkey: Burdur
         "toolTipText" : qsTr("Burdur"),
         "x" : "0.3829",
         "y" : "0.7479"
      },
      {
         "pixmapfile" : "turkey/bolu.svgz",
         //: Province of Turkey: Bolu
         "toolTipText" : qsTr("Bolu"),
         "x" : "0.5153",
         "y" : "0.2736"
      },
      {
         "pixmapfile" : "turkey/bilecik.svgz",
         //: Province of Turkey: Bilecik
         "toolTipText" : qsTr("Bilecik"),
         "x" : "0.398",
         "y" : "0.3383"
      },
      {
         "pixmapfile" : "turkey/bartin.svgz",
         //: Province of Turkey: Bartın
         "toolTipText" : qsTr("Bartın"),
         "x" : "0.5942",
         "y" : "0.1273"
      },
      {
         "pixmapfile" : "turkey/balikesir.svgz",
         //: Province of Turkey: Balıkesir
         "toolTipText" : qsTr("Balıkesir"),
         "x" : "0.1945",
         "y" : "0.3625"
      },
      {
         "pixmapfile" : "turkey/aydin.svgz",
         //: Province of Turkey: Aydın
         "toolTipText" : qsTr("Aydın"),
         "x" : "0.1967",
         "y" : "0.677"
      },
      {
         "pixmapfile" : "turkey/antalya.svgz",
         //: Province of Turkey: Antalya
         "toolTipText" : qsTr("Antalya"),
         "x" : "0.4528",
         "y" : "0.8357"
      },
      {
         "pixmapfile" : "turkey/ankara.svgz",
         //: Province of Turkey: Ankara
         "toolTipText" : qsTr("Ankara"),
         "x" : "0.581",
         "y" : "0.4028"
      },
      {
         "pixmapfile" : "turkey/amasya.svgz",
         //: Province of Turkey: Amasya
         "toolTipText" : qsTr("Amasya"),
         "x" : "0.861",
         "y" : "0.2598"
      },
      {
         "pixmapfile" : "turkey/aksaray.svgz",
         //: Province of Turkey: Aksaray
         "toolTipText" : qsTr("Aksaray"),
         "x" : "0.7061",
         "y" : "0.5786"
      },
      {
         "pixmapfile" : "turkey/afyon.svgz",
         //: Province of Turkey: Afyon
         "toolTipText" : qsTr("Afyon"),
         "x" : "0.4359",
         "y" : "0.5735"
      },
      {
         "pixmapfile" : "turkey/adana.svgz",
         //: Province of Turkey: Adana
         "toolTipText" : qsTr("Adana"),
         "x" : "0.8578",
         "y" : "0.727"
      }
   ]
}
