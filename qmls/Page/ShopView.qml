import QtQuick 2.12
import QtQuick.Controls 2.12
import "../Component"

StackPageBase{
    id: page;
    _title: "商城";
    Flickable {
        id: wxPgae;
        clip: true;
        anchors.top: parent.top;
        anchors.bottom: parent.bottom;
        width: dp(100);
        contentWidth: dp(200);
        contentHeight: img.height
        contentX: dp(100);
        flickableDirection: Flickable.VerticalFlick; //只允许垂直滑动
        Image {
            id: img;
            x: dp(100); //预设在右端
            width: dp(100);
            height: dp(331);
            source: "../../assets/mdpi/shop.jpg"
        }
        Rectangle {
            id: edit;
            x: 0;
            width: dp(100);
            height: dp(250);
            color: "transparent";
        }
        PropertyAnimation {
            id: switchAni;
            target: wxPgae;
            property: "contentX";
            from: 0
            to: dp(100)
            duration: 150;
            easing.type: Easing.OutQuart;
        }
    }
}
