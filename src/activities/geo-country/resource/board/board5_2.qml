/* GCompris
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9

QtObject {
   property string instruction: qsTr("Districts of Turkey")
   property var levels: [
      {
         "pixmapfile" : "turkey/turkey.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "turkey/van.png",
         //: District of Turkey: Van
         "toolTipText" : qsTr("Van"),
         "x" : "0.85",
         "y" : "0.495"
      },
      {
         "pixmapfile" : "turkey/tunceli.png",
         //: District of Turkey: Tunceli
         "toolTipText" : qsTr("Tunceli"),
         "x" : "0.677",
         "y" : "0.449"
      },
      {
         "pixmapfile" : "turkey/trabzon.png",
         //: District of Turkey: Trabzon
         "toolTipText" : qsTr("Trabzon"),
         "x" : "0.686",
         "y" : "0.269"
      },
      {
         "pixmapfile" : "turkey/tokat.png",
         //: District of Turkey: Tokat
         "toolTipText" : qsTr("Tokat"),
         "x" : "0.553",
         "y" : "0.331"
      },
      {
         "pixmapfile" : "turkey/sivas.png",
         //: District of Turkey: Sivas
         "toolTipText" : qsTr("Sivas"),
         "x" : "0.579",
         "y" : "0.426"
      },
      {
         "pixmapfile" : "turkey/sirnak.png",
         //: District of Turkey: Şırnak
         "toolTipText" : qsTr("Şırnak"),
         "x" : "0.803",
         "y" : "0.631"
      },
      {
         "pixmapfile" : "turkey/siirt.png",
         //: District of Turkey: Siirt
         "toolTipText" : qsTr("Siirt"),
         "x" : "0.791",
         "y" : "0.579"
      },
      {
         "pixmapfile" : "turkey/sanliurfa.png",
         //: District of Turkey: Şanlıurfa
         "toolTipText" : qsTr("Şanlıurfa"),
         "x" : "0.659",
         "y" : "0.654"
      },
      {
         "pixmapfile" : "turkey/rize.png",
         //: District of Turkey: Rize
         "toolTipText" : qsTr("Rize"),
         "x" : "0.728",
         "y" : "0.244"
      },
      {
         "pixmapfile" : "turkey/ordu.png",
         //: District of Turkey: Ordu
         "toolTipText" : qsTr("Ordu"),
         "x" : "0.589",
         "y" : "0.287"
      },
      {
         "pixmapfile" : "turkey/mus.png",
         //: District of Turkey: Muş
         "toolTipText" : qsTr("Muş"),
         "x" : "0.778",
         "y" : "0.456"
      },
      {
         "pixmapfile" : "turkey/mardin.png",
         //: District of Turkey: Mardin
         "toolTipText" : qsTr("Mardin"),
         "x" : "0.736",
         "y" : "0.649"
      },
      {
         "pixmapfile" : "turkey/malatya.png",
         //: District of Turkey: Malatya
         "toolTipText" : qsTr("Malatya"),
         "x" : "0.621",
         "y" : "0.523"
      },
      {
         "pixmapfile" : "turkey/kilis.png",
         //: District of Turkey: Kilis
         "toolTipText" : qsTr("Kilis"),
         "x" : "0.576",
         "y" : "0.721"
      },
      {
         "pixmapfile" : "turkey/kars.png",
         //: District of Turkey: Kars
         "toolTipText" : qsTr("Kars"),
         "x" : "0.814",
         "y" : "0.279"
      },
      {
         "pixmapfile" : "turkey/kahramanmaras.png",
         //: District of Turkey: Kahramanmaraş
         "toolTipText" : qsTr("Kahramanmaraş"),
         "x" : "0.569",
         "y" : "0.597"
      },
      {
         "pixmapfile" : "turkey/igdir.png",
         //: District of Turkey: Iğdır
         "toolTipText" : qsTr("Iğdır"),
         "x" : "0.86",
         "y" : "0.338"
      },
      {
         "pixmapfile" : "turkey/hatay.png",
         //: District of Turkey: Hatay
         "toolTipText" : qsTr("Hatay"),
         "x" : "0.543",
         "y" : "0.769"
      },
      {
         "pixmapfile" : "turkey/hakkari.png",
         //: District of Turkey: Hakkari
         "toolTipText" : qsTr("Hakkari"),
         "x" : "0.869",
         "y" : "0.608"
      },
      {
         "pixmapfile" : "turkey/gumushane.png",
         //: District of Turkey: Gümüşhane
         "toolTipText" : qsTr("Gümüşhane"),
         "x" : "0.664",
         "y" : "0.323"
      },
      {
         "pixmapfile" : "turkey/giresun.png",
         //: District of Turkey: Giresun
         "toolTipText" : qsTr("Giresun"),
         "x" : "0.632",
         "y" : "0.303"
      },
      {
         "pixmapfile" : "turkey/gaziantep.png",
         //: District of Turkey: Gaziantep
         "toolTipText" : qsTr("Gaziantep"),
         "x" : "0.583",
         "y" : "0.697"
      },
      {
         "pixmapfile" : "turkey/erzurum.png",
         //: District of Turkey: Erzurum
         "toolTipText" : qsTr("Erzurum"),
         "x" : "0.752",
         "y" : "0.333"
      },
      {
         "pixmapfile" : "turkey/erzincan.png",
         //: District of Turkey: Erzincan
         "toolTipText" : qsTr("Erzincan"),
         "x" : "0.67",
         "y" : "0.408"
      },
      {
         "pixmapfile" : "turkey/elazig.png",
         //: District of Turkey: Elazığ
         "toolTipText" : qsTr("Elazığ"),
         "x" : "0.667",
         "y" : "0.492"
      },
      {
         "pixmapfile" : "turkey/diyarbakir.png",
         //: District of Turkey: Diyarbakır
         "toolTipText" : qsTr("Diyarbakır"),
         "x" : "0.708",
         "y" : "0.564"
      },
      {
         "pixmapfile" : "turkey/bitlis.png",
         //: District of Turkey: Bitlis
         "toolTipText" : qsTr("Bitlis"),
         "x" : "0.796",
         "y" : "0.505"
      },
      {
         "pixmapfile" : "turkey/bingol.png",
         //: District of Turkey: Bingöl
         "toolTipText" : qsTr("Bingöl"),
         "x" : "0.722",
         "y" : "0.462"
      },
      {
         "pixmapfile" : "turkey/bayburt.png",
         //: District of Turkey: Bayburt
         "toolTipText" : qsTr("Bayburt"),
         "x" : "0.702",
         "y" : "0.326"
      },
      {
         "pixmapfile" : "turkey/batman.png",
         //: District of Turkey: Batman
         "toolTipText" : qsTr("Batman"),
         "x" : "0.757",
         "y" : "0.564"
      },
      {
         "pixmapfile" : "turkey/artvin.png",
         //: District of Turkey: Artvin
         "toolTipText" : qsTr("Artvin"),
         "x" : "0.765",
         "y" : "0.231"
      },
      {
         "pixmapfile" : "turkey/ardahan.png",
         //: District of Turkey: Ardahan
         "toolTipText" : qsTr("Ardahan"),
         "x" : "0.805",
         "y" : "0.213"
      },
      {
         "pixmapfile" : "turkey/agri.png",
         //: District of Turkey: Ağrı
         "toolTipText" : qsTr("Ağrı"),
         "x" : "0.836",
         "y" : "0.397"
      },
      {
         "pixmapfile" : "turkey/adiyaman.png",
         //: District of Turkey: Adıyaman
         "toolTipText" : qsTr("Adıyaman"),
         "x" : "0.628",
         "y" : "0.603"
      },
      {
         "pixmapfile" : "turkey/zonguldak.png",
         //: District of Turkey: Zonguldak
         "toolTipText" : qsTr("Zonguldak"),
         "x" : "0.356",
         "y" : "0.221"
      },
      {
         "pixmapfile" : "turkey/yozgat.png",
         //: District of Turkey: Yozgat
         "toolTipText" : qsTr("Yozgat"),
         "x" : "0.489",
         "y" : "0.421"
      },
      {
         "pixmapfile" : "turkey/yalova.png",
         //: District of Turkey: Yalova
         "toolTipText" : qsTr("Yalova"),
         "x" : "0.243",
         "y" : "0.292"
      },
      {
         "pixmapfile" : "turkey/usak.png",
         //: District of Turkey: Uşak
         "toolTipText" : qsTr("Uşak"),
         "x" : "0.244",
         "y" : "0.513"
      },
      {
         "pixmapfile" : "turkey/tekirdag.png",
         //: District of Turkey: Tekirdağ
         "toolTipText" : qsTr("Tekirdağ"),
         "x" : "0.18",
         "y" : "0.226"
      },
      {
         "pixmapfile" : "turkey/sinop.png",
         //: District of Turkey: Sinop
         "toolTipText" : qsTr("Sinop"),
         "x" : "0.483",
         "y" : "0.192"
      },
      {
         "pixmapfile" : "turkey/samsun.png",
         //: District of Turkey: Samsun
         "toolTipText" : qsTr("Samsun"),
         "x" : "0.527",
         "y" : "0.231"
      },
      {
         "pixmapfile" : "turkey/sakarya.png",
         //: District of Turkey: Sakarya
         "toolTipText" : qsTr("Sakarya"),
         "x" : "0.299",
         "y" : "0.277"
      },
      {
         "pixmapfile" : "turkey/osmaniye.png",
         //: District of Turkey: Osmaniye
         "toolTipText" : qsTr("Osmaniye"),
         "x" : "0.538",
         "y" : "0.656"
      },
      {
         "pixmapfile" : "turkey/nigde.png",
         //: District of Turkey: Niğde
         "toolTipText" : qsTr("Niğde"),
         "x" : "0.469",
         "y" : "0.613"
      },
      {
         "pixmapfile" : "turkey/nevsehir.png",
         //: District of Turkey: Nevşehir
         "toolTipText" : qsTr("Nevşehir"),
         "x" : "0.469",
         "y" : "0.503"
      },
      {
         "pixmapfile" : "turkey/mugla.png",
         //: District of Turkey: Muğla
         "toolTipText" : qsTr("Muğla"),
         "x" : "0.198",
         "y" : "0.687"
      },
      {
         "pixmapfile" : "turkey/mersin.png",
         //: District of Turkey: Mersin
         "toolTipText" : qsTr("Mersin"),
         "x" : "0.431",
         "y" : "0.738"
      },
      {
         "pixmapfile" : "turkey/manisa.png",
         //: District of Turkey: Manisa
         "toolTipText" : qsTr("Manisa"),
         "x" : "0.193",
         "y" : "0.482"
      },
      {
         "pixmapfile" : "turkey/kutahya.png",
         //: District of Turkey: Kütahya
         "toolTipText" : qsTr("Kütahya"),
         "x" : "0.254",
         "y" : "0.431"
      },
      {
         "pixmapfile" : "turkey/konya.png",
         //: District of Turkey: Konya
         "toolTipText" : qsTr("Konya"),
         "x" : "0.39",
         "y" : "0.597"
      },
      {
         "pixmapfile" : "turkey/kocaeli.png",
         //: District of Turkey: Kocaeli
         "toolTipText" : qsTr("Kocaeli"),
         "x" : "0.277",
         "y" : "0.259"
      },
      {
         "pixmapfile" : "turkey/kirsehir.png",
         //: District of Turkey: Kırşehir
         "toolTipText" : qsTr("Kırşehir"),
         "x" : "0.446",
         "y" : "0.446"
      },
      {
         "pixmapfile" : "turkey/kirklareli.png",
         //: District of Turkey: Kırklareli
         "toolTipText" : qsTr("Kırklareli"),
         "x" : "0.185",
         "y" : "0.156"
      },
      {
         "pixmapfile" : "turkey/kirikkale.png",
         //: District of Turkey: Kırıkkale
         "toolTipText" : qsTr("Kırıkkale"),
         "x" : "0.43",
         "y" : "0.39"
      },
      {
         "pixmapfile" : "turkey/kayseri.png",
         //: District of Turkey: Kayseri
         "toolTipText" : qsTr("Kayseri"),
         "x" : "0.518",
         "y" : "0.536"
      },
      {
         "pixmapfile" : "turkey/kastamonu.png",
         //: District of Turkey: Kastamonu
         "toolTipText" : qsTr("Kastamonu"),
         "x" : "0.432",
         "y" : "0.215"
      },
      {
         "pixmapfile" : "turkey/karaman.png",
         //: District of Turkey: Karaman
         "toolTipText" : qsTr("Karaman"),
         "x" : "0.401",
         "y" : "0.7"
      },
      {
         "pixmapfile" : "turkey/karabuk.png",
         //: District of Turkey: Karabuk
         "toolTipText" : qsTr("Karabuk"),
         "x" : "0.384",
         "y" : "0.251"
      },
      {
         "pixmapfile" : "turkey/izmir.png",
         //: District of Turkey: İzmir
         "toolTipText" : qsTr("İzmir"),
         "x" : "0.161",
         "y" : "0.49"
      },
      {
         "pixmapfile" : "turkey/istanbul.png",
         //: District of Turkey: İstanbul
         "toolTipText" : qsTr("İstanbul"),
         "x" : "0.24",
         "y" : "0.226"
      },
      {
         "pixmapfile" : "turkey/isparta.png",
         //: District of Turkey: Isparta
         "toolTipText" : qsTr("Isparta"),
         "x" : "0.302",
         "y" : "0.595"
      },
      {
         "pixmapfile" : "turkey/eskisehir.png",
         //: District of Turkey: Eskişehir
         "toolTipText" : qsTr("Eskişehir"),
         "x" : "0.32",
         "y" : "0.405"
      },
      {
         "pixmapfile" : "turkey/edirne.png",
         //: District of Turkey: Edirne
         "toolTipText" : qsTr("Edirne"),
         "x" : "0.145",
         "y" : "0.185"
      },
      {
         "pixmapfile" : "turkey/duzce.png",
         //: District of Turkey: Düzce
         "toolTipText" : qsTr("Düzce"),
         "x" : "0.329",
         "y" : "0.262"
      },
      {
         "pixmapfile" : "turkey/denizli.png",
         //: District of Turkey: Denizli
         "toolTipText" : qsTr("Denizli"),
         "x" : "0.239",
         "y" : "0.608"
      },
      {
         "pixmapfile" : "turkey/corum.png",
         //: District of Turkey: Çorum
         "toolTipText" : qsTr("Çorum"),
         "x" : "0.475",
         "y" : "0.313"
      },
      {
         "pixmapfile" : "turkey/cankiri.png",
         //: District of Turkey: Çankırı
         "toolTipText" : qsTr("Çankırı"),
         "x" : "0.42",
         "y" : "0.297"
      },
      {
         "pixmapfile" : "turkey/canakkale.png",
         //: District of Turkey: Çanakkale
         "toolTipText" : qsTr("Çanakkale"),
         "x" : "0.139",
         "y" : "0.318"
      },
      {
         "pixmapfile" : "turkey/bursa.png",
         //: District of Turkey: Bursa
         "toolTipText" : qsTr("Bursa"),
         "x" : "0.243",
         "y" : "0.346"
      },
      {
         "pixmapfile" : "turkey/burdur.png",
         //: District of Turkey: Burdur
         "toolTipText" : qsTr("Burdur"),
         "x" : "0.271",
         "y" : "0.646"
      },
      {
         "pixmapfile" : "turkey/bolu.png",
         //: District of Turkey: Bolu
         "toolTipText" : qsTr("Bolu"),
         "x" : "0.341",
         "y" : "0.295"
      },
      {
         "pixmapfile" : "turkey/bilecik.png",
         //: District of Turkey: Bilecik
         "toolTipText" : qsTr("Bilecik"),
         "x" : "0.283",
         "y" : "0.349"
      },
      {
         "pixmapfile" : "turkey/bartin.png",
         //: District of Turkey: Bartın
         "toolTipText" : qsTr("Bartın"),
         "x" : "0.385",
         "y" : "0.192"
      },
      {
         "pixmapfile" : "turkey/balikesir.png",
         //: District of Turkey: Balıkesir
         "toolTipText" : qsTr("Balıkesir"),
         "x" : "0.186",
         "y" : "0.359"
      },
      {
         "pixmapfile" : "turkey/aydin.png",
         //: District of Turkey: Aydın
         "toolTipText" : qsTr("Aydın"),
         "x" : "0.182",
         "y" : "0.59"
      },
      {
         "pixmapfile" : "turkey/antalya.png",
         //: District of Turkey: Antalya
         "toolTipText" : qsTr("Antalya"),
         "x" : "0.304",
         "y" : "0.726"
      },
      {
         "pixmapfile" : "turkey/ankara.png",
         //: District of Turkey: Ankara
         "toolTipText" : qsTr("Ankara"),
         "x" : "0.376",
         "y" : "0.408"
      },
      {
         "pixmapfile" : "turkey/amasya.png",
         //: District of Turkey: Amasya
         "toolTipText" : qsTr("Amasya"),
         "x" : "0.516",
         "y" : "0.303"
      },
      {
         "pixmapfile" : "turkey/aksaray.png",
         //: District of Turkey: Aksaray
         "toolTipText" : qsTr("Aksaray"),
         "x" : "0.435",
         "y" : "0.544"
      },
      {
         "pixmapfile" : "turkey/afyon.png",
         //: District of Turkey: Afyon
         "toolTipText" : qsTr("Afyon"),
         "x" : "0.298",
         "y" : "0.531"
      },
      {
         "pixmapfile" : "turkey/adana.png",
         //: District of Turkey: Adana
         "toolTipText" : qsTr("Adana"),
         "x" : "0.505",
         "y" : "0.651"
      }
   ]
}
