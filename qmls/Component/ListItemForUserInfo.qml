import QtQuick 2.0
import QtQuick 2.12

Rectangle{
    id:listItem
    width: dp(100)
    height: dp(10)
    color: "white"
    property alias text: txt.text
    property alias content: content.text
    property var popWindow
    Text {
        id: txt
        anchors{
            left: parent.left
            leftMargin: dp(4)
            verticalCenter: parent.verticalCenter
        }
        font.pixelSize: dp(3.5)
        text: "test"
    }
    Text {
        id: content
        anchors{
            right: arr.left
            rightMargin: dp(4)
            verticalCenter: parent.verticalCenter
        }
        font.pixelSize: dp(3.5)
    }
    MouseArea{
        anchors.fill: parent
        onClicked: {
            root.showMask()
            popWindow = editPopWindow.createObject(root, {})
        }
    }

    ///////打开编辑小窗口，先打开root自带的透明Mask实现背景淡化，然后打开新的覆盖全屏
    //的MouseArea获取关闭事件，中间放置矩形窗口，大小通过修改w&h属性来决定
    //打开时：读取数据，启动开启动画open
    //关闭时，发送读入&输入的数据，通过调用root中的方法修改数据库 & 直接修改本控件中的content
    //就可以看到显示效果
    Component {
        id: editPopWindow;
        MouseArea {
            id: dialogP;
            property var w: dp(50);
            property var h: dp(20);
            property alias title: _txt.text;


            anchors.fill: parent;
            onClicked: {
                closeAni.start();
                root.closeMask();
            }
            Rectangle {
                id: dialog;
                radius: dp(3);
                color: "white";
                anchors.centerIn: parent;
                Text {
                    id: _txt;
                    font.pixelSize: dp(3);
                    anchors{
                        top: parent.top;
                        horizontalCenter: parent.horizontalCenter;
                        topMargin: dp(4);
                    }
                }

                //这里放文本框 （TextField或者Text展示文本）
                //下面放确定，返回的按钮，点击后都触发closeAni动画，但是点确定后
                //多调勇几个更改数据的函数

                MouseArea {
                    anchors.fill: parent;
                }

                //下面是开启 & 关闭时的动画效果
                ParallelAnimation {
                    id: open;
                    PropertyAnimation {
                        target: dialog;
                        property: "width";
                        from: 0;
                        to: dialogP.w;
                        duration: 150;
                        easing.type: Easing.OutQuart;
                    }
                    PropertyAnimation {
                        target: dialog;
                        property: "height";
                        from: 0;
                        to: dialogP.h;
                        duration: 150;
                        easing.type: Easing.InQuart;
                    }
                    onFinished: {
                        popWindow.title = txt.text; //保证动画效果，结束后文字
                    }
                }
                ParallelAnimation {
                    id: closeAni;
                    PropertyAnimation {
                        target: dialog;
                        property: "width";
                        from: dialog.w;
                        to: 0;
                        duration: 150;
                        easing.type: Easing.InQuart;
                    }
                    PropertyAnimation {
                        target: dialog;
                        property: "height";
                        from: dialogP.h;
                        to: 0;
                        duration: 150;
                        easing.type: Easing.OutQuart;
                    }
                    onStarted: {
                        popWindow.title = "";  //保证动画效果，消去文字
                    }
                    onFinished: popWindow.destroy(); //关闭动画结束时销毁组件
                }
            }
            Component.onCompleted: open.start();
        }
    }
}
