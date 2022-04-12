import QtQuick 2.0
import QtQuick.Controls 2.5
import "../Component"
Page {
    id: page
    anchors.fill: parent
    opacity: 0
    //仅当opacity>0时页面可见
    visible: opacity > 0
    //仅当可见时启用页面操作
    enabled: visible
    Rectangle{
        anchors.fill: parent
        z: 0
        color: "#eeeeee"
    }

    ///整体作一个可滑动页面
    Flickable {
        id: inner
        clip: true
        anchors{
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
        }
        boundsBehavior: Flickable.StopAtBounds; //设置到顶部后顶部无法下拉
        //contentHeight : btGroup.y + btGroup.height;
        width: parent.width;
        //顶部图片
        Image {
            id: top;
            source: "../../assets/mdpi/top.png";
            width: parent.width;
            height: width / 2
            //fillMode: Image.PreserveAspectFit;
        }
        //左上角欢迎文字
        Rectangle{
            color: "transparent"
            anchors{
                top: parent.top
                topMargin: dp(3)
                left: parent.left
                leftMargin: dp(3)
            }

            Text {
                id: welText
                color: "white"
                font.pixelSize: dp(4)
                text: qsTr("登录为：")+root.userName
            }
        }
        //右上角的二维码图片
        Image {
            id:ewmImg
            source: "../../assets/mdpi/ic_barcode.png";
            width: dp(8)
            fillMode: Image.PreserveAspectFit;
            anchors{
                top:parent.top
                topMargin: dp(3)
                right: parent.right;
                rightMargin: dp(3);
            }
            MouseArea{
                anchors.centerIn: parent;
                width: parent.width;
                height: parent.height;
                onClicked:{
                    console.log("click ewm")
                    //要做什么呢？？？？wait
                }
            }
        }

        //这里好像需要一个搜索框框啦
        SearchEdit{
            id:search
            anchors{
                top: ewmImg.bottom
                topMargin: dp(5)
                horizontalCenter: parent.horizontalCenter
            }
            width: parent.width * 0.95

        }



        //底部按键组布局
    }
}
