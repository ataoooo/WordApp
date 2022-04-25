import QtQuick 2.0
import "../Component"

StackPageBase{
    id:page
    _title:"我的单词本"
    property var temp_qrmsg;

    ListViewEx{
        id: memView
        clip: true
        width: parent.width
        anchors{
            top: parent.top
            topMargin: dp(3)
            bottom: parent.bottom
        }
        spacing: 1
        model: ListModel{
            ListElement{bookName: "英语词汇"; ImgSource: "../../assets/mdpi/English_Book.png";}
            ListElement{bookName: "我的单词本"; ImgSource: "../../assets/mdpi/book_png.png"}
            function reflesh(){
                console.log("load")
                if(memView.headerItem != null)
                    memView.headerItem.goState('load')
                memView.load(this)
                memView.onModelChanged()
                memView.moveToHeader()
                memView.currentPage = 0
            }
            function loadMore(){
                memView.currentPage ++
                memView.loadMore(this,memView.currentPage)
                memView.onModelChanged()
            }
        }
        //项目展示（代理）
        delegate: Rectangle{
            id:memInfo
            height: dp(15)
            color: "white"
            width: dp(100)
            Image {
                id: heading
                source: ImgSource
                height: parent.height * 0.8
                width: height
                anchors.left: parent.left
                anchors.leftMargin: dp(4)
                anchors.verticalCenter: parent.verticalCenter
            }
            Image {
                id: arr
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: dp(4)
                source: "../../assets/mdpi/ic_ar_right.png"
                height: parent.height * 0.4
                fillMode: Image.PreserveAspectFit
            }
            Text {
                anchors{
                    left: heading.right
                    leftMargin: dp(5)
                    verticalCenter: parent.verticalCenter
                }
                text: bookName
                font.pixelSize: dp(3.5)
                color: "grey"
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    root.pushStack(10)
                    //一定要放在后面!
                    root.pageTile(bookName)
                    console.log("The book name is = ",bookName)
                }
            }
        }
        Component.onCompleted: memView.moveToHeader()
    }
    Component{
        id:qrmsg
        MouseArea{
            anchors.fill: parent
            property alias msg: m.text
            onClicked: {
                root.closeMask()
                temp_qrmsg.destroy()
            }
            Rectangle{
                color: "white"
                width: dp(40)
                height: dp(18)
                Text {
                    id: m
                    anchors.centerIn: parent
                }
            }
        }
    }

}
