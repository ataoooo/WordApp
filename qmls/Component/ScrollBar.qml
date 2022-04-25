import QtQuick 2.0

/**
通用滚动轴
属性
    position
    pageSize
    orientation
    需手工设置滚动轴位置
示例
    property Flickable view;
    ScrollBar {
        id: verticalScrollBar
        opacity: 0
        width: 10;
        height: view.height-10
        anchors.right: view.right
        orientation: Qt.Vertical
        position: view.visibleArea.yPosition
        pageSize: view.visibleArea.heightRatio
    }
    ScrollBar {
        id: horizontalScrollBar
        width: view.width-10; height: 10
        anchors.bottom: view.bottom
        opacity: 0
        orientation: Qt.Horizontal
        position: view.visibleArea.xPosition
        pageSize: view.visibleArea.widthRatio
    }
*/
Item {
    id: scrollBar
    property real position
    property real pageSize
    property variant orientation : Qt.Vertical

    Rectangle {
        id: background
        anchors.fill: parent
        radius: orientation == Qt.Vertical ? (width/2 - 1) : (height/2 - 1)
        color: "white"
        opacity: 0.3
    }

    Rectangle {
        x: orientation == Qt.Vertical ? 1 : (scrollBar.position * (scrollBar.width-2) + 1)
        y: orientation == Qt.Vertical ? (scrollBar.position * (scrollBar.height-2) + 1) : 1
        width: orientation == Qt.Vertical ? (parent.width-2) : (scrollBar.pageSize * (scrollBar.width-2))
        height: orientation == Qt.Vertical ? (scrollBar.pageSize * (scrollBar.height-2)) : (parent.height-2)
        radius: orientation == Qt.Vertical ? (width/2 - 1) : (height/2 - 1)
        color: "black"
        opacity: 0.3
    }
}
