import QtQuick 2.0
import QtGraphicalEffects 1.0
import "../Component"
//注册窗口
//用户id 密码 电话 类别 确认密码

Rectangle{
    id:logRec
    anchors.fill: parent
    color: "transparent"
    Image {
        id: loginHead
        source: "../../assets/mdpi/top_bg.png"
        width: parent.width
        fillMode: Image.PreserveAspectFit
        z:0
    }
    //退出按钮
    Image {
        id: popIco
        source: "../../assets/mdpi/ic_arrow_back.png"
        height: dp(15) * 0.6;
        anchors{
            left: parent.left
            leftMargin: dp(3)
        }
        fillMode: Image.PreserveAspectFit
        MouseArea {
            anchors.fill: parent
            onClicked: root.enterLogin()
        }
    }
    Rectangle{
        id:messRec
        width: dp(82)
        height: width * 1.2
        radius: width * 0.1
        anchors{
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: dp(35.9)
        }
        layer.enabled: true
        layer.effect: DropShadow{
            radius: 10
            samples: 19
            verticalOffset: 0.5
            color: "#999999"
            transparentBorder: true
        }
        z:1

        //布局开始
        //下拉框
        Row{
            id:mrow
            anchors{
                top: parent.top
                topMargin: dp(9.2)
                left: parent.left
                leftMargin: dp(5)
            }
            spacing: dp(5)
            //左侧图标
            Image {
                source: "../../assets/mdpi/useType.png"
                width: 40
                height: 40
                fillMode: Image.PreserveAspectFit
            }
            MyComboBox{
                id:comb
            }
        }

        Column{
            id:col
            width: parent.width
            anchors{
                top: mrow.bottom
                topMargin: dp(5)
                horizontalCenter: parent.horizontalCenter
            }
            spacing: dp(5.56)

            //各种输入框
            InputEdit{
                id:userId
                isMust:true
                width: parent.width
                height: dp(8)
                icon: "../../assets/mdpi/ic_login_user.png"
                placeholderText: "请输入用户帐号（必填）"
                //只接受数字和字母
                validator: RegExpValidator{regExp: /^\w{20}$/}
                implicitHeight: height*1.5
            }

            InputEdit{
                id:userPhone
                isMust:true
                width: parent.width
                height: dp(8)
                icon: "../../assets/mdpi/phone.png"
                placeholderText: "请输入注册手机（必填）"
                //只接受固定数字排布且长度限制为11
                validator: RegExpValidator {regExp: /^1[3-578]\d{9}$/}
                implicitHeight: height*1.5
            }
            InputEdit{
                id:userPsw
                isMust:true
                width: parent.width
                height: dp(8)
                icon:"../../assets/mdpi/ic_login_psw.png"
                placeholderText: "请设置密码（必填）"
                validator: RegExpValidator{regExp: /^\w{30}$/}
                echoMode: TextInput.Password
                implicitHeight: height * 1.5
            }
            InputEdit{
                id:conFirmPsw
                isMust:true
                width: parent.width
                height: dp(8)
                icon:"../../assets/mdpi/pwd.png"
                placeholderText: "请确认密码（必填）"
                validator: RegExpValidator{regExp: /^\w*$/}
                echoMode: TextInput.Password
                implicitHeight: height * 1.5
            }
        }
        //注册按钮
        Rectangle{
            id:logBtn
            width: col.width * 0.37
            height: dp(10)
            radius: 5
            color: allColor
            anchors{
                top: col.bottom
                topMargin: dp(8)
                left: parent.left
                leftMargin: col.width * 0.63 / 2
            }

            Text {
                anchors.centerIn: parent
                text: qsTr("注册")
                color: "white"
                font.pixelSize: parent.height * 0.5
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    logResult()
                }
            }
        }
    }


    function logResult(){
        //获取得到所有内容
        var utype = comb.currentText;
        var uID = userId.text
        var uphone = userPhone.text
        var uPwd = userPsw.text
        var umm = conFirmPsw.text
        console.log("insert message is ",utype)
        console.log(uID)
        console.log(uphone)
        console.log(uPwd)
        console.log(umm)

        //有一项必填项为空
        if(utype == "" || uID == "" || uphone == "" || uPwd == "")
        {
            console.log("have empty!")
            root.showMsgHint("请完善上述必填的选项")
            return
        }
        //号码不规范
        if( uphone.length < 11 )
        {
            root.showMsgHint("请输入有效手机号")
            userPhone.cleanText = true
            return
        }
        //两次密码不一致
        if( uPwd != umm )
        {
            root.showMsgHint("密码核对错误！请重新输入")
            conFirmPsw.cleanText = true
            return
        }
        //号码被注册
        var phRes = myDB.findPhone(uphone)
        console.log("The res = " , phRes)
        if( !phRes)
        {
            root.showMsgHint("手机号已被注册!请选取其他手机号注册！")
            userPhone.cleanText = true
            return
        }
        //插入记录
        var insRes = myDB.insertRecord(uphone,utype,uID,uPwd)
        if(!insRes) //插入失败
        {
            tipwin.visible = true;
            return
        }
        else
        {
            console.log("login success")
            //建立一张新的单词数据表
            wordDB.createAllWordTable(myDB.getUserSno(uID));
            //插入记忆策略
            wordDB.insertToRemember(myDB.getUserSno(uID));
            root.enterLogin()
        }
    }

    LittleWindow{
        id:tipwin
        btnNum: 1
        icon:"../../assets/mdpi/error.png"
        rectext: "注册失败！该用户名已存在！ "
        onBtnClicked: {
            console.log("The result is = ",isClick)
            tipwin.visible = false
        }
    }
}
