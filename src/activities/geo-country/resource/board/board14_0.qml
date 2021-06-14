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
         "x" : "0.2105",
         "y" : "0.2893"
      },
      {
         "pixmapfile" : "china/gansu.svgz",
         //: Province of China: Gansu
         "toolTipText" : qsTr("Gansu"),
         "x" : "0.4617",
         "y" : "0.4496"
      },
      {
         "pixmapfile" : "china/inner_mongolia.svgz",
         //: Province of China: Inner Mongolia
         "toolTipText" : qsTr("Inner Mongolia"),
         "x" : "0.6288",
         "y" : "0.2522"
      },
      {
         "pixmapfile" : "china/ningxia.svgz",
         //: Province of China: Ningxia
         "toolTipText" : qsTr("Ningxia"),
         "x" : "0.551",
         "y" : "0.4675"
      },
      {
         "pixmapfile" : "china/heilongjiang.svgz",
         //: Province of China: Heilongjiang
         "toolTipText" : qsTr("Heilongjiang"),
         "x" : "0.8766",
         "y" : "0.1547"
      },
      {
         "pixmapfile" : "china/jilin.svgz",
         //: Province of China: Jilin
         "toolTipText" : qsTr("Jilin"),
         "x" : "0.873",
         "y" : "0.2875"
      },
      {
         "pixmapfile" : "china/liaoning.svgz",
         //: Province of China: Liaoning
         "toolTipText" : qsTr("Liaoning"),
         "x" : "0.819",
         "y" : "0.355"
      },
      {
         "pixmapfile" : "china/tianjin.svgz",
         //: Province of China: Tianjin
         "toolTipText" : qsTr("Tianjin"),
         "x" : "0.7414",
         "y" : "0.409"
      },
      {
         "pixmapfile" : "china/beijing.svgz",
         //: Province of China: Beijing
         "toolTipText" : qsTr("Beijing"),
         "x" : "0.7244",
         "y" : "0.3894"
      },
      {
         "pixmapfile" : "china/shandong.svgz",
         //: Province of China: Shandong
         "toolTipText" : qsTr("Shandong"),
         "x" : "0.7687",
         "y" : "0.4815"
      },
      {
         "pixmapfile" : "china/shanxi.svgz",
         //: Province of China: Shanxi
         "toolTipText" : qsTr("Shanxi"),
         "x" : "0.6579",
         "y" : "0.4577"
      },
      {
         "pixmapfile" : "china/shaanxi.svgz",
         //: Province of China: Shaanxi
         "toolTipText" : qsTr("Shaanxi"),
         "x" : "0.5865",
         "y" : "0.5114"
      },
      {
         "pixmapfile" : "china/qinghai.svgz",
         //: Province of China: Qinghai
         "toolTipText" : qsTr("Qinghai"),
         "x" : "0.3774",
         "y" : "0.494"
      },
      {
         "pixmapfile" : "china/tibet.svgz",
         //: Province of China: Tibet
         "toolTipText" : qsTr("Tibet"),
         "x" : "0.2318",
         "y" : "0.5639"
      },
      {
         "pixmapfile" : "china/sichuan.svgz",
         //: Province of China: Sichuan
         "toolTipText" : qsTr("Sichuan"),
         "x" : "0.4904",
         "y" : "0.6441"
      },
      {
         "pixmapfile" : "china/chongqing.svgz",
         //: Province of China: Chongqing
         "toolTipText" : qsTr("Chongqing"),
         "x" : "0.5746",
         "y" : "0.6514"
      },
      {
         "pixmapfile" : "china/henan.svgz",
         //: Province of China: Henan
         "toolTipText" : qsTr("Henan"),
         "x" : "0.6809",
         "y" : "0.5547"
      },
      {
         "pixmapfile" : "china/jiangsu.svgz",
         //: Province of China: Jiangsu
         "toolTipText" : qsTr("Jiangsu"),
         "x" : "0.7842",
         "y" : "0.5697"
      },
      {
         "pixmapfile" : "china/anhui.svgz",
         //: Province of China: Anhui
         "toolTipText" : qsTr("Anhui"),
         "x" : "0.7518",
         "y" : "0.598"
      },
      {
         "pixmapfile" : "china/hubei.svgz",
         //: Province of China: Hubei
         "toolTipText" : qsTr("Hubei"),
         "x" : "0.6614",
         "y" : "0.6265"
      },
      {
         "pixmapfile" : "china/shanghai.svgz",
         //: Province of China: Shanghai
         "toolTipText" : qsTr("Shanghai"),
         "x" : "0.8298",
         "y" : "0.6086"
      },
      {
         "pixmapfile" : "china/zhejiang.svgz",
         //: Province of China: Zhejiang
         "toolTipText" : qsTr("Zhejiang"),
         "x" : "0.8158",
         "y" : "0.6608"
      },
      {
         "pixmapfile" : "china/fujian.svgz",
         //: Province of China: Fujian
         "toolTipText" : qsTr("Fujian"),
         "x" : "0.7785",
         "y" : "0.7593"
      },
      {
         "pixmapfile" : "china/jiangxi.svgz",
         //: Province of China: Jiangxi
         "toolTipText" : qsTr("Jiangxi"),
         "x" : "0.7345",
         "y" : "0.723"
      },
      {
         "pixmapfile" : "china/hunan.svgz",
         //: Province of China: Hunan
         "toolTipText" : qsTr("Hunan"),
         "x" : "0.6479",
         "y" : "0.7247"
      },
      {
         "pixmapfile" : "china/guizhou.svgz",
         //: Province of China: Guizhou
         "toolTipText" : qsTr("Guizhou"),
         "x" : "0.5518",
         "y" : "0.7354"
      },
      {
         "pixmapfile" : "china/yunnan.svgz",
         //: Province of China: Yunnan
         "toolTipText" : qsTr("Yunnan"),
         "x" : "0.4546",
         "y" : "0.771"
      },
      {
         "pixmapfile" : "china/guangxi.svgz",
         //: Province of China: Guangxi
         "toolTipText" : qsTr("Guangxi"),
         "x" : "0.5834",
         "y" : "0.8159"
      },
      {
         "pixmapfile" : "china/guangdong.svgz",
         //: Province of China: Guangdong
         "toolTipText" : qsTr("Guangdong"),
         "x" : "0.6866",
         "y" : "0.8424"
      },
      {
         "pixmapfile" : "china/hainan.svgz",
         //: Province of China: Hainan
         "toolTipText" : qsTr("Hainan"),
         "x" : "0.614",
         "y" : "0.9403"
      },
      {
         "pixmapfile" : "china/hebei.svgz",
         //: Province of China: Hebei
         "toolTipText" : qsTr("Hebei"),
         "x" : "0.7296",
         "y" : "0.4118"
      }
   ]
}
