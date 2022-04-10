import QtQuick 2.12
import QtQuick.Controls 2.12
Rectangle{
    id:editLine
    color: "transparent"
    property alias icon: editIcon.source;
    property alias text: editField.text;
    property alias validator: editField.validator;
    property alias placeholderText: editField.placeholderText;
    property alias echoMode: editField.echoMode;
    property bool isPsw: placeholderText === "请输入密码"; //判断是否为密码输入框
    property bool isMust:false  //是否必填

    property var cleanText: false

    //最左侧图标
    Image {
        id: editIcon
        source: ""
        anchors{
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: dp(5)
        }
        height: parent.height
        width: height
        //锁定比例
        fillMode: Image.PreserveAspectFit
    }
    //中间的编辑框
    TextField{
        id:editField
        clip: false
        anchors{
            verticalCenter: parent.verticalCenter
            left: editIcon.right
            leftMargin: dp(5)
            right: mustWrite.left
        }
        width: parent.width - editIcon.width
        height: parent.height
        implicitWidth: width - showPsw.width- mustWrite.width
        font:{
            pixelSize: (isPsw && text !== "" && !showPsw.showpsw)? parent.height * 0.2: parent.height * 0.6;

        }
        background: Rectangle{
            color: "transparent"
        }
        color: allColor
    }
    //必填图标
    Image {
        id: mustWrite
        source: isMust ? "../../assets/mdpi/must.png" : ""
        width: isMust ? parent.height : 0
        height: width
        fillMode: Image.PreserveAspectFit
        anchors{
            right: parent.right
            rightMargin: dp(5)
            verticalCenter: parent.verticalCenter
        }
    }
    //下划线
    Rectangle{
        id:underLine
        height: 1
        color: "grey"
        anchors{
            top: editField.bottom
            left: editIcon.right
            leftMargin: dp(5)
            right: editLine.right
            rightMargin: dp(5)
        }
    }
    //密码图标
    Image {
        id: showPsw
        scale: 0.75
        property bool showpsw: false
        anchors{
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: dp(5)
        }
        source: isPsw ? "../../assets/mdpi/ic_eye_off1.png":""
        MouseArea{
            anchors.fill: parent

            onClicked: {
                if(!parent.showpsw){
                    parent.showpsw = !parent.showpsw
                    parent.source = "../../assets/mdpi/ic_eye_on.png"
                    echoMode = TextInput.Normal
                }
                else{
                    parent.showpsw = !parent.showpsw
                    parent.source = "../../assets/mdpi/ic_eye_off1.png"
                    echoMode = TextInput.Password
                }
            }
        }
    }
    function recieveText(){
        return editField.text;
    }

    onCleanTextChanged: {
        if(cleanText)
            editField.text = ""
    }
}
