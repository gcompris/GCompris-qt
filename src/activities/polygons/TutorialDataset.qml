/* GCompris - TutorialDataset.qml
 *
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

import "polygons.js" as Activity

QtObject {
    // tutorial levels
    property var tutorialLevels: [
        // level 1
        {
            introMessage: [
                qsTr("A polygon is a closed shape made of at least 3 connected lines."),
                qsTr("To draw a polygon, click on the grid to place the ends of the polygon's lines."),
                qsTr("After placing at least 3 points, you can close the shape by clicking on the first or the last point."),
                qsTr("The points should not be all aligned.")
            ],
            introImage: "qrc:/gcompris/src/activities/polygons/resource/polygon.svg",
            instruction: qsTr("Draw a polygon."),
            validate: function() {
                Activity.computeAngles();
                if(items.polygonAngles.indexOf(0) === -1 &&
                    items.polygonAngles.indexOf(180) === -1) {
                    return true;
                }
                return false;
            }
        },
        // level 2
        {
            introMessage: [
                qsTr("A triangle is a polygon with 3 sides.")
            ],
            introImage: "qrc:/gcompris/src/activities/polygons/resource/triangle.svg",
            instruction: qsTr("Draw a triangle."),
            validate: function() {
                if(items.points.count - 1 === 3) {
                    Activity.computeAngles();
                    if(items.polygonAngles.indexOf(0) === -1 &&
                        items.polygonAngles.indexOf(180) === -1) {
                        return true;
                    }
                }
                return false;
            }
        },
        // level 3
        {
            introMessage: [
                qsTr("A right triangle is a triangle in which two sides are perpendicular, forming a right angle (90 degrees).")
            ],
            introImage: "qrc:/gcompris/src/activities/polygons/resource/triangle-right.svg",
            instruction: qsTr("Draw a right triangle."),
            validate: function() {
                if(items.points.count - 1 === 3) {
                    Activity.computeAngles();
                    if(items.polygonAngles.indexOf(90) != -1) {
                        return true;
                    }
                }
                return false;
            }
        },
        // level 4
        {
            introMessage: [
                qsTr("An isosceles triangle is a triangle with two sides of equal length and two angles of equal measure.")
            ],
            introImage: "qrc:/gcompris/src/activities/polygons/resource/triangle-isosceles.svg",
            instruction: qsTr("Draw an isosceles triangle."),
            validate: function() {
                if(items.points.count - 1 === 3) {
                    Activity.computeAngles();
                    if(items.polygonAngles.indexOf(0) != -1 ||
                        items.polygonAngles.indexOf(180) != -1) {
                        return false;
                    }
                    for(var i = 0; i < items.polygonAngles.length; i++) {
                        var angle = items.polygonAngles[i];
                        for(var j = i + 1; j < items.polygonAngles.length; j++) {
                            if(items.polygonAngles[j] === angle) {
                                return true;
                            }
                        }
                    }
                }
                return false;
            }
        },
        // level 5
        {
            introMessage: [
                qsTr("A quadrilateral is a four-sided polygon, having 4 sides and 4 corners.")
            ],
            introImage: "qrc:/gcompris/src/activities/polygons/resource/quadrilateral.svg",
            instruction: qsTr("Draw a quadrilateral."),
            validate: function() {
                if(items.points.count - 1 === 4) {
                    Activity.computeAngles();
                    if(items.polygonAngles.indexOf(0) === -1 &&
                        items.polygonAngles.indexOf(180) === -1) {
                        return true;
                    }
                }
                return false;
            }
        },
        // level 6
        {
            introMessage: [
                qsTr("A rectangle is a quadrilateral with 4 right angles.")
            ],
            introImage: "qrc:/gcompris/src/activities/polygons/resource/rectangle.svg",
            instruction: qsTr("Draw a rectangle."),
            validate: function() {
                if(items.points.count - 1 === 4) {
                    Activity.computeAngles();
                    if(items.polygonAngles.indexOf(0) != -1 ||
                        items.polygonAngles.indexOf(180) != -1) {
                        return false;
                    }
                    for(var i = 0; i < items.polygonAngles.length; i++) {
                        if(items.polygonAngles[i] != 90) {
                            return false;
                        }
                    }
                    return true;
                }
                return false;
            }
        },
        // level 7
        {
            introMessage: [
                qsTr("A square is a rectangle with 4 sides of equal length.")
            ],
            introImage: "qrc:/gcompris/src/activities/polygons/resource/square.svg",
            instruction: qsTr("Draw a square."),
            validate: function() {
                if(items.points.count - 1 === 4) {
                    Activity.computeAngles();
                    if(items.polygonAngles.indexOf(0) != -1 ||
                        items.polygonAngles.indexOf(180) != -1) {
                        return false;
                    }
                    Activity.computeSides();
                    var sideSize = items.polygonSides[0];
                    for(var i = 0; i < items.polygonAngles.length; i++) {
                        if(items.polygonAngles[i] != 90 || items.polygonSides[i] != sideSize) {
                            return false;
                        }
                    }
                    return true;
                }
                return false;
            }
        },
        // level 8
        {
            introMessage: [
                qsTr("A parallelogram is a quadrilateral with opposite sides of equal length and opposite angles of equal measure.")
            ],
            introImage: "qrc:/gcompris/src/activities/polygons/resource/parallelogram.svg",
            instruction: qsTr("Draw a parallelogram which is not a rectangle."),
            validate: function() {
                if(items.points.count - 1 === 4) {
                    Activity.computeAngles();
                    if(items.polygonAngles.indexOf(0) != -1 ||
                        items.polygonAngles.indexOf(180) != -1) {
                        return false;
                    }
                    Activity.computeSides();
                    if(items.polygonSides[0] === items.polygonSides[2] &&
                        items.polygonSides[1] === items.polygonSides[3] &&
                        items.polygonAngles.indexOf(90) === -1) {
                        return true;
                    }
                }
                return false;
            }
        },
        // level 9
        {
            introMessage: [
                qsTr("A rhombus is a parallelogram with four sides of equal length.")
            ],
            introImage: "qrc:/gcompris/src/activities/polygons/resource/rhombus.svg",
            instruction: qsTr("Draw a rhombus which is not a square."),
            validate: function() {
                if(items.points.count - 1 === 4) {
                    Activity.computeAngles();
                    if(items.polygonAngles.indexOf(0) != -1 ||
                        items.polygonAngles.indexOf(180) != -1) {
                        return false;
                    }
                    Activity.computeSides();
                    var sideSize = items.polygonSides[0];
                    for(var i = 0; i < items.polygonAngles.length; i++) {
                        if(items.polygonAngles[i] === 90 || items.polygonSides[i] != sideSize) {
                            return false;
                        }
                    }
                    return true;
                }
                return false;
            }
        }
    ]
}
