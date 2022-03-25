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
   property string instruction: qsTr("Provinces of China")
   property var levels: [
      {
         "pixmapfile" : "china/china.svgz",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "china/xinjiang.svgz",
         //: Province of China: Xinjiang
         "toolTipText" : qsTr("Xinjiang"),
         "x" : "0.2116",
         "y" : "0.3143"
      },
      {
         "pixmapfile" : "china/gansu.svgz",
         //: Province of China: Gansu
         "toolTipText" : qsTr("Gansu"),
         "x" : "0.4673",
         "y" : "0.464"
      },
      {
         "pixmapfile" : "china/inner_mongolia.svgz",
         //: Province of China: Inner Mongolia
         "toolTipText" : qsTr("Inner Mongolia"),
         "x" : "0.6282",
         "y" : "0.2569"
      },
      {
         "pixmapfile" : "china/ningxia.svgz",
         //: Province of China: Ningxia
         "toolTipText" : qsTr("Ningxia"),
         "x" : "0.5582",
         "y" : "0.4768"
      },
      {
         "pixmapfile" : "china/heilongjiang.svgz",
         //: Province of China: Heilongjiang
         "toolTipText" : qsTr("Heilongjiang"),
         "x" : "0.8727",
         "y" : "0.1435"
      },
      {
         "pixmapfile" : "china/jilin.svgz",
         //: Province of China: Jilin
         "toolTipText" : qsTr("Jilin"),
         "x" : "0.8762",
         "y" : "0.2753"
      },
      {
         "pixmapfile" : "china/liaoning.svgz",
         //: Province of China: Liaoning
         "toolTipText" : qsTr("Liaoning"),
         "x" : "0.8247",
         "y" : "0.3473"
      },
      {
         "pixmapfile" : "china/tianjin.svgz",
         //: Province of China: Tianjin
         "toolTipText" : qsTr("Tianjin"),
         "x" : "0.7495",
         "y" : "0.4068"
      },
      {
         "pixmapfile" : "china/beijing.svgz",
         //: Province of China: Beijing
         "toolTipText" : qsTr("Beijing"),
         "x" : "0.7308",
         "y" : "0.3868"
      },
      {
         "pixmapfile" : "china/shandong.svgz",
         //: Province of China: Shandong
         "toolTipText" : qsTr("Shandong"),
         "x" : "0.7803",
         "y" : "0.4864"
      },
      {
         "pixmapfile" : "china/shanxi.svgz",
         //: Province of China: Shanxi
         "toolTipText" : qsTr("Shanxi"),
         "x" : "0.6678",
         "y" : "0.4625"
      },
      {
         "pixmapfile" : "china/shaanxi.svgz",
         //: Province of China: Shaanxi
         "toolTipText" : qsTr("Shaanxi"),
         "x" : "0.6004",
         "y" : "0.5184"
      },
      {
         "pixmapfile" : "china/qinghai.svgz",
         //: Province of China: Qinghai
         "toolTipText" : qsTr("Qinghai"),
         "x" : "0.3864",
         "y" : "0.5161"
      },
      {
         "pixmapfile" : "china/tibet.svgz",
         //: Province of China: Tibet
         "toolTipText" : qsTr("Tibet"),
         "x" : "0.2439",
         "y" : "0.5884"
      },
      {
         "pixmapfile" : "china/sichuan.svgz",
         //: Province of China: Sichuan
         "toolTipText" : qsTr("Sichuan"),
         "x" : "0.5045",
         "y" : "0.6627"
      },
      {
         "pixmapfile" : "china/chongqing.svgz",
         //: Province of China: Chongqing
         "toolTipText" : qsTr("Chongqing"),
         "x" : "0.5924",
         "y" : "0.6633"
      },
      {
         "pixmapfile" : "china/henan.svgz",
         //: Province of China: Henan
         "toolTipText" : qsTr("Henan"),
         "x" : "0.6939",
         "y" : "0.5579"
      },
      {
         "pixmapfile" : "china/jiangsu.svgz",
         //: Province of China: Jiangsu
         "toolTipText" : qsTr("Jiangsu"),
         "x" : "0.7992",
         "y" : "0.5674"
      },
      {
         "pixmapfile" : "china/anhui.svgz",
         //: Province of China: Anhui
         "toolTipText" : qsTr("Anhui"),
         "x" : "0.7676",
         "y" : "0.5996"
      },
      {
         "pixmapfile" : "china/hubei.svgz",
         //: Province of China: Hubei
         "toolTipText" : qsTr("Hubei"),
         "x" : "0.6785",
         "y" : "0.6356"
      },
      {
         "pixmapfile" : "china/shanghai.svgz",
         //: Province of China: Shanghai
         "toolTipText" : qsTr("Shanghai"),
         "x" : "0.8477",
         "y" : "0.6062"
      },
      {
         "pixmapfile" : "china/zhejiang.svgz",
         //: Province of China: Zhejiang
         "toolTipText" : qsTr("Zhejiang"),
         "x" : "0.8298",
         "y" : "0.6647"
      },
      {
         "pixmapfile" : "china/fujian.svgz",
         //: Province of China: Fujian
         "toolTipText" : qsTr("Fujian"),
         "x" : "0.7998",
         "y" : "0.7563"
      },
      {
         "pixmapfile" : "china/jiangxi.svgz",
         //: Province of China: Jiangxi
         "toolTipText" : qsTr("Jiangxi"),
         "x" : "0.7542",
         "y" : "0.7271"
      },
      {
         "pixmapfile" : "china/hunan.svgz",
         //: Province of China: Hunan
         "toolTipText" : qsTr("Hunan"),
         "x" : "0.6696",
         "y" : "0.7335"
      },
      {
         "pixmapfile" : "china/guizhou.svgz",
         //: Province of China: Guizhou
         "toolTipText" : qsTr("Guizhou"),
         "x" : "0.5725",
         "y" : "0.7496"
      },
      {
         "pixmapfile" : "china/yunnan.svgz",
         //: Province of China: Yunnan
         "toolTipText" : qsTr("Yunnan"),
         "x" : "0.478",
         "y" : "0.7919"
      },
      {
         "pixmapfile" : "china/guangxi.svgz",
         //: Province of China: Guangxi
         "toolTipText" : qsTr("Guangxi"),
         "x" : "0.6073",
         "y" : "0.8254"
      },
      {
         "pixmapfile" : "china/guangdong.svgz",
         //: Province of China: Guangdong
         "toolTipText" : qsTr("Guangdong"),
         "x" : "0.7137",
         "y" : "0.8497"
      },
      {
         "pixmapfile" : "china/hainan.svgz",
         //: Province of China: Hainan
         "toolTipText" : qsTr("Hainan"),
         "x" : "0.6434",
         "y" : "0.9463"
      },
      {
         "pixmapfile" : "china/hebei.svgz",
         //: Province of China: Hebei
         "toolTipText" : qsTr("Hebei"),
         "x" : "0.7374",
         "y" : "0.411"
      }
   ]
}
