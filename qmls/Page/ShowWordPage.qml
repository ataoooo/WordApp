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

    //失败的图标显示
    Rectangle{
        id:failRec
        visible: root.wordTxt[0] == ""
        anchors.centerIn: parent
        width: parent.width
        color: "transparent"
        height: parent.height / 3
        Image {
            id: failIcon
            source: "../../assets/mdpi/searchFail.png"
            fillMode: Image.PreserveAspectFit;
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            text: "词典内暂未收录该单词.."
            color: "#707070"
            font.pixelSize: dp(5)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: failIcon.bottom
            anchors.topMargin: dp(3)
        }
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
        width: parent.width;


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

        //搜索框
        SearchEdit{
            id:search
            anchors{
                top: backico.bottom
                topMargin: dp(3)
                horizontalCenter: parent.horizontalCenter
            }
            width: parent.width * 0.95
            z:99
        }
        Column
        {
            visible: !failRec.visible
            width: parent.width
            anchors{
                top: search.bottom
                topMargin: dp(5)
                left: parent.left
                leftMargin: dp(3)
            }
            spacing: dp(5)
            //音标
            Rectangle{
                id:soundRec
                color: "transparent"
                width: root.wordTxt[2] != "" ? parent.width - dp(5) : ""
                height: dp(10)
                Text {
                    text: root.wordTxt[2]
                    font.pixelSize: dp(5)
                }
            }
            //中文翻译
            Rectangle{
                id:mainRec
                width: parent.width - dp(5)
                color: "transparent"
                height: mainTxt.height
                Text {
                    id:mainTxt
                    width: parent.width
                    text: root.wordTxt[3]
                    wrapMode: Text.Wrap
                    font.pixelSize: dp(5)
                }
            }
            //词根
            Rectangle{
                width: parent.width - dp(5)
                color: "transparent"
                height: (root.wordTxt[9] != "") ? dp(10) : 0
                Text {
                    visible: parent.height != 0
                    width: parent.width
                    text: "词根：  " + root.wordTxt[9]
                    wrapMode: Text.Wrap
                    font.pixelSize: dp(5)
                }
            }

            //各种词性转化
            Rectangle{
                width: parent.width - dp(5)
                color: "transparent"
                height: (splitString(root.wordTxt[7]) != "") ? txt.height : 0
                Text {
                    id:txt
                    visible: parent.height != 0
                    width: parent.width
                    text: splitString(root.wordTxt[7])
                    wrapMode: Text.Wrap
                    font.pixelSize: dp(5)
                }
            }

            Rectangle{
                width: parent.width - dp(5)
                color: "transparent"
                height: ((reciveSentence(root.wordTxt[1])) != "") ? txt2.height : 0
                Text {
                    id:txt2
                    width: parent.width
                    text: reciveSentence(root.wordTxt[1])
                    wrapMode: Text.Wrap
                    font.pixelSize: dp(5)
                }
            }
        }

        //收藏按钮
        Image {
            id:scIcon
            source: isCollect() ? "../../assets/mdpi/sc.png" : "../../assets/mdpi/nosc.png"
            visible: !failRec.visible
            height: dp(6)
            fillMode: Image.PreserveAspectFit
            property bool issc: isCollect() ? true : false
            anchors{
                bottom: parent.bottom
                bottomMargin: dp(8)
                left: parent.left
                leftMargin: dp(5)
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    console.log("click the sc")
                    scIcon.source = scIcon.issc ? "../../assets/mdpi/nosc.png" : "../../assets/mdpi/sc.png";
                    scIcon.issc = !scIcon.issc
                    if(!scIcon.issc){
                        wordDB.cancelCollect(root.userSno,root.wordTxt[1]);
                        root.showMsgHint("取消收藏")
                    }
                    else{
                        wordDB.collectWord(root.userSno,root.wordTxt[1],root.wordTxt[2],root.wordTxt[3],root.wordTxt[4],
                                           root.wordTxt[5],root.wordTxt[6],root.wordTxt[7],root.wordTxt[8])
                        root.showMsgHint("收藏成功")
                    }
                }
            }
        }

        //编辑按钮
        Rectangle{
            id:editBtn
            visible: !failRec.visible
            width: dp(76) * 0.37
            height: dp(10)
            radius: 5
            color: allColor
            anchors{
                bottom: parent.bottom
                bottomMargin: dp(5)
                right: parent.right
                rightMargin: dp(3)
            }

            Text {
                anchors.centerIn: parent
                text: qsTr("编辑单词")
                color: "white"
                font.pixelSize: parent.height * 0.5
            }
            MouseArea{
                anchors.fill: parent
                onClicked:{
                    root.pushStack(4);
                }
            }
        }
    }


    //获取例句
    function reciveSentence(str){
        console.log("The target word  is = ",str)
        var sen = wordDB.getSentence(str);
        if(sen == "" ) return "";
        console.log("aaaaaaaaaaaaaa\n",sen[0],'\n',sen[1],'\n',sen[2],'\n',sen[3])
        var showStr = "例句：\n";
        for(var i = 0 ; i < 4 ; i+=2)
        {
            showStr += sen[i];
            showStr += '\n';
            showStr += sen[i+1]
            showStr += '\n\n';

        }
        console.log("The sentence is = ",showStr)
        return showStr;
    }

    function isCollect(){
        return wordDB.isCollect(root.userSno,root.wordTxt[1]);
    }

}
