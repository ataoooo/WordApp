import QtQuick 2.0
import QtQuick.Controls 2.5
import "../Component"

Page {
    id: page3
    anchors.fill: parent
    enabled: visible
    property bool isReplace: false
    Rectangle{
        anchors.fill: parent
        z: 0
        color: "#F6DAE3"
    }

    Image {
        id:backico
        source: "../../assets/mdpi/ic_arrow_back.png";
        width: dp(8)
        anchors{
            left: parent.left;
            leftMargin: dp(1);
            top:parent.top
            topMargin: dp(3)
        }
        fillMode: Image.PreserveAspectFit;
        MouseArea {
            anchors.fill: parent;
            onClicked:{
                root.searchTxt = "";
                stack.pop();
            }
        }
    }//退出按钮

    //导入按钮
    Rectangle{
        anchors{
            right: parent.right
            rightMargin: dp(3)
            verticalCenter: backico.verticalCenter
        }
        radius: dp(5)
        width: dp(16)
        color: allColor
        height: dp(8)
        Text {
            text: "一键导入"
            anchors.centerIn: parent
            color: "white"
        }
        MouseArea{
            anchors.fill:parent
            onClicked: {
                emitFun()
                root.showMsgHint("导入成功")
            }
        }
    }

    ///整体作一个可滑动页面
    Flickable {
        id: inner
        clip: true
        anchors{
            top: backico.bottom
            topMargin: dp(3)
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
        }
        flickableDirection: Flickable.VerticalFlick; //只允许垂直滑动
        width: parent.width;

        contentWidth: dp(100);
        contentHeight: dp(200)
        contentX: dp(0);




        Rectangle{
            id:rec
            width: parent.width * 0.9
            height: dp(5)
            anchors{
                top:backico.bottom
                topMargin: dp(3)
                horizontalCenter: parent.horizontalCenter
            }
            Rectangle{
                id:rec1
                height: parent.height
                width: parent.width / 2
                anchors.left: parent.left
                border.color: "black" //设置边框的颜色
                border.width: 2       //设置边框的大小
                Text {
                    anchors.centerIn: parent
                    text: "单词拼写"
                }
            }
            Rectangle{
                height: parent.height
                width: parent.width / 2
                anchors.left: rec1.right
                border.color: "black" //设置边框的颜色
                border.width: 2       //设置边框的大小
                Text {
                    anchors.centerIn: parent
                    text: "中文释义"
                }
            }
        }
        AddWordText{
            id:t1
            width: parent.width * 0.9
            height: dp(8)
            anchors{
                top:rec.bottom
                horizontalCenter: parent.horizontalCenter
            }
        }
        AddWordText{
            id:t2
            width: parent.width * 0.9
            height: dp(8)
            anchors{
                top:t1.bottom
                topMargin: dp(1)
                horizontalCenter: parent.horizontalCenter
            }
        }
        AddWordText{
            id:t3
            width: parent.width * 0.9
            height: dp(8)
            anchors{
                top:t2.bottom
                topMargin: dp(1)
                horizontalCenter: parent.horizontalCenter
            }
        }
        AddWordText{
            id:t4
            width: parent.width * 0.9
            height: dp(8)
            anchors{
                top:t3.bottom
                topMargin: dp(1)
                horizontalCenter: parent.horizontalCenter
            }
        }
        AddWordText{
            id:t5
            width: parent.width * 0.9
            height: dp(8)
            anchors{
                top:t4.bottom
                topMargin: dp(1)
                horizontalCenter: parent.horizontalCenter
            }
        }
        AddWordText{
            id:t6
            width: parent.width * 0.9
            height: dp(8)
            anchors{
                top:t5.bottom
                topMargin: dp(1)
                horizontalCenter: parent.horizontalCenter
            }
        }
        AddWordText{
            id:t7
            width: parent.width * 0.9
            height: dp(8)
            anchors{
                top:t6.bottom
                topMargin: dp(1)
                horizontalCenter: parent.horizontalCenter
            }
        }
        AddWordText{
            id:t8
            width: parent.width * 0.9
            height: dp(8)
            anchors{
                top:t7.bottom
                topMargin: dp(1)
                horizontalCenter: parent.horizontalCenter
            }
        }
        AddWordText{
            id:t9
            width: parent.width * 0.9
            height: dp(8)
            anchors{
                top:t8.bottom
                topMargin: dp(1)
                horizontalCenter: parent.horizontalCenter
            }
        }
        AddWordText{
            id:t10
            width: parent.width * 0.9
            height: dp(8)
            anchors{
                top:t9.bottom
                topMargin: dp(1)
                horizontalCenter: parent.horizontalCenter
            }
        }

        AddWordText{
            id:t11
            width: parent.width * 0.9
            height: dp(8)
            anchors{
                top:t10.bottom
                topMargin: dp(1)
                horizontalCenter: parent.horizontalCenter
            }
        }
        AddWordText{
            id:t12
            width: parent.width * 0.9
            height: dp(8)
            anchors{
                top:t11.bottom
                topMargin: dp(1)
                horizontalCenter: parent.horizontalCenter
            }
        }
        AddWordText{
            id:t13
            width: parent.width * 0.9
            height: dp(8)
            anchors{
                top:t12.bottom
                topMargin: dp(1)
                horizontalCenter: parent.horizontalCenter
            }
        }
        AddWordText{
            id:t14
            width: parent.width * 0.9
            height: dp(8)
            anchors{
                top:t13.bottom
                topMargin: dp(1)
                horizontalCenter: parent.horizontalCenter
            }
        }
        AddWordText{
            id:t15
            width: parent.width * 0.9
            height: dp(8)
            anchors{
                top:t14.bottom
                topMargin: dp(1)
                horizontalCenter: parent.horizontalCenter
            }
        }
        AddWordText{
            id:t16
            width: parent.width * 0.9
            height: dp(8)
            anchors{
                top:t15.bottom
                topMargin: dp(1)
                horizontalCenter: parent.horizontalCenter
            }
        }
        AddWordText{
            id:t17
            width: parent.width * 0.9
            height: dp(8)
            anchors{
                top:t16.bottom
                topMargin: dp(1)
                horizontalCenter: parent.horizontalCenter
            }
        }
        AddWordText{
            id:t18
            width: parent.width * 0.9
            height: dp(8)
            anchors{
                top:t17.bottom
                topMargin: dp(1)
                horizontalCenter: parent.horizontalCenter
            }
        }
        AddWordText{
            id:t19
            width: parent.width * 0.9
            height: dp(8)
            anchors{
                top:t18.bottom
                topMargin: dp(1)
                horizontalCenter: parent.horizontalCenter
            }
        }
        AddWordText{
            id:t20
            width: parent.width * 0.9
            height: dp(8)
            anchors{
                top:t19.bottom
                topMargin: dp(1)
                horizontalCenter: parent.horizontalCenter
            }
        }
    }

    function emitFun(){
        t1.imporWord(root.userSno);
        t2.imporWord(root.userSno);
        t3.imporWord(root.userSno);
        t4.imporWord(root.userSno);
        t5.imporWord(root.userSno);
        t6.imporWord(root.userSno);
        t7.imporWord(root.userSno);
        t8.imporWord(root.userSno);
        t9.imporWord(root.userSno);
        t10.imporWord(root.userSno);
        t11.imporWord(root.userSno);
        t12.imporWord(root.userSno);
        t13.imporWord(root.userSno);
        t14.imporWord(root.userSno);
        t15.imporWord(root.userSno);
        t16.imporWord(root.userSno);
        t17.imporWord(root.userSno);
        t18.imporWord(root.userSno);
        t19.imporWord(root.userSno);
        t20.imporWord(root.userSno);
    }
}
