import QtQuick 2.0
import QtQuick.Controls 2.5
//自定义弹窗
Item {
    id:littwin
    anchors.centerIn: parent
    property alias icon: img.source
    property alias rectext: tip.text
    property real btnNum: 1

    //按钮信号
    signal btnClicked(bool isClick)

    visible: false
    width: 220
    height: 160
    Dialog{
        id:dia
        visible: parent.visible
        width: parent.width
        height: parent.height
        modal: true
        closePolicy: Popup.NoAutoClose
        background: Rectangle{
            color: "white"//"#EBAEC2"
            anchors.fill: parent
            radius: 5
        }

        Image {
            id: img
            source: "../../assets/mdpi/error.png"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: dp(6)
            width: 40
            height: 40
            fillMode:Image.PreserveAspectFit
        }

        //文字显示
        TextField{
            id: tip
            readOnly:true
            background: Rectangle{
                color: "transparent"
            }
            width: parent.width - img.width
            anchors.left: img.right
            anchors.top: img.top
            font: {
                pixelSize:parent.height * 0.5
            }
            wrapMode: Text.WrapAnywhere
            text: "用户名不存在或密码错误！"
            color: "red"
        }

        //确定按钮
        Rectangle{
            id:oneokBtn
            visible: btnNum == 1
            width: tip.width * 0.5
            height: dp(6)
            radius: 5
            color: allColor
            anchors.bottom: parent.bottom
            anchors.bottomMargin: dp(2)
            anchors.left: parent.left
            anchors.leftMargin: (parent.width - okBtn.width) / 2
            Text {
                anchors.centerIn: parent
                text: qsTr("确定")
                color: "white"
                font.pixelSize: parent.height * 0.5
            }
            MouseArea{
                anchors.fill: parent
                onClicked:{
                    emit: btnClicked(true)
                }
            }
        }

        Row
        {
            visible: btnNum == 2
            anchors{
                bottom: parent.bottom
                left: parent.left
                leftMargin: dp(3)
            }
            spacing: dp(3)

            //确定按钮
            Rectangle{
                id:okBtn
                width: tip.width * 0.5
                height: dp(6)
                radius: 5
                color: allColor
                Text {
                    anchors.centerIn: parent
                    text: qsTr("确定")
                    color: "white"
                    font.pixelSize: parent.height * 0.5
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked:{
                        emit: btnClicked(true)
                    }
                }
            }

            //取消按钮
            Rectangle{
                id:cancelBtn
                width: tip.width * 0.5
                height: dp(6)
                radius: 5
                color: allColor
                Text {
                    anchors.centerIn: parent
                    text: qsTr("取消")
                    color: "white"
                    font.pixelSize: parent.height * 0.5
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked:{
                        emit: btnClicked(false)
                    }
                }
            }
        }
    }
}
