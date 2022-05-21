import QtQuick 2.0
import QtQuick.Controls 2.5
import "../Component"
Page{
    id:editwordPage
    anchors.fill: parent
    enabled: visible
    property bool isReplace: false
    Rectangle{
        anchors.fill: parent
        z: 0
        color: "#F6DAE3"
    }

    //保存按钮
    Rectangle{
        color: allColor
        width: parent.width / 4
        height: dp(8)
        anchors{
            right: parent.right
            rightMargin: dp(3)
            top:parent.top
            topMargin: dp(3)
        }
        Text {
            text: "保存"
            color: "white";
            font.pixelSize: dp(4);
            anchors.centerIn: parent
        }
        MouseArea{
            anchors.fill: parent
            onClicked:{
               var res = saveMessage()
               if(res)
               {
                   stack.pop();
                   root.haveEdit()
                   showMsgHint("编辑成功!")
               }
               else showMsgHint("编辑失败!")
            }
        }
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
                stack.pop();
            }
        }
    }//退出按钮

    Column
    {
        visible: !failRec.visible
        width: parent.width
        anchors{
            top: backico.bottom
            topMargin: dp(5)
            left: parent.left
            leftMargin: dp(3)
        }
        spacing: dp(5)

        //单词显示
        Rectangle{
            width: parent.width
            height: dp(10)
            color: "transparent"
            Text {
                text: root.searchTxt
                font.pixelSize: dp(8)
            }
        }
        //------------可编辑部分-------------
        //音标
        EditWord{
            id:soundRec
            leftTxt: "音 标:"
            rightTxt: root.wordTxt[2]
            width: parent.width - dp(5)
            height: dp(10)
        }

        EditInputWord{
            id:wmean
            width: parent.width - dp(5)
            height: dp(30)
            leftTxt: "中文释义:"
            rightTxt: root.wordTxt[3]
        }


        EditWord{
            id: gen
            width: parent.width - dp(5)
            height: dp(10)
            leftTxt: "词 根:"
            rightTxt: root.wordTxt[9]
        }

        EditInputWord{
            id:cxEdit
            width: parent.width - dp(5)
            height: dp(40)
            leftTxt: "词 性:"
            rightTxt: splitStr(root.wordTxt[7])
        }
    }

    function saveMessage(){
        var word = root.wordTxt[1];
        var accent = soundRec.contexts;
        console.log("test accent = ",accent);
        var mean = wmean.contexts;
        console.log("test mean = ",mean);
        var tenses = compareTenses()
        var origin = gen.contexts;
        var res = wordDB.saveWordToBook(root.tablename,word,accent,mean,tenses,origin);
        return res;
    }

    function splitStr(str){
        var showstr = "";
        if(str == ""){
            showstr += "第三人称形式: \n";
            showstr += "过去分词形式: \n";
            showstr += "复数形式: \n";
            showstr += "最高级形式: \n";
            showstr += "现在分词形式: \n";
            showstr += "过去式: \n";
            console.log("showstr = ",showstr);
            return showstr;
        }
        str = str.substring(1,str.length - 1);
        var slist = str.split(',');
        for(var i = 0 ; i < 7 ; ++ i){
            var tmplist = slist[i].split(':');
            switch(tmplist[0]){
            case '"word_third"':showstr += "第三人称形式: ";break;
            case ' "word_done"':showstr += "过去分词形式: ";break;
            case ' "word_pl"':showstr += "复数形式: ";break;
            case ' "word_est"':showstr += "最高级形式: ";break;
            case ' "word_ing"':showstr += "现在分词形式: ";break;
            case ' "word_er"':continue;
            case ' "word_past"':showstr += "过去式: ";break;
            }
            if(tmplist[1].length != 3)
                showstr += tmplist[1].substring(3,tmplist[1].length - 2);
            showstr += "\n";
        }
        return showstr;
    }

    //组织词性
    function compareTenses(){
        if( cxEdit.contexts == "") return "";
        var showstr = "{"
        var typelist = cxEdit.contexts.split('\n');
        var addx = false;
        for(var i = 0 ; i < 6 ; ++i)
        {
            console.log("aaaa: ",typelist[i]);
            var tmplist = typelist[i].split(":");
            switch(tmplist[0]){
            case '第三人称形式':showstr += '"word_third": ';break;
            case '过去分词形式':showstr += '"word_done": ';break;
            case '复数形式':showstr += '"word_pl": ';break;
            case '最高级形式':showstr += '"word_est": ';break;
            case '现在分词形式':showstr += '"word_ing": ';addx = true; break;
            case '过去式':showstr += '"word_past": ';break;
            }
            var tmpstr = tmplist[1].substring(1);
            showstr += (tmpstr != "" ?  '["' : '"');
            showstr += tmpstr;
            showstr += (tmpstr != "" ?  '"]' : '"');
            if(addx)
            {
                showstr += ', "word_er": ""';
            }

            if(i!=5)
                showstr += ', ';
        }
        showstr += '}';
        console.log("result is = ",showstr);
        return showstr;
    }

}
