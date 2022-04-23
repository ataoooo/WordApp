import QtQuick 2.0
import "../Component"
import "../Page"

//登录后的主页面
Rectangle{
    id:page
    property var currentIndex: 0

    //上层布局
    Rectangle{
        id:tabView
        anchors{
            bottom: tabBar.top
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }
        width: parent.width
        color: "white"
        state: "dictionary"

        DirectoryPage{id:direPage}
        UserPage{id:userPage}
        RemeberPage{id:remeberPage}

        states: [
            State {
                name: "dictionary"
                PropertyChanges {target: direPage;opacity:1}
            },
            State {
                name: "study"
                PropertyChanges {target: direPage;opacity:1}
            },
            State {
                name: "remember"
                PropertyChanges {target: remeberPage;opacity:1}
            },
            State {
                name: "mine"
                PropertyChanges {target: userPage;opacity:1}
            }
        ]
    }

    onCurrentIndexChanged: {
        var states = ["dictionary","study","remember","mine"]
        console.log("The current status is = ",tabView.states)
        switch(tabView.state){
        case states[0]:direPage.opacity = 0; tabView.state = states[currentIndex];break;

        case states[2]:remeberPage.opacity = 0;tabView.state = states[currentIndex];break;
        case states[3]:userPage.opacity = 0; tabView.state = states[currentIndex];break;
        }
    }

    //最下一栏
    Rectangle{
        id:tabBar
        width: parent.width
        height: dp(14)
        anchors.bottom: parent.bottom
        anchors.verticalCenter: parent.horizontalCenter
        //分界线
        Rectangle{
            width: parent.width
            height: 1
            color: "grey"
            opacity: 0.6
            anchors.bottom: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Row{
            anchors{
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: -dp(2.5)
            }
            spacing: dp(20)
            Repeater {
                id: tabbtn;
                model: [["dictionary", "词典"], ["study", "学习"],
                    ["remember", "记忆"], ["mine", "我的"]] //记录source用
                delegate: Image {
                    height: tabBar.height * 0.4;
                    fillMode: Image.PreserveAspectFit;
                    source: currentIndex === index? //根据按钮对应的页面序号是否是当前页面来判断应该显示亮起的图标还是暗下的图标
                                                    "../../assets/mdpi/ic_" + modelData[0] + "_color.png":
                                                    "../../assets/mdpi/ic_" + modelData[0] + "_grey.png";
                    Text {
                        text: modelData[1];
                        color: currentIndex === index? allColor: "#989898";
                        anchors.horizontalCenter: parent.horizontalCenter;
                        anchors.top: parent.bottom;
                        anchors.topMargin: dp(1);
                        font.pixelSize: dp(3);
                    }
                    MouseArea{
                        enabled: currentIndex !== index;
                        anchors.centerIn: parent;
                        width: parent.width;
                        height: parent.height;
                        onClicked:
                        {
                            currentIndex = index;
                            console.log("The current index is = ",index)
                        }
                    }
                }

            }

        }
        z:0
    }
}
