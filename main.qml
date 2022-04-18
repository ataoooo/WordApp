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

    //
    property var searchTxt: ""
    property var wordTxt

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
            if(stack.depth > 1)
                stack.pop();
            else if(!_quit)
            {
                quitTimer.start();
                _quit = true;
                root.showMsgHint("再次点击返回键退出")
            }
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
        case 5:stack.push(accountInfoPage);break;
        case 6:stack.push(editPage);break;
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

}
