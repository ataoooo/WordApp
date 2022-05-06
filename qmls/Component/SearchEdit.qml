import QtQuick 2.0
import QtQuick.Controls 2.5
//自定义搜索框
Rectangle{
    id:searchRec
    height:40
    width: 330
    //设置边界
    border{
        width: 2
        color: "grey"
    }
    color: "white"
    property var singlewidth: 40
    signal clickSearchBtn()

    //最右侧“搜索”文字
    Rectangle{
        id:textRec
        height: parent.height
        width: dp(11)
        color: "transparent"
        anchors{
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        border{
            width: 2
            color: "grey"
        }
        Text {
            text: qsTr("搜索")
            color: "#555247"
            anchors.centerIn: parent
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                m_listView.visible = false
                if(searchEd.text == "") return;
                root.searchTxt = searchEd.text
                console.log("aaaa:",stack.depth)
                root.wordTxt = wordDB.searchTargetWord(root.tablename,searchTxt);
                //获取在线信息
                network.reciveWebMess(root.wordTxt[1])
                if(stack.depth > 1)
                {
                    clickSearchBtn()
                    root.pop()
                }
                root.pushStack(3)
            }
        }
    }

    //编辑框
    TextField{
        id:searchEd
        clip: false
        focus: true
        height: parent.height
        //text: zonelist.currentIndex
        //输入字母以及空格
        validator: RegExpValidator {regExp: /^[A-Za-z\s]*$/}
        anchors{
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: textRec.left
            rightMargin: dp(1)
        }
        text: root.searchTxt
        background: Rectangle{
            color: "transparent"
        }
        //监听键盘事件
        Keys.onReleased: {
            m_listView.visible = true
            var tmp = wordDB.searchWord(root.tablename,searchEd.text)
            if(tmp == []) return;
            if( searchEd.text == "" ) tmp = []
            m_listView.model = tmp
        }
    }

    //下拉框
    ListView {
        id : m_listView
        width: searchEd.width

        anchors{
            top: searchEd.bottom
            left: parent.left
            leftMargin: dp(1)
        }

        height: 120
        clip: true
        model: []
        delegate: numberDelegate
        //spacing: 5
        focus: true
        currentIndex: -1
    }
    Component {
        id: numberDelegate
        Rectangle {
            width: ListView.view.width
            height: singlewidth  //单个选项栏的宽度
            color: ListView.isCurrentItem ? "#D5A7BB" : "white" //选中颜色设置
            border.color: Qt.lighter(color, 1.1)
            Text {
                anchors{
                    left: parent.left
                    leftMargin: dp(1)
                    verticalCenter: parent.verticalCenter
                }

                font.pixelSize: 15
                text: modelData
            }
            MouseArea {
                anchors.fill: parent
                onClicked:{
                    m_listView.currentIndex = index  //实现item切换
                    searchEd.text = modelData
                }
                onDoubleClicked: {
                    searchEd.text = modelData
                    m_listView.model = []
                }
            }
        }
    }


}
