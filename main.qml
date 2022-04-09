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
        }
    }


//    Component {id:msghint; MessageChip{}}

    Component {id:mainPage; IntoPage{}}
    Component {id:logPage; IntoLogin{}}

    Timer{
        id:quitTimer
        interval: 2000
        onTriggered: _quit = false
    }

    function dp(value){
        return value * root.width / 100
    }

    function login(){
        //page.sourceComponent = navPage;
        showMsgHint("欢迎回来");
    }

    function logout(){
        page.sourceComponent = mainPage;
        showMsgHint("您已登出！")
    }

    function showMsgHint(msg){
        var msgHint = msgHint.createObject(root,{});
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
