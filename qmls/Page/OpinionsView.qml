import QtQuick 2.0
import QtQuick.Controls 2.5
import "../Component"
StackPageBase {
    _title: "意见反馈"
    ScrollView {
        id: view
        width: parent.width
        height: parent.height * 0.4
        clip: true
        TextArea {
            id:textarea
            background: Rectangle{
                color: "#fae4e7"
            }
            wrapMode: TextArea.Wrap
            width: parent.width
            height: parent.height * 0.4
            placeholderText: "请输入内容"
            font.pixelSize: dp(5)
        }
    }

    Rectangle{
        id:setRec
        width: parent.width / 4
        height: dp(10)
        color: allColor
        radius: dp(3)
        anchors{
            top:view.bottom
            topMargin: dp(10)
            horizontalCenter: parent.horizontalCenter
        }
        Text {
            anchors.centerIn: parent
            text: "提交"
            color: "white"
            font.pixelSize: dp(4)
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                if( textarea.text == "" )
                {
                    root.showMsgHint("请输入内容")
                    return
                }
                textarea.text = ""
                root.showMsgHint("提交成功")
            }
        }
    }

    onVisibleChanged: {
        if(visible){
            textarea.text = ""
        }
    }
}
