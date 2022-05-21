import QtQuick 2.12
import QtQuick.Controls 2.12
import "../Component"

Page {
    property bool showCom: root.userKey == "我的身份"
    header: Rectangle{
        color: allColor;
        width: parent.width;
        height: dp(15);
        Text {
            id: _title;
            width: parent.width / 2
            anchors.left: popIco.right
            anchors.leftMargin: dp(3)
            anchors.verticalCenter: parent.verticalCenter
            text: root.userKey
            color: "white"
            font.pixelSize: dp(4)
        }
        Rectangle{
            color: "transparent"
            width: parent.width / 4
            height: parent.height
            anchors{
                right: parent.right
            }
            Text {
                id: saveTxt;
                anchors.centerIn: parent
                text: "保存";
                color: "white";
                font.pixelSize: dp(4);
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if(rightEdit.text == "")
                    {
                        winError.rectext = "请输入修改内容!"
                        winError.visible = true;
                        return
                    }
                    var txtType = root.userKey.substring(2,4);
                    var res = true;
                    switch(txtType){
                    case "密码":
                        if(root.userPwd == rightEdit.text)
                        {
                            stack.pop();
                            return;
                        }
                        res = myDB.upGradePwd(root.userName,rightEdit.text);
                        if(res)
                        {
                            root.userPwd = rightEdit.text;
                            successUpGrade();
                        }
                        else
                            winError.visible = true;
                        break;
                    case "电话":
                        if(root.userPhone == rightEdit.text)
                        {
                            stack.pop();
                            return;
                        }
                        if(rightEdit.text.length != 11)
                        {
                            rightEdit.text = root.userPhone
                            winError.rectext = "请输入正确手机号"
                            winError.visible = true;
                            break
                        }
                        res = myDB.upGradePhone(root.userName,rightEdit.text);
                        if(res)
                        {
                            root.userPhone = rightEdit.text;
                            successUpGrade();
                        }
                        else
                        {
                            winError.rectext = "修改失败！手机号已注册！"
                            winError.visible = true;
                        }
                        break;
                    case "身份":
                        if(root.userType == combb.displayText)
                        {
                            stack.pop();
                            return;
                        }
                        res = myDB.upGradeType(root.userName,combb.currentText);
                        if(res)
                        {
                            root.userType = combb.currentText;
                            successUpGrade();
                        }
                        else
                            winError.visible = true;
                        break;
                    case "名称":
                        if(root.userName == rightEdit.text)
                        {
                            stack.pop();
                            return;
                        }
                        res = myDB.upGradeName(root.userName,rightEdit.text);
                        if(res)
                        {
                            root.userName = rightEdit.text;
                            successUpGrade();
                        }
                        else{
                            winError.rectext = "修改失败！用户名已存在！"
                            winError.visible = true;
                        }
                        break;
                    }
                }
            }
        }

        Image {
            id: popIco;
            source: "../../assets/mdpi/ic_arrow_back.png";
            height: parent.height * 0.6;
            anchors{
                left: parent.left;
                leftMargin: dp(3);
                verticalCenter: parent.verticalCenter;
            }
            fillMode: Image.PreserveAspectFit;
            MouseArea {
                anchors.fill: parent;
                onClicked: stack.pop();
            }
        }//退出按钮

    }
    Rectangle {
        anchors.fill: parent;
        color: "#E8E7E7";
    }

    //中间间距（工具矩形）
    Rectangle{
        id:tmpRec
        width: parent.width
        height: dp(3)
        color: "transparent"
    }

    //编辑框
    Rectangle{
        id:editRec
        anchors{
            top:tmpRec.bottom
        }

        width: parent.width
        height: dp(12)

        //左端的文字
        Rectangle{
            id:leftTextRec
            height: parent.height
            color: "transparent"
            width: dp(20)
            Text {
                anchors.centerIn: parent
                text: root.userKey
                color: "black"
                font.pixelSize: dp(4)
            }
        }
        //右端可编辑部分
        Rectangle{
            color: "transparent"
            height: parent.height
            width: parent.width - dp(30)
            anchors{
                left: leftTextRec.right
                leftMargin: dp(10)
            }
            //下拉框类型
            MyComboBox{
                id:combb
                visible: showCom
                height: parent.height
                clickColor:"white"
                mainColor:"white"
                displayText: root.userType
            }
            //普通编辑框
            TextField{
                id:rightEdit
                visible: !showCom
                validator: RegExpValidator{regExp: setRegExp()}
                anchors.fill: parent
                text: root.userValue
                font.pixelSize: dp(4);
                background: Rectangle{
                    anchors.fill: parent
                    color: "transparent"
                }
            }
        }
    }

    LittleWindow{
        id:winError
        visible: false
        icon:"../../assets/mdpi/error.png"
        rectext: "修改失败！"
        onBtnClicked: winError.visible = false
    }

    function successUpGrade(){
        stack.pop();
        showMsgHint("修改成功！")
    }

    function setRegExp(){
        var str =  root.userKey.substring(2,4)
        switch(str){
        case "名称": return /^\w{20}$/;
        case "电话": return /^1[3-578]\d{9}$/;
        case "密码": return /^\w{30}$/;
        }
    }

}
