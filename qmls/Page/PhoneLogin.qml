import QtQuick 2.0
import QtGraphicalEffects 1.0
import "../Component"
//手机号登录界面
Rectangle{
    id:view
    anchors.fill: parent
    color: "transparent"
    Image {
        id: headimg
        source: "../../assets/mdpi/top_bg.png"
        width: parent.width
        fillMode: Image.PreserveAspectFit
        z:0
    }
    Image {
        id: exitimg
        source: "../../assets/mdpi/ic_arrow_back.png"
        height: dp(15) * 0.6
        anchors{
            left: parent.left
            leftMargin: dp(3)
        }
        fillMode: Image.PreserveAspectFit
        MouseArea{
            anchors.fill: parent
            onClicked: stack.pop()
        }
    }
    Rectangle{
        id:mainRec
        width: dp(82)
        height: width * 0.7
        radius: width * 0.1
        anchors{
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: dp(35.9)
        }
        layer.enabled: true
        layer.effect: DropShadow{
            radius: 10
            verticalOffset: 0.5
            color: "#999999"
            transparentBorder: true
        }
        z:1
        Column{
            id:col
            width: parent.width
            height: width
            anchors{
                top:parent.top
                topMargin: dp(9.2)
                horizontalCenter: parent.horizontalCenter
            }
            spacing: dp(5.56)
            InputEdit{
                id:phoneNum
                width: parent.width
                height: dp(8)
                icon: "../../assets/mdpi/phone.png"
                placeholderText: "请输入注册手机"
                validator: RegExpValidator {regExp: /^1[3-578]\d{9}$/}
                implicitHeight: height*1.5
            }
            InputEdit{
                id:pwdEdit
                width: parent.width
                height: dp(8)
                placeholderText: "请输入密码"
                icon:"../../assets/mdpi/ic_login_psw.png"
                echoMode: TextInput.Password
                implicitHeight: height * 1.5
            }
        }
        Rectangle{
            id:enterBtn
            width: col.width * 0.37
            height: dp(10)
            anchors{
                top:parent.top
                topMargin: dp(40)
                horizontalCenter: parent.horizontalCenter
            }
            radius: 5
            color: allColor
            Text {
                anchors.centerIn: parent
                text: "登录"
                color: "white"
                font.pixelSize: parent.height * 0.5
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    var res = checkenter()
                    if(res){
                        stack.pop()
                        root.enterMainView()
                        console.log("come here")
                    }
                    else
                        win.visible = true
                }
            }
        }
    }

    function checkenter()
    {
        if(phoneNum.text == "" || pwdEdit.text == "") return false
        var phon = phoneNum.text
        var pwd = pwdEdit.text
        var tmpmm = myDB.getMM(phon)
        console.log("The messahe is = ",phon," and ",pwd," and ",tmpmm)
        if(tmpmm != pwd) return false
        root.userPhone = phon
        root.userPwd = pwd
        root.userName = myDB.getUserID(phon)
        root.userSno = myDB.getUserSno(root.userName)
        root.tablename = "allWords" + root.userSno
        root.userType = myDB.findType(root.userName)
        return true
    }


    //错误提示框
    LittleWindow{
        id:win
        icon:"../../assets/mdpi/error.png"
        rectext: "手机号不存在或密码错误！"
        onBtnClicked: win.visible = false
    }
}
