import QtQuick 2.0
import QtQuick.Controls 2.5
import QtCharts 2.0
import "../Component"
Page {
    id: page
    anchors.fill: parent
    opacity: 0
    //仅当opacity>0时页面可见
    visible: opacity > 0
    //仅当可见时启用页面操作
    enabled: visible
    property bool isReplace: false
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
                    root.pushStack(2)
                }
            }
        }

        //搜索框
        SearchEdit{
            id:search
            anchors{
                top: ewmImg.bottom
                topMargin: dp(5)
                horizontalCenter: parent.horizontalCenter
            }
            width: parent.width * 0.95
            z:99
        }

        //下方的一些图标
        Row{
            id:rowname
            anchors{
                top:search.bottom
                topMargin: dp(3)
                horizontalCenter: parent.horizontalCenter
            }
            width: search.width
            height: dp(12)
            //图片+文字
            PngEdit{
                width:search.width/5
                iconSource:"../../assets/mdpi/book.png"
                iconText:"单词本"
                MouseArea{
                    anchors.fill: parent
                    onClicked: root.pushStack(9)
                }
            }
            PngEdit{
                width:search.width/5
                iconSource:"../../assets/mdpi/phrase.png"
                iconText:"例句"
                MouseArea{
                    anchors.fill: parent
                    onClicked:{
                        root.pushStack(11)
                        root.getModel()
                    }
                }
            }
            PngEdit{
                width:search.width/5
                iconSource:"../../assets/mdpi/collectPng.png"
                iconText:"我的收藏"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        root.pushStack(12)
                    }
                }
            }
            PngEdit{
                width: search.width/5
                iconSource:"../../assets/mdpi/import.png"
                iconText:"导入单词"
                MouseArea{
                    anchors.fill: parent
                    onClicked:{
                        root.pushStack(8)}
                }
            }
            PngEdit{
                width:search.width/5
                iconSource:"../../assets/mdpi/shop.png"
                iconText:"商城"
                MouseArea{
                    anchors.fill: parent
                    onClicked: root.pushStack(7)
                }
            }
        }

        //滑动广告位
        SwipeView {
            id: swipeView
            width: parent.width
            height: dp(30)
            anchors.top: rowname.bottom
            anchors.topMargin: dp(3)
            currentIndex: 0 // 当前页面的索引 1
            Item{
                Rectangle{
                    id:rec1
                    radius: 5
                    color: "red"
                    Text{
                        anchors.centerIn: parent
                        font.pixelSize: 50
                        text: "广告位招租"
                    }
                    anchors.fill: parent
                }
            }
            Item{
                Rectangle{
                    id:rec2
                    radius: 5
                    color: "blue"
                    Text{
                        anchors.centerIn: parent
                        text: "广告位招租"
                        font.pixelSize: 50
                    }
                    anchors.fill: parent
                }
            }
        }

        //定时器，触发广告位的自动切换
        Timer{
            id:countDown;
            interval: 5000; //时延5s
            repeat: true;
            triggeredOnStart: true;
            onTriggered: {
                //启动时并不切换
                if(!isReplace)
                {
                    isReplace = true;
                    return;
                }
                if(swipeView.currentIndex == 0)
                    swipeView.currentIndex = 1;
                else swipeView.currentIndex = 0;
            }
        }
        //底部按键组布局
    }









    Component.onCompleted: {
        countDown.start();
    }


}
