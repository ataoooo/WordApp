import QtQuick 2.0
import QtQuick.Controls 2.5
import "../Component"
StackPageBase {
    id:page
    _title:"例句"
    property var targetModel;

    Connections{
        target: root
        onGetModel:{
            targetModel = wordDB.getAllSentence();
        }
    }

    //搜索框
    Rectangle{
        id:searchBar
        width: dp(95)
        height: dp(8)
        color: "white"
        anchors{
            horizontalCenter: parent.horizontalCenter
            top:parent.top
            topMargin: dp(2)
        }
        radius: 6
        Image {
            id: s_ico
            source: "../../assets/mdpi/icon_search1.png"
            anchors{
                left: parent.left
                leftMargin: dp(2)
                verticalCenter: parent.verticalCenter
            }
            height: parent.height * 0.5
            width: height
        }
        //右侧搜索按钮
        Rectangle{
            id:searchRec
            color: allColor
            radius: 5
            anchors{
                right: parent.right
                rightMargin: dp(1)
                verticalCenter: parent.verticalCenter
            }
            height: parent.height * 0.8
            width: height * 2
            Text {
                text: qsTr("搜索")
                anchors.centerIn: parent
                color: "white"
            }
            MouseArea{
                anchors.fill: parent
                onClicked: searchsen(stxt.text)
            }
        }

        TextField{
            id:stxt
            anchors{
                left: s_ico.right
                leftMargin: dp(1)
                right: searchRec.left
                rightMargin: dp(1)
                verticalCenter: parent.verticalCenter
            }
            height: dp(7)
            font.pixelSize: dp(3)
            background: Rectangle{
                color: "transparent"
            }
            placeholderText: "请输入查询的单词"
            implicitWidth: width
            implicitHeight: height * 1.5
        }
    }

    Image {
        id: bg
        anchors{
            top:searchBar.bottom
            topMargin: dp(1.5)
            horizontalCenter: parent.horizontalCenter
        }
        source: "../../assets/mdpi/bg_vip_top.png"
        width: dp(96)
        fillMode: Image.PreserveAspectFit
        Column{
            id:co
            spacing: dp(2)
            width: bg.width
            anchors{
                top: parent.top
                topMargin: dp(3)
                horizontalCenter: parent.horizontalCenter
            }
            //英语句子1
            Text {
                id: eng1
                width: parent.width
                wrapMode: Text.Wrap
                text: getTxt(1,targetModel[0])//qsTr("text1")

            }
            Text {
                id: ch1
                width: parent.width
                wrapMode: Text.Wrap
                text: getTxt(2,targetModel[0])//qsTr("text2")
            }
            //英语句子1
            Text {
                id: eng2
                width: parent.width
                wrapMode: Text.Wrap
                text: getTxt(3,targetModel[0])//qsTr("text3")
            }
            Text {
                id: ch2
                width: parent.width
                wrapMode: Text.Wrap
                text: getTxt(4,targetModel[0])//qsTr("text4")
            }
        }
    }
    ListView{
        id:section
        visible: true
        clip: true
        model: targetModel
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
            height: dp(12)
            color: "#F9CCCC"
            Text {
                id: name
                anchors.centerIn: parent
                text: getTxt(0,modelData)
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    eng1.text = getTxt(1,modelData)
                    ch1.text = getTxt(2,modelData)
                    eng2.text = getTxt(3,modelData)
                    ch2.text = getTxt(4,modelData)
                }
            }
        }
    }

    function searchsen(word){
        var i = 0;
        while(targetModel[i] != undefined){
            if(word == getTxt(0,targetModel[i])){
                eng1.text = getTxt(1,targetModel[i])
                ch1.text = getTxt(2,targetModel[i])
                eng2.text = getTxt(3,targetModel[i])
                ch2.text = getTxt(4,targetModel[i])
                return;
            }
            ++i;
        }
        eng1.text = "暂无该单词对应例句"
        ch1.text = ""
        eng2.text = ""
        ch2.text = ""
    }

    function getTxt(sno,str){
        if(targetModel[1111111111111] == undefined)
            console.log("aaaaaaaaaaaaaaa1111")
        var tmps = str.split('&')
        return tmps[sno]
    }

}
