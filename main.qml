import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import "qmls/Page"
import "qmls/Component"

Window {
    id:root
    visible: true
    width: 468
    height: 832
    color: "white"
    property string allColor: "#DE739F";
    property bool _quit: false;
    property var userValue: ""
    property var userKey: ""
    //用户名
    property var userName: ""
    property var userPwd: ""
    property var userPhone: ""
    property var userType: ""
    property var userSno: ""
    property var tablename: ""

    //搜索
    property var searchTxt: ""
    property var wordTxt
    property var onlineChinese: ""

    //记忆策略下默写
    property var writeWord: []

    //信号
    signal pageTile(var mtitle);
    signal getModel();
    signal finishTest();
    signal haveEdit();

    StackView{
        id:stack
        anchors.fill: parent
        initialItem: page
        focus: true
    }
    Loader{
        id:page
        sourceComponent: mainPage
    }
    Connections{
        target: keyFilter
        onSig_KeyBackPress:{
            //若statck不在根节点就pop不标记接收到back信号
            if(stack.depth > 1)
                stack.pop();
            //第一次接收到back
            else if(!_quit)
            {
                //启动一个定时器，在定时器结束后没收再次收到的back信号就将back标记初始化
                quitTimer.start();
                _quit = true;
                root.showMsgHint("再次点击返回键退出")
            }
            //在一定时间没连续收到back信号
            else if(_quit)
            {
                Qt.quit();
                root.close();
            }
        }
    }
    Rectangle{
        id:mask
        opacity: 0.2
        color: "black"
        anchors.fill: parent
        visible: false
    }

    function pushStack(code){
        switch(code){
        case 1:stack.push(testPage); break;
        case 2:stack.push(adverPage); break;
        case 3:stack.push(showWordPage);break;
        case 4:stack.push(editWordPage);break;
        case 5:stack.push(accountInfoPage);break;
        case 6:stack.push(editPage);break;
        case 7:stack.push(shopView);break;
        case 8:stack.push(importWordPage);break;
        case 9:stack.push(wordBooks);break;
        case 10:stack.push(showDetailWord);break;
        case 11:stack.push(showSentence);break;
        case 12:stack.push(showCollectWord);break;
        case 13:stack.push(opinionsView);break;
        case 14:stack.push(aboutUs);break;
        case 15:stack.push(phoneLogin);break;
        }
    }

    Component {id:msghint; MessageChip{}}
    Component {id:mainPage; IntoPage{}}
    Component {id:logPage; IntoLogin{}}
    Component {id:enterPage; EnterPage{}}
    Component {id:accountInfoPage; AccountInfoPage{}}
    Component {id:editPage; EditPage{}}
    Component {id:adverPage; AdverPage{}}
    Component {id:showWordPage; ShowWordPage{}}
    Component {id:editWordPage; EditWordPage{}}
    Component {id:shopView; ShopView{}}
    Component {id:importWordPage; ImportWordPage{}}
    Component {id:wordBooks; WordBooks{}}
    Component {id:showDetailWord; ShowDetailWord{}}
    Component {id:showSentence; ShowSentence{}}
    Component {id:showCollectWord; ShowCollectWord{}}
    Component {id:opinionsView; OpinionsView{}}
    Component {id:aboutUs; AboutUs{}}
    Component {id:phoneLogin; PhoneLogin{}}

    Timer{
        id:quitTimer
        interval: 2000
        onTriggered: _quit = false
    }

    function dp(value){
        return value * root.width / 100
    }

    function login(){
        page.sourceComponent = navPage;
        showMsgHint("欢迎回来");
    }

    function logout(){
        console.log("start to here!!!")
        page.sourceComponent = mainPage;
        showMsgHint("您已登出！")
    }

    //去往登陆后的页面
    function enterMainView()
    {
        page.sourceComponent = enterPage
    }

    //回到登录页面
    function enterLogin(){
        page.sourceComponent = mainPage;
        showMsgHint("欢迎登录！")
    }

    function showMsgHint(msg){
        var msgHint = msghint.createObject(root,{});
        msgHint.text = msg;
    }

    function showMask(){
        mask.visible = true
    }

    function closeMask(){
        mask.visible = false
    }

    //去往注册页面
    function loginView(){
        page.sourceComponent = logPage
    }

    function splitString(str){
        if(str == "") return str;
        str = str.substring(1,str.length - 1);
        var slist = str.split(',');
        var showstr = ""
        for(var i = 0 ; i < 7 ; ++ i){
            var tmplist = slist[i].split(':');
            if(tmplist[1].length == 3) continue;
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
