import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick 2.12
import "../Component"
Page{
    id:page
    anchors.fill: parent
    opacity: 0
    visible: opacity > 0
    enabled: visible
    Rectangle{
        anchors.fill: parent
        color: "#eeeeee"
    }
    PageHeader{
        id:header
        text: root.userName
    }
    //顶部流动图片展示
    Rectangle{
        id:viewRect
        anchors.top: header.bottom
        width: parent.width
        height: dp(24)
        color: "transparent"
        SwipeView{
            id:view
            anchors.fill: parent
            Repeater{
                model: ["lightblue", "lightgreen", "lightyellow", "#eeeeee"]
                delegate: Rectangle{
                    width: view.width
                    height: view.height
                    color: modelData
                    Text {
                        id: reText
                        anchors.centerIn: parent
                        text: "I m a g e " + (index + 1)
                    }
                }
            }
            //滚动定时器
            Timer{
                id:swpTimer
                interval: 3000
                repeat: true
                running: true
                onTriggered: {
                    view.currentIndex = view.currentIndex + 1
                    view.currentIndex = view.currentIndex % 4
                }
            }
        }
        PageIndicator{
            id:indicator
            count: view.count
            currentIndex: view.currentIndex
            anchors.bottom: view.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
    //列表布局
    Column{
        anchors{
            horizontalCenter: parent.horizontalCenter
            top: viewRect.bottom
            topMargin: dp(2)
        }
        Repeater{
            id:listItems
            model:  [["../../assets/mdpi/ic_xgmm.png", "修改信息", 1, dp(10)],
                ["../../assets/mdpi/ic_yjfk.png", "意见反馈", 1, dp(10)],
                ["../../assets/mdpi/ic_about_us.png", " 关于我们", 4, dp(10)],
                ["../../assets/mdpi/icon_swich.png", "退出登录", 0, dp(10)]
            ];
            delegate: ListItem{
                icon: modelData[0]
                text: modelData[1]
                space: modelData[2]
                height: modelData[3]
                onClicked: {
                    switch(index){
                    case 0: //需要确认密码
                        maskRec.visible = true
                        confirmRec.visible = true
                        break
                    case 1:root.pushStack(13);break;
                    case 2:root.pushStack(14);break;
                    case 3 :root.logout();break;
                    }
                }
            }
        }
    }

    Rectangle{
        id:maskRec
        opacity: 0.2
        color: "black"
        anchors.fill: parent
        visible: false
        z:2
        MouseArea{
            anchors.fill: parent
            onPressed: {
                if(visible)
                    mouse.accepted = true
                else mouse.accepted = false
            }
        }
    }

    //确认密码框
    Rectangle{
        id:confirmRec
        visible: false
        z:10
        anchors.centerIn: parent
        radius: dp(3)
        color: "white"
        width: dp(50)
        height: dp(32)
        Column{
            anchors.fill: parent
            spacing: dp(3)
            Rectangle{
                color: "transparent"
                width: parent.width
                height: dp(8)
                Text {
                    text: "请输入密码"
                    anchors.centerIn: parent
                    font.pixelSize: dp(5)
                }
            }
            TextField{
                id: mmField
                width: parent.width * 0.9
                anchors.horizontalCenter: parent.horizontalCenter
                height: dp(8)
                echoMode: TextInput.Password
                clip: false
            }
            Rectangle{
                color: "white"
                width: dp(16)
                height: dp(8)
                radius: 5
                anchors.horizontalCenter: parent.horizontalCenter
                border{
                    color: allColor
                    width: 2
                }
                Text {
                    text: "确定"
                    anchors.centerIn: parent
                    font.pixelSize: dp(5)
                    color: allColor
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        var tmpMM = mmField.text
                        console.log("The mm is = ",tmpMM)
                        mmField.text = ""
                        if(tmpMM == userPwd){
                            confirmRec.visible = false
                            root.pushStack(5);
                        }
                        else{
                            confirmRec.visible = false
                            errortip.visible = true
                        }
                        maskRec.visible = false
                    }
                }
            }
        }


    }

    LittleWindow{
        id:errortip
        btnNum: 1
        icon:"../../assets/mdpi/error.png"
        rectext: "密码错误！ "
        onBtnClicked: {
            console.log("The result is = ",isClick)
            errortip.visible = false
        }
    }

}
