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
        color: "white"
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
                width: parent.width - dp(5)
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
                height: (splitString(root.wordTxt[7]) != "") ? dp(10) : 0
                Text {
                    visible: parent.height != 0
                    width: parent.width
                    text: splitString(root.wordTxt[7])
                    wrapMode: Text.Wrap
                    font.pixelSize: dp(5)
                }
            }

        }


    }


    function splitString(str){
        if(str == "") return str;
        str = str.substring(1,str.length - 1);
        var slist = str.split(',');
        var showstr = ""
        for(var i = 0 ; i < 7 ; ++ i){
            var tmplist = slist[i].split(':');
            if(tmplist[1].length == 3) continue;
            console.log("test == ",tmplist[0],tmplist[0].length)
            switch(tmplist[0]){
            case '"word_third"':showstr += "第三人称形式: ";break;
            case ' "word_done"':showstr += "过去分词形式: ";break;
            case ' "word_pl"':showstr += "复数形式: ";break;
            case ' "word_est"':showstr += "最高级形式: ";break;
            case ' "word_ing"':showstr += "现在分词形式: ";break;
            case ' "word_er"':continue;
            case ' "word_past"':showstr += "过去式: ";break;
            }
            showstr += tmplist[1].substring(3,tmplist[1].length - 2);
            showstr += "\n";
        }
        return showstr;
    }

}
