import QtQuick 2.0
import "../Component"
StackPageBase{
    id:page
    _title: ""
    property var titlename;
    property var targetModel;
    property var delvisible: false

    Connections{
        target: root
        onPageTile:{
            console.log("The title is = ",mtitle)
            page._title = mtitle
            switch(page._title){
            case "英语词汇":
                targetModel = wordDB.getAllWords("allWords" + (root.userSno == -1 ? "" : root.userSno.toString()));
                delvisible = false
                break;
            case "我的单词本":
                targetModel = wordDB.getAllWords("ImportTable" + root.userSno.toString());
                delvisible = true
                break;
            }
        }
    }

    Rectangle{
        id:headRec
        width: dp(100)
        height: dp(55)
        color: "white"
    }
    Image {
        id: bg
        anchors{
            top:parent.top
            topMargin: dp(1.5)
            horizontalCenter: parent.horizontalCenter
        }
        source: "../../assets/mdpi/bg_vip_top.png"
        width: dp(96)
        height: englishtxt.height + chinesetxt.height + dp(20)
        Column{
            id:co
            spacing: dp(8)
            width: bg.width
            anchors{
                top: parent.top
                topMargin: dp(5)
                horizontalCenter: parent.horizontalCenter
            }
            //英文显示
            Text {
                id: englishtxt
                font.pixelSize: dp(5)
                width: englishxx.contentWidth > parent.width ? parent.width : englishxx.contentWidth
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: Text.AlignHCenter
                wrapMode:Text.Wrap
                text: getTxt(0,targetModel[0])
            }

            //中文显示
            Text {
                id: chinesetxt
                font.pixelSize: dp(5)
                width: chinesexx.contentWidth > parent.width ? parent.width : chinesexx.contentWidth
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: Text.AlignHCenter
                wrapMode:Text.Wrap
                text: getTxt(1,targetModel[0])
            }
        }
    }
    //只为计算长度
    Text {
        id: englishxx
        visible: false
        font.pixelSize: dp(5)
        text: englishtxt.text
    }
    Text {
        id: chinesexx
        visible: false
        font.pixelSize: dp(5)
        text: chinesetxt.text
    }

    ListView{
        id:section;
        visible: true
        clip: true
        model: targetModel//wordDB.getAllWords("allWords")
        width: parent.width
        anchors{
            top: bg.bottom
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: dp(2)
            bottomMargin: dp(14)
        }
        spacing: dp(1)
        delegate: Rectangle{
            anchors.horizontalCenter: parent.horizontalCenter
            width: dp(92)
            radius: 5
            height: dp(16)
            color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1)
            //显示内容(只显示英文)
            Text {
                text: modelData
                elide:Text.ElideRight
                font.pixelSize: dp(5)
                width: parent.width
                height: parent.height
                wrapMode:Text.Wrap
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    englishtxt.text = getTxt(0,modelData)
                    englishxx.text = getTxt(0,modelData)
                    chinesetxt.text = getTxt(1,modelData)
                    chinesexx.text = getTxt(1,modelData)
                }
            }
            Image {
                id: delimg
                visible:delvisible
                source: "../../assets/mdpi/del.png"
                height: parent.height * 0.35
                fillMode: Image.PreserveAspectFit
                anchors{
                    right: parent.right
                    rightMargin: dp(1)
                    verticalCenter: parent.verticalCenter
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        wordDB.deleteWord(root.userSno,getTxt(0,modelData))
                        root.showMsgHint("删除成功")
                        targetModel = wordDB.getAllWords("ImportTable" + root.userSno.toString());
                    }
                }
            }
        }
    }

    function getTxt(sno,tartgettxt){
        var tmps = tartgettxt.split('\n')
        switch(sno){
        case 0: return tmps[0];
        case 1:return tmps[1];
        }
    }
}
