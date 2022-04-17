import QtQuick 2.12
import QtQuick.Controls 2.12
import "../Component"

StackPageBase {
    _title: "用户信息";
    id: accPage;
    property var pickSelect;

    Column {
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.top: parent.top;
        width: dp(100);
        spacing: 1;

        Component {
            id: pickBar;
            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    root.closeMask();
                    closeAni.start();
                    stack.focus = true;
                }

                //下面为开启&关闭时的动画效果
                ParallelAnimation {
                    id: openAni;
                    PropertyAnimation {
                        target: pick;
                        property: "width";
                        from: 0;
                        to: dp(90);
                        duration: 200;
                        easing.type: Easing.OutQuart;
                    }
                    PropertyAnimation {
                        target: pick;
                        property: "height";
                        from: 0;
                        to: dp(50);
                        duration: 200;
                        easing.type: Easing.InQuart;
                    }

                }
                ParallelAnimation {
                    id: closeAni;
                    PropertyAnimation {
                        target: pick;
                        property: "width";
                        from: dp(90);
                        to: 0;
                        duration: 200;
                        easing.type: Easing.InQuart;
                    }
                    PropertyAnimation {
                        target: pick;
                        property: "height";
                        from: dp(50);
                        to: 0;
                        duration: 200;
                        easing.type: Easing.OutQuart;
                    }
                    onFinished: pickSelect.destroy(); //关闭动画结束时销毁组件
                }
                function open(){ openAni.start() }
                function closeA(){ closeAni().start() }
            }
        }


        ///下方的Repeater中
        //添加同类项目列表,在model中添加xy自适应大小，可也以利用内部自适应的方式窗口调整大小
        Repeater {
            model: [["我的名称",root.userName],["我的身份",root.userType], ["我的电话",root.userPhone], ["我的密码",root.userPwd]];
            delegate: ListItemForUserInfo {
                text: modelData[0] + "\t\t" + modelData[1];
            }
        }
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_Back) {
            if(pickSelect !== null){
                pickSelect.closeA();
            }
        }
    }
}
