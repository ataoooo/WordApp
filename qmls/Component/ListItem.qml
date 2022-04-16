import QtQuick 2.0

Rectangle{
    id:listitem
    width: dp(100)
    height: dp(20)
    color: "#eeeeee"
    property alias text: describe.text
    property alias icon: ico.source
    property var space: 10

    signal clicked()

    Rectangle{
        id:inner
        height: parent.height - parent.space
        width: parent.width
        Image {
            id: ico
            fillMode: Image.PreserveAspectFit
            anchors{
                left: parent.left
                leftMargin: dp(3)
                verticalCenter: parent.verticalCenter
            }
            height: parent.height * 0.8
        }
        Text {
            id: describe
            font.pixelSize: parent.height * 0.3
            anchors{
                left: ico.right
                verticalCenter: parent.verticalCenter
                leftMargin: dp(4)
            }
        }
        Image {
            id: arrow
            source: "../../assets/mdpi/icon_arrow.png"
            height: parent.height * 0.8
            fillMode: Image.PreserveAspectFit
            anchors{
                right: parent.right
                verticalCenter: parent.verticalCenter
                leftMargin: dp(4)
            }
        }
        MouseArea{
            anchors.fill: parent
            onClicked: listitem.clicked()
        }
    }
}
