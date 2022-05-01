import QtQuick 2.0
import "../Component"

StackPageBase {
    id:page
    _title: "关于我们"
    Rectangle{
        width: parent.width
        color: "#eeeeee"
        anchors{
            top: parent.top
            bottom: parent.bottom
        }
        Text {
            id: name
            text: qsTr("单词速记App")
            width: contentWidth
            anchors{
                left: parent.left
                leftMargin: (page.width - name.width) / 2
                top: parent.top
                topMargin: dp(20)
            }
            font.pixelSize: dp(5)
            font.bold: true
        }
        Text {
            id: name2
            text: qsTr("Version 0.0.1")
            width: contentWidth
            anchors{
                left: parent.left
                leftMargin: (page.width - name2.width) / 2
                top: name.bottom
                topMargin: dp(5)
            }
            font.pixelSize: dp(4)
        }

        Text {
            id: name3
            text: "《软件许可及服务协议》"
            width: contentWidth
            anchors{
                left: parent.left
                leftMargin: (page.width - name3.width) / 2
                top: name2.bottom
                topMargin: dp(90)
            }
            font.pixelSize: dp(3)
        }
        Text {
            id: name4
            text: "《隐私保护指引摘要》 《隐私保护指引》"
            width: contentWidth
            anchors{
                left: parent.left
                leftMargin: (page.width - name4.width) / 2
                top: name3.bottom
                topMargin: dp(3)
            }
            font.pixelSize: dp(3)
        }
        Text {
            id: name5
            text: "客服电话: 888 888 8888"
            width: contentWidth
            anchors{
                left: parent.left
                leftMargin: (page.width - name5.width) / 2
                top: name4.bottom
                topMargin: dp(3)
            }
            font.pixelSize: dp(3)
        }
        Text {
            id: name6
            text: "中南林业科技大学 版权所有"
            width: contentWidth
            anchors{
                left: parent.left
                leftMargin: (page.width - name6.width) / 2
                top: name5.bottom
                topMargin: dp(3)
            }
            font.pixelSize: dp(3)
        }
    }
}
