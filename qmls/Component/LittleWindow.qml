import QtQuick 2.0
import QtQuick.Controls 2.5
//自定义弹窗
Item {
    id:littwin
    anchors.centerIn: parent
    property alias icon: img.source
    property alias rectext: tip.text
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
            color: "#EBAEC2"
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
            height: dp(13)
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
            id:okBtn
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
                    littwin.visible = false
                    }
            }
        }


    }
}
