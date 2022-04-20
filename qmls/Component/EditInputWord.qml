import QtQuick 2.0
import QtQuick 2.12
import QtQuick.Controls 2.5
Rectangle{
    property var leftTxt: ""
    property var rightTxt: ""
    property alias contexts: textedit_1.text
    color: "transparent"
    //左部文字
    Rectangle{
        id:leftRec
        height: dp(10)
        width: dp(20)
        anchors.left: parent.left
        color: "#eeeeee"
        Text {
            anchors.centerIn: parent
            text: leftTxt
            font.pixelSize: dp(4)
        }
    }


    ScrollView {
        id: textedit_1_view
        width: parent.width
        height: parent.height - leftRec.height
        background: Rectangle{
            border.color: textedit_1.activeFocus? allColor: "white"
            border.width: textedit_1.activeFocus? 2: 1
        }
        anchors{
            top: leftRec.bottom
        }

        clip: true
        ScrollBar.horizontal: ScrollBar{ visible: false }

        TextEdit{
            id: textedit_1
            width: textedit_1_view.width
            padding: 5
            color: "black"
            text: rightTxt
            selectByMouse: true
            selectedTextColor: "white"
            //选中文本背景色
            selectionColor: "black"
            font{
                pixelSize: dp(4)
            }
            renderType: Text.NativeRendering
            //文本换行，默认NoWrap
            wrapMode: TextEdit.Wrap
        }
    }

}

