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
import QtQuick 2.6

QtObject {
   property string instruction: qsTr("Districts of China")
   property var levels: [
      {
         "pixmapfile" : "china/background.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "china/xinjiang.png",
         "toolTipText" : "Xinjiang",
         "x" : "0.201",
         "y" : "0.275"
      },
      {
         "pixmapfile" : "china/gansu.png",
         "toolTipText" : "Gansu",
         "x" : "0.459",
         "y" : "0.445"
      },
      {
         "pixmapfile" : "china/inner_mongolia.png",
         "toolTipText" : "Inner Mangolia",
         "x" : "0.631",
         "y" : "0.237"
      },
      {
         "pixmapfile" : "china/ningxia.png",
         "toolTipText" : "Ningxia",
         "x" : "0.552",
         "y" : "0.464"
      },
      {
         "pixmapfile" : "china/heilongjiang.png",
         "toolTipText" : "Heilongjiang",
         "x" : "0.886",
         "y" : "0.132"
      },
      {
         "pixmapfile" : "china/jilin.png",
         "toolTipText" : "Jilin",
         "x" : "0.883",
         "y" : "0.274"
      },
      {
         "pixmapfile" : "china/liaoning.png",
         "toolTipText" : "Liaoning",
         "x" : "0.828",
         "y" : "0.34"
      },
      {
         "pixmapfile" : "china/tianjin.png",
         "toolTipText" : "Tianjin",
         "x" : "0.746",
         "y" : "0.402"
      },
      {
         "pixmapfile" : "china/beijing.png",
         "toolTipText" : "Beijing",
         "x" : "0.729",
         "y" : "0.381"
      },
      {
         "pixmapfile" : "china/shandong.png",
         "toolTipText" : "Shandong",
         "x" : "0.776",
         "y" : "0.485"
      },
      {
         "pixmapfile" : "china/shanxi.png",
         "toolTipText" : "Shanxi",
         "x" : "0.662",
         "y" : "0.456"
      },
      {
         "pixmapfile" : "china/shaanxi.png",
         "toolTipText" : "Shaanxi",
         "x" : "0.591",
         "y" : "0.511"
      },
      {
         "pixmapfile" : "china/qinghai.png",
         "toolTipText" : "Qinghai",
         "x" : "0.372",
         "y" : "0.492"
      },
      {
         "pixmapfile" : "china/xizang.png",
         "toolTipText" : "Xizang",
         "x" : "0.223",
         "y" : "0.558"
      },
      {
         "pixmapfile" : "china/sichuan.png",
         "toolTipText" : "Sichuan",
         "x" : "0.489",
         "y" : "0.652"
      },
      {
         "pixmapfile" : "china/chongqing.png",
         "toolTipText" : "Chongqing",
         "x" : "0.576",
         "y" : "0.659"
      },
      {
         "pixmapfile" : "china/henan.png",
         "toolTipText" : "Henan",
         "x" : "0.685",
         "y" : "0.556"
      },
      {
         "pixmapfile" : "china/jiangsu.png",
         "toolTipText" : "Jiangsu",
         "x" : "0.792",
         "y" : "0.573"
      },
      {
         "pixmapfile" : "china/anhui.png",
         "toolTipText" : "Anhui",
         "x" : "0.757",
         "y" : "0.603"
      },
      {
         "pixmapfile" : "china/hubei.png",
         "toolTipText" : "Hubei",
         "x" : "0.665",
         "y" : "0.632"
      },
      {
         "pixmapfile" : "china/shanghai.png",
         "toolTipText" : "Shanghai",
         "x" : "0.838",
         "y" : "0.618"
      },
      {
         "pixmapfile" : "china/zhejiang.png",
         "toolTipText" : "Zhejiang",
         "x" : "0.815",
         "y" : "0.673"
      },
      {
         "pixmapfile" : "china/fujian.png",
         "toolTipText" : "Fujian",
         "x" : "0.785",
         "y" : "0.769"
      },
      {
         "pixmapfile" : "china/jiangxi.png",
         "toolTipText" : "Jiangxi",
         "x" : "0.74",
         "y" : "0.735"
      },
      {
         "pixmapfile" : "china/hunan.png",
         "toolTipText" : "Hunan",
         "x" : "0.651",
         "y" : "0.737"
      },
      {
         "pixmapfile" : "china/guizhou.png",
         "toolTipText" : "Guizhou",
         "x" : "0.552",
         "y" : "0.747"
      },
      {
         "pixmapfile" : "china/yunnan.png",
         "toolTipText" : "Yunnan",
         "x" : "0.453",
         "y" : "0.786"
      },
      {
         "pixmapfile" : "china/guangxi.png",
         "toolTipText" : "Guangxi",
         "x" : "0.586",
         "y" : "0.833"
      },
      {
         "pixmapfile" : "china/guangdong.png",
         "toolTipText" : "Guangdong",
         "x" : "0.691",
         "y" : "0.861"
      },
      {
         "pixmapfile" : "china/hainan.png",
         "toolTipText" : "Hainan",
         "x" : "0.617",
         "y" : "0.966"
      },
      {
         "pixmapfile" : "china/hebei.png",
         "toolTipText" : "Hebei",
         "x" : "0.735",
         "y" : "0.405"
      }
   ]
}
