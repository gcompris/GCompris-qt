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
   property string instruction: qsTr("Districts of China")
   property var levels: [
      {
         "pixmapfile" : "china/background.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "china/xinjiang.png",
         //: District of China: Xinjiang
         "toolTipText" : qsTr("Xinjiang"),
         "x" : "0.201",
         "y" : "0.275"
      },
      {
         "pixmapfile" : "china/gansu.png",
         //: District of China: Gansu
         "toolTipText" : qsTr("Gansu"),
         "x" : "0.459",
         "y" : "0.445"
      },
      {
         "pixmapfile" : "china/inner_mongolia.png",
         //: District of China: Inner Mongolia
         "toolTipText" : qsTr("Inner Mongolia"),
         "x" : "0.631",
         "y" : "0.237"
      },
      {
         "pixmapfile" : "china/ningxia.png",
         //: District of China: Ningxia
         "toolTipText" : qsTr("Ningxia"),
         "x" : "0.552",
         "y" : "0.464"
      },
      {
         "pixmapfile" : "china/heilongjiang.png",
         //: District of China: Heilongjiang
         "toolTipText" : qsTr("Heilongjiang"),
         "x" : "0.886",
         "y" : "0.132"
      },
      {
         "pixmapfile" : "china/jilin.png",
         //: District of China: Jilin
         "toolTipText" : qsTr("Jilin"),
         "x" : "0.883",
         "y" : "0.274"
      },
      {
         "pixmapfile" : "china/liaoning.png",
         //: District of China: Liaoning
         "toolTipText" : qsTr("Liaoning"),
         "x" : "0.828",
         "y" : "0.34"
      },
      {
         "pixmapfile" : "china/tianjin.png",
         //: District of China: Tianjin
         "toolTipText" : qsTr("Tianjin"),
         "x" : "0.746",
         "y" : "0.402"
      },
      {
         "pixmapfile" : "china/beijing.png",
         //: District of China: Beijing
         "toolTipText" : qsTr("Beijing"),
         "x" : "0.729",
         "y" : "0.381"
      },
      {
         "pixmapfile" : "china/shandong.png",
         //: District of China: Shandong
         "toolTipText" : qsTr("Shandong"),
         "x" : "0.776",
         "y" : "0.485"
      },
      {
         "pixmapfile" : "china/shanxi.png",
         //: District of China: Shanxi
         "toolTipText" : qsTr("Shanxi"),
         "x" : "0.662",
         "y" : "0.456"
      },
      {
         "pixmapfile" : "china/shaanxi.png",
         //: District of China: Shaanxi
         "toolTipText" : qsTr("Shaanxi"),
         "x" : "0.591",
         "y" : "0.511"
      },
      {
         "pixmapfile" : "china/qinghai.png",
         //: District of China: Qinghai
         "toolTipText" : qsTr("Qinghai"),
         "x" : "0.372",
         "y" : "0.492"
      },
      {
         "pixmapfile" : "china/xizang.png",
         //: District of China: Xizang
         "toolTipText" : qsTr("Xizang"),
         "x" : "0.223",
         "y" : "0.558"
      },
      {
         "pixmapfile" : "china/sichuan.png",
         //: District of China: Sichuan
         "toolTipText" : qsTr("Sichuan"),
         "x" : "0.489",
         "y" : "0.652"
      },
      {
         "pixmapfile" : "china/chongqing.png",
         //: District of China: Chongqing
         "toolTipText" : qsTr("Chongqing"),
         "x" : "0.576",
         "y" : "0.659"
      },
      {
         "pixmapfile" : "china/henan.png",
         //: District of China: Henan
         "toolTipText" : qsTr("Henan"),
         "x" : "0.685",
         "y" : "0.556"
      },
      {
         "pixmapfile" : "china/jiangsu.png",
         //: District of China: Jiangsu
         "toolTipText" : qsTr("Jiangsu"),
         "x" : "0.792",
         "y" : "0.573"
      },
      {
         "pixmapfile" : "china/anhui.png",
         //: District of China: Anhui
         "toolTipText" : qsTr("Anhui"),
         "x" : "0.757",
         "y" : "0.603"
      },
      {
         "pixmapfile" : "china/hubei.png",
         //: District of China: Hubei
         "toolTipText" : qsTr("Hubei"),
         "x" : "0.665",
         "y" : "0.632"
      },
      {
         "pixmapfile" : "china/shanghai.png",
         //: District of China: Shanghai
         "toolTipText" : qsTr("Shanghai"),
         "x" : "0.838",
         "y" : "0.618"
      },
      {
         "pixmapfile" : "china/zhejiang.png",
         //: District of China: Zhejiang
         "toolTipText" : qsTr("Zhejiang"),
         "x" : "0.815",
         "y" : "0.673"
      },
      {
         "pixmapfile" : "china/fujian.png",
         //: District of China: Fujian
         "toolTipText" : qsTr("Fujian"),
         "x" : "0.785",
         "y" : "0.769"
      },
      {
         "pixmapfile" : "china/jiangxi.png",
         //: District of China: Jiangxi
         "toolTipText" : qsTr("Jiangxi"),
         "x" : "0.74",
         "y" : "0.735"
      },
      {
         "pixmapfile" : "china/hunan.png",
         //: District of China: Hunan
         "toolTipText" : qsTr("Hunan"),
         "x" : "0.651",
         "y" : "0.737"
      },
      {
         "pixmapfile" : "china/guizhou.png",
         //: District of China: Guizhou
         "toolTipText" : qsTr("Guizhou"),
         "x" : "0.552",
         "y" : "0.747"
      },
      {
         "pixmapfile" : "china/yunnan.png",
         //: District of China: Yunnan
         "toolTipText" : qsTr("Yunnan"),
         "x" : "0.453",
         "y" : "0.786"
      },
      {
         "pixmapfile" : "china/guangxi.png",
         //: District of China: Guangxi
         "toolTipText" : qsTr("Guangxi"),
         "x" : "0.586",
         "y" : "0.833"
      },
      {
         "pixmapfile" : "china/guangdong.png",
         //: District of China: Guangdong
         "toolTipText" : qsTr("Guangdong"),
         "x" : "0.691",
         "y" : "0.861"
      },
      {
         "pixmapfile" : "china/hainan.png",
         //: District of China: Hainan
         "toolTipText" : qsTr("Hainan"),
         "x" : "0.617",
         "y" : "0.966"
      },
      {
         "pixmapfile" : "china/hebei.png",
         //: District of China: Hebei
         "toolTipText" : qsTr("Hebei"),
         "x" : "0.735",
         "y" : "0.405"
      }
   ]
}
