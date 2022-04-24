import QtQuick 2.0
import QtQuick.Controls 2.5
import "../Component"

Page {
    id: page3
    anchors.fill: parent
    opacity: 0
    visible: opacity > 0
    property var currentWord: -1
    property var englishword:[]
    property var chinesemena:[]
    Rectangle{
        anchors.fill: parent
        z: 0
        color: "#eeeeee"
    }
    //头部红色背景
    PageHeader{
        id:header
    }

    onVisibleChanged: {
        if(visible == false){
            setTime.stop()
            currentWord = -1
            englishTxt.text = ""
            chineseTxt2.text = ""
            chineseTxt.text = ""

        }
    }

    //下拉框
    MyComboBox{
        model: ["单词背诵","单词默写","单词填空"]
        anchors{
            left: parent.left
            leftMargin: dp(3)
            verticalCenter: header.verticalCenter
        }
        onCurrentIndexChanged: {
            if(currentIndex == 0)
            {
                switchAni.testt = true
                switchAni.start()
            }
            else if(currentIndex == 1)
            {
                switchAni.testt = false
                switchAni.start()
            }
        }
    }


    //制定策略按钮
    Rectangle{
        id:setRec
        width: parent.width / 4
        height:  header.height * 0.6
        color: "#eeb646"
        radius: dp(3)
        anchors{
            right: parent.right
            rightMargin: dp(3)
            verticalCenter: header.verticalCenter
        }
        Text {
            anchors.centerIn: parent
            text: "设置策略"
            color: "white"
            font.pixelSize: dp(4)
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                switchAni.testt = !switchAni.testt
                switchAni.start()
            }
        }
    }

    ///整体作一个可滑动页面
    Flickable {
        id: inner
        clip: true
        anchors{
            top: header.bottom
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
        }
        flickableDirection: Flickable.VerticalFlick; //只允许垂直滑动
        width: parent.width;
        contentWidth: parent.width * 2;
        contentHeight: dp(200)
        contentX: parent.width;


        //-----------------------------------右窗口显示------------------------------------
        //单词默写（全词默写）
        Rectangle{
            color: "transparent"
            height: parent.height
            width: page3.width
            x:page3.width
            anchors{
                top: parent.top
                left: parent.left
                leftMargin: page3.width
            }

            //开始测试按钮
            Rectangle{
                id:startRec
                width: parent.width / 4
                height:  header.height * 0.6
                color: allColor
                radius: dp(3)
                anchors{
                    top: parent.top
                    topMargin: dp(10)
                    horizontalCenter: parent.horizontalCenter
                    //verticalCenter: parent.verticalCenter
                }
                Text {
                    anchors.centerIn: parent
                    text: "开始测试"
                    color: "white"
                    font.pixelSize: dp(4)
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        getTestWord()
                        setTime.start()
                    }
                }
            }
            //中文释义
            Rectangle{
                id:chinesRec
                width: page3.width * 0.8
                height: parent.height * 0.15
                color: "white"
                anchors{
                    top: parent.top
                    topMargin: dp(35)
                    horizontalCenter: parent.horizontalCenter
                }
                Text {
                    id:chineseTxt2
                    anchors.centerIn: parent
                    width: parent.width
                    text: ""//"n.欢呼，赞扬，称赞； vt. 欢呼，喝彩，鼓掌欢迎；推选"
                    font.pixelSize: dp(6)
                    color: "red"
                    wrapMode:Text.Wrap
                }
            }

            //输入框
            TextField{
                id:tFied
                clip: false
                width: parent.width * 0.8
                height: parent.height * 0.05
                font.pixelSize: dp(4)
                background: Rectangle{
                    color: "transparent"
                }
                anchors{
                    top: parent.top
                    topMargin: dp(90)
                    horizontalCenter: parent.horizontalCenter
                }
            }
            //下划线
            Rectangle{
                height: 1
                width: tFied.width
                color: "grey"
                anchors{
                    top:tFied.bottom
                    horizontalCenter: parent.horizontalCenter
                }
            }
        }

        //-----------------------------------right ending---------------------------------





        //-----------------------------------左窗口显示-------------------------------------
        //显示单词框
        Rectangle{
            id:sowRec
            x:0
            width: page3.width * 0.8
            height: parent.height * 0.15
            color: "white"
            anchors{
                top: parent.top
                topMargin: dp(10)
                left: parent.left
                leftMargin: page3.width * 0.1
            }
            Text {
                id:englishTxt
                anchors.centerIn: parent
                text: ""//"acclaim"
                font.pixelSize: dp(8)
                color: "red"
                wrapMode:Text.Wrap
            }
        }

        Row{
            id:r1
            width: sowRec.width * 0.6
            anchors{
                top: sowRec.bottom
                topMargin: dp(3)
                horizontalCenter: sowRec.horizontalCenter
            }
            spacing: dp(5)

            Image {
                id: pre
                source: "../../assets/mdpi/prefer.png"
                width: dp(10)
                fillMode:Image.PreserveAspectFit
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(currentWord > 0)
                            showTxt(--currentWord)
                    }
                }
            }

            Image {
                id: startBtn
                source: "../../assets/mdpi/start.png"
                width: dp(10)
                fillMode: Image.PreserveAspectFit
                property var istart: false
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        console.log("click the start..")
                        parent.source = parent.istart ? "../../assets/mdpi/start.png" : "../../assets/mdpi/stop.png"
                        parent.istart = !parent.istart

                        getTestWord()
                        setTime.start()

                    }
                }
            }
            Image {
                id: nextBtn
                source: "../../assets/mdpi/next.png"
                width: dp(9.5)
                fillMode: Image.PreserveAspectFit
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(currentWord < englishword.length - 1)
                            showTxt(++currentWord)
                    }
                }
            }
        }

        Row{
            id:r2
            width: sowRec.width * 0.6
            anchors{
                top: r1.bottom
                topMargin: dp(3)
                horizontalCenter: sowRec.horizontalCenter
            }
            spacing: dp(5)

            Image {
                id: falsebtn
                source: "../../assets/mdpi/false.png"
                width: dp(9.5)
                fillMode:Image.PreserveAspectFit
            }

            Image {
                id: anserBtn
                source: "../../assets/mdpi/noshowanswer.png"
                width: dp(10)
                fillMode: Image.PreserveAspectFit
                property var isshow: false
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        parent.source = parent.isshow ? "../../assets/mdpi/noshowanswer.png" : "../../assets/mdpi/showanser.png"
                        parent.isshow = !parent.isshow
                    }
                }
            }

            Image {
                id: rightBtn
                source: "../../assets/mdpi/right.png"
                width: dp(9.5)
                fillMode: Image.PreserveAspectFit
            }
        }

        //答案显示框
        Rectangle{
            id:answerRec
            visible: anserBtn.isshow
            width: page3.width * 0.8
            height: parent.height * 0.15
            color: "white"
            anchors{
                top: r2.bottom
                topMargin: dp(10)
                horizontalCenter: sowRec.horizontalCenter
            }
            Text {
                id:chineseTxt
                anchors.centerIn: parent
                width: parent.width
                text: ""//"n.欢呼，赞扬，称赞； vt. 欢呼，喝彩，鼓掌欢迎；推选"
                font.pixelSize: dp(8)
                color: "red"
                wrapMode:Text.Wrap
            }
        }
        //--------------------------------left ending------------------------

        PropertyAnimation {
            id: switchAni;
            property var testt: false
            target: inner;
            property: "contentX";
            from: switchAni.testt ? parent.width : 0;
            to:switchAni.testt ?  0 : parent.width;  //isImg：当前展示的页面是否为广告图片
            duration: 150;
            easing.type: Easing.OutQuart;
        }
    }

    Timer{
        id:setTime
        interval: 5000 //设置定时器定时时间，默认为1000
        repeat: true //是否重复定时，默认为false
        running: false
        onTriggered: {
            showTxt(++currentWord)
            if(currentWord == 9)
            {
                startBtn.source = "../../assets/mdpi/start.png"
                setTime.stop()
            }
        }
    }


    function getTestWord()
    {
        var res = wordDB.rememberWord(root.tablename,10);
        for(var i = 0 ;i < 10 ; ++i)
        {
            console.log("aaaa:  ",res[i]);
            var tmpWord = res[i].split('-');
            for(var j = 0 ;j < 2;++j)
            {
                var tmp = tmpWord[j].split(':');
                console.log("tmp0 = ",tmp[0])
                switch(tmp[0]){
                case "word":englishword.push(tmp[1]);break;
                case "mean_cn":chinesemena.push(tmp[1]);break;
                }
            }
        }

    }

    function showTxt(index)
    {
        englishTxt.text = englishword[index];
        chineseTxt.text = chinesemena[index];
        chineseTxt2.text = chinesemena[index];
    }

}
