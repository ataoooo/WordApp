import QtQuick 2.0

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

}
