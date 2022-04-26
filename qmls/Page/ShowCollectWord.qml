import QtQuick 2.0
import "../Component"

StackPageBase{
    id:page
    _title:"我的收藏"

    ListViewEx{
        id:memView
        clip: true
        width: parent.width
        anchors{
            top:parent.top
            topMargin: dp(3)
            bottom: parent.bottom
        }
        spacing: 2
        model:ListModel{
            id:modelis
            function reflesh(){
                test()
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
        delegate: Rectangle{
            id:meminfo
            height: dp(15)
            color: "#F1DDDD"
            width: dp(100)
            //左端显示单词
            Text {
                id: englis
                text: word
                height: parent.height * 0.2
                width: parent.width - pg.width - dp(5)
                wrapMode: Text.Wrap
                anchors{
                    left: parent.left
                    leftMargin: dp(3)
                    top: parent.top
                    topMargin: dp(1)
                }
            }
            Text {
                id: chine
                text: chinese
                height: parent.height * 0.4
                width: parent.width - pg.width - dp(5)
                wrapMode: Text.Wrap
                anchors{
                    top: englis.bottom
                    topMargin: dp(1)
                    left: parent.left
                    leftMargin: dp(3)
                }
            }

            Image {
                id:pg
                property var iscollect: true
                anchors{
                    right: parent.right
                    rightMargin: dp(3)
                    verticalCenter: parent.verticalCenter
                }
                source: "../../assets/mdpi/sc.png"
                height: parent.height * 0.4
                fillMode: Image.PreserveAspectFit
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        parent.iscollect = !parent.iscollect
                        parent.source = parent.iscollect ? "../../assets/mdpi/sc.png" : "../../assets/mdpi/nosc.png"
                        if(parent.iscollect)
                        {
                            wordDB.collectWord(root.tablename,englis.text)
                            root.showMsgHint("恢复收藏")
                        }
                        else
                        {
                            wordDB.cancelCollect(root.tablename,englis.text);
                            root.showMsgHint("取消收藏")
                        }
                    }
                }
            }
        }
        Component.onCompleted: memView.moveToHeader()
    }
    function test(){
        modelis.clear()
        //获取所有的收藏的单词
        var allWordsList = wordDB.collectWords(root.userSno)
        var i = 0;
        console.log("show sentence is = ",allWordsList[0])
        while(allWordsList[i] != undefined){
            console.log("show sentence is = ",allWordsList[i])
            modelis.append({"word":splitword(0,allWordsList[i]),"chinese":splitword(1,allWordsList[i])})
            ++i;
        }
    }

    //分解单词
    function splitword(sno,str)
    {
        var tmplist = str.split('&')
        return tmplist[sno];
    }
}
