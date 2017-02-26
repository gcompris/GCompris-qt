import QtQuick 2.1
import GCompris 1.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

import "../../core"

ActivityBase {
    id: activity

    activityInfo: QtObject {
        property bool demo: false
    }

    property string url: "qrc:/gcompris/src/activities/menu/resource/"
    pageComponent: Image {
        id: background
        source: activity.url + "background.svg"
        sourceSize.width: Math.max(parent.width, parent.height)
        height: parent.height
        fillMode: Image.PreserveAspectCrop

        property int iconWidth: 120 * ApplicationInfo.ratio
        property int iconHeight: 120 * ApplicationInfo.ratio
        property int activityCellWidth: background.width / Math.floor(background.width / iconWidth)
        property int activityCellHeight: iconHeight * 1.7
        property bool activitiesVisible: true
        property bool usersVisible: false
        property bool resultsVisible: false
        property string currentActivity: ""
        property var result: null

        GridView {
            id: activitiesGrid
            width: background.width
            height: background.height - (bar.height*2)
            cellWidth: activityCellWidth
            cellHeight: activityCellHeight
            visible: background.activitiesVisible
            property var menuTree: ActivityInfoTree.fullTree()
            property int spacing: 10
            model:ActivityInfoTree.menuTree

            delegate: Item {
                id: activityDelegate
                width: activityCellWidth - activitiesGrid.spacing
                height: activityCellHeight - activitiesGrid.spacing
                Rectangle {
                    id: activityBackground
                    width: parent.width
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "white"
                    opacity: 0.5
                }
                Image {
                    source: "qrc:/gcompris/src/activities/" + icon;
                    anchors.top: activityBackground.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    sourceSize.height: iconHeight
                    anchors.margins: 5
                    GCText {
                        id: title
                        anchors.top: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Text.AlignHCenter
                        width: activityBackground.width
                        fontSizeMode: Text.Fit
                        minimumPointSize: 7
                        fontSize: regularSize
                        elide: Text.ElideRight
                        maximumLineCount: 2
                        wrapMode: Text.WordWrap
                        text: modelData.title
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked:{
                        background.activitiesVisible = false
                        background.usersVisible = true
                        background.currentActivity = modelData.name
                    }
                }

            }

        }
        Item {
            id: users
            anchors.fill:parent
            visible: background.usersVisible
            GridView {
                id: userView
                width: parent.width
                height: parent.height - (bar.height*2)
                cellWidth: parent.width/10
                cellHeight: cellWidth
                model: MessageHandler.users
                property var currentUser: null
                delegate: Rectangle {
                    id: userDelegate
                    width: userView.cellWidth/1.25
                    height: width
                    color: "red"
                    GCText {
                        text: modelData.name
                        fontSize: mediumSize

                    }
                    MouseArea {
                        anchors.fill: parent
                        // get the activity data
                        onClicked:{
                            userView.currentUser = modelData
                            background.result = modelData.getActivityData(background.currentActivity)
                            background.usersVisible = false
                            background.resultsVisible = true
                            results.storeData()
                        }
                    }

                }

                Connections {
                    target: MessageHandler
                    onNewActivityData: {
                        console.log("new data received")
                        background.result = userView.currentUser.getActivityData(background.currentActivity)
                        results.storeData()
                    }
                }
            }
        }
        Item {
            id: results
            anchors.fill:parent
            visible: background.resultsVisible
            property var datalist: []
            function storeData(){
                results.datalist = new Array;
                var m_date=""
                var m_data=""
                for(var date in background.result){
                    m_date=date
                    var list = background.result[date]
                    for(var i=0; i<list.length; i++){
                        var x = list[i]
                        for(var y in x){

                            m_data += y + "  " + x[y] + "  "
                        }
                        results.datalist.push({"date":m_date,
                                                  "data": m_data
                                              })
                        m_data=""
                    }
                }
                for(var j=0; j<results.datalist.length; j++){
                    console.log(results.datalist[j].date, results.datalist[j].data)
                }
                resultView.model = results.datalist
            }

            ListView {
                id: resultView
                width: parent.width
                height: parent.height - (bar.height*2)
                model: results.datalist
                spacing: 20
                MouseArea {
                    anchors.fill: parent
                }
                delegate: Rectangle {
                    id: resultDelegate
                    width: parent.width
                    height: width/12
                    color: "black"
                    opacity: 0.4
                    Button {
                        id: dateButton
                        width: parent.width/5
                        height: parent.height
                        style: GCButtonStyle {
                            theme: "highContrast"
                        }
                        GCText {
                            text: modelData.date
                            color: "black"
                            fontSize:  largeSize
                            anchors.centerIn: parent
                        }
                    }
                    Button {
                        id: dataButton
                        height: parent.height
                        anchors.left: dateButton.right
                        anchors.leftMargin: 20
                        anchors.right: parent.right
                        style: GCButtonStyle {
                            theme:"highContrast"
                        }
                        GCText {
                            text: modelData.data
                            color: "black"
                            fontSize: largeSize
                            anchors.centerIn: parent
                        }
                    }
                }
            }
        }

        Bar {
            id: bar
            content: BarEnumContent { value: home | previousView}
            onHomeClicked: activity.home()
            onPreviousViewClicked: {
                console.log(background.activitiesVisible)
                console.log(background.usersVisible)
                if(background.activitiesVisible)
                    activity.home()
                if(background.usersVisible)
                {
                    background.usersVisible = false
                    background.activitiesVisible = true
                }
                if (background.resultsVisible)
                {
                    background.resultsVisible = false
                    resultView.model = []
                    background.usersVisible = true
                }
            }

        }

    }
}
