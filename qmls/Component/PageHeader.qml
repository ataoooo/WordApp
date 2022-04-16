import QtQuick 2.0

Rectangle{
    property alias text: headerTxt.text;
    anchors.top: parent.top;
    anchors.horizontalCenter: parent.horizontalCenter;
    width: parent.width;
    height: dp(15);
    color: allColor;
    //header中的文字说明
    Text {
        id: headerTxt;
        color: "white";
        anchors.centerIn: parent;
        font.pixelSize: dp(4.5);
    }//顶部Rect
}
