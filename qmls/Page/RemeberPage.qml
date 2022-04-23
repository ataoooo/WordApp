import QtQuick 2.0
import QtQuick.Controls 2.5
import "../Component"

Page {
    id: page3
    anchors.fill: parent
    opacity: 0
    visible: opacity > 0
    Rectangle{
        anchors.fill: parent
        z: 0
        color: "#eeeeee"
    }
    //头部红色背景
    PageHeader{
        id:header
    }

    //制定策略按钮
    Rectangle{
        id:setRec
        width: parent.width / 4
        height:  header.height * 0.6
        color: "#eeb646"
        radius: dp(3)
        anchors{
            centerIn: header
        }
        Text {
            anchors.centerIn: parent
            text: "设置策略"
            color: "white"
            font.pixelSize: dp(4)
        }
    }

    ///整体作一个可滑动页面
    Flickable {
        id: inner
        clip: true
        anchors{
            top: header.bottom
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
        }
        flickableDirection: Flickable.VerticalFlick; //只允许垂直滑动
        width: parent.width;
        contentWidth: dp(100);
        contentHeight: dp(200)
        contentX: dp(0);

        //显示单词框
        Rectangle{
            id:sowRec
            width: parent.width * 0.8
            height: parent.height * 0.15
            color: "white"
            anchors{
                top: parent.top
                topMargin: dp(10)
                horizontalCenter: parent.horizontalCenter
            }
            Text {
                anchors.centerIn: parent
                text: "acclaim"
                font.pixelSize: dp(8)
                color: "red"
                wrapMode:Text.Wrap
            }
        }

        Row{
            id:r1
            width: sowRec.width * 0.6
            anchors{
                top: sowRec.bottom
                topMargin: dp(3)
                horizontalCenter: parent.horizontalCenter
            }
            spacing: dp(5)

            Image {
                id: pre
                source: "../../assets/mdpi/prefer.png"
                width: dp(10)
                fillMode:Image.PreserveAspectFit
            }

            Image {
                id: startBtn
                source: "../../assets/mdpi/start.png"
                width: dp(10)
                fillMode: Image.PreserveAspectFit
                property var istart: false
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        console.log("click the start..")
                        parent.source = parent.istart ? "../../assets/mdpi/start.png" : "../../assets/mdpi/stop.png"
                        parent.istart = !parent.istart
                    }
                }
            }

            Image {
                id: nextBtn
                source: "../../assets/mdpi/next.png"
                width: dp(9.5)
                fillMode: Image.PreserveAspectFit
            }
        }


        Row{
            id:r2
            width: sowRec.width * 0.6
            anchors{
                top: r1.bottom
                topMargin: dp(3)
                horizontalCenter: parent.horizontalCenter
            }
            spacing: dp(5)

            Image {
                id: falsebtn
                source: "../../assets/mdpi/false.png"
                width: dp(9.5)
                fillMode:Image.PreserveAspectFit
            }

            Image {
                id: anserBtn
                source: "../../assets/mdpi/noshowanswer.png"
                width: dp(10)
                fillMode: Image.PreserveAspectFit
                property var isshow: false
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        parent.source = parent.isshow ? "../../assets/mdpi/noshowanswer.png" : "../../assets/mdpi/showanser.png"
                        parent.isshow = !parent.isshow
                    }
                }
            }

            Image {
                id: rightBtn
                source: "../../assets/mdpi/right.png"
                width: dp(9.5)
                fillMode: Image.PreserveAspectFit
            }
        }

        //答案显示框
        Rectangle{
            id:answerRec
            visible: anserBtn.isshow
            width: parent.width * 0.8
            height: parent.height * 0.15
            color: "white"
            anchors{
                top: r2.bottom
                topMargin: dp(10)
                horizontalCenter: parent.horizontalCenter
            }
            Text {
                anchors.centerIn: parent
                width: parent.width
                text: "n.欢呼，赞扬，称赞； vt. 欢呼，喝彩，鼓掌欢迎；推选"
                font.pixelSize: dp(8)
                color: "red"
                wrapMode:Text.Wrap
            }
        }
    }
}
