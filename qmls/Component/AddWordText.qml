import QtQuick 2.0
import QtQuick.Controls 2.5
Rectangle{
    property alias leftText: leftarea.text
    property alias rightText: rightarea.text

    width: parent.width
    height: parent.height

    signal imporWord(var sno);

    //左边编辑框
    TextField{
        id:leftarea
        height: parent.height
        width: parent.width / 2
        text: ""
        font.pixelSize: dp(3)
        anchors.left: parent.left
        background: Rectangle{
            color: "transparent"
        }
    }

    Rectangle{
        id:mid
        color: "black"
        width: 1
        height: rightarea.height
        anchors.left: leftarea.right
    }

    //右边编辑框
    TextField{
        id:rightarea
        height: parent.height
        width: parent.width - leftarea.width
        text: ""
        font.pixelSize: dp(3)
        anchors.left: mid.right
        background: Rectangle{
            color: "transparent"
        }
    }

    onImporWord: {
        console.log("aaaaaaaa:",sno);
        if(leftText == "" && rightText == "") return;
        wordDB.importWord(sno,leftText,rightText);
    }
}
