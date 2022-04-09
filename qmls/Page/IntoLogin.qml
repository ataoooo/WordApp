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
                width: parent.width
                height: dp(7.5)
                icon: "../../assets/mdpi/ic_login_user.png"
                placeholderText: "请输入用户帐号"
                //只接受数字和字母
                validator: RegExpValidator{regExp: /^\w*$/}
                implicitHeight: height*1.5
            }

            InputEdit{
                id:userPhone
                width: parent.width
                height: dp(7.5)
                icon: "../../assets/mdpi/phone.png"
                placeholderText: "请输入注册手机"
                //只接受数字
                validator: RegExpValidator {regExp: /^[0-9]*$/}
                implicitHeight: height*1.5
            }
            InputEdit{
                id:userPsw
                width: parent.width
                height: dp(7.5)
                icon:"../../assets/mdpi/ic_login_psw.png"
                placeholderText: "请设置密码"
                validator: RegExpValidator{regExp: /^\w*$/}
                echoMode: TextInput.Password
                implicitHeight: height * 1.5
            }
            InputEdit{
                id:conFirmPsw
                width: parent.width
                height: dp(7.5)
                icon:"../../assets/mdpi/pwd.png"
                placeholderText: "请确认密码"
                validator: RegExpValidator{regExp: /^\w*$/}
                echoMode: TextInput.Password
                implicitHeight: height * 1.5
            }
        }
    }



}
