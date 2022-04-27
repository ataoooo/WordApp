import QtQuick 2.0
import QtQuick.Controls 2.5
import "../Component"

Page {
    id: page3
    anchors.fill: parent
    opacity: 0
    visible: opacity > 0
    property var currentWord: -1
    property var wordNum;
    property var englishword:[]
    property var chinesemena:[]
    property var mdifficulty: 1
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
                maskRec.visible = true
                sRec.visible = true
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
            onClicked: {
                sRec.visible = false
                maskRec.visible = false
            }
        }
    }

    //策略设置局面
    Rectangle{
        id:sRec
        width: parent.width
        height: parent.height / 3
        color: "#F1DDDD"
        visible: false
        anchors{
            top: header.bottom
        }
        z:99
        MouseArea{
            anchors.fill: parent
            onPressed: {
                if(visible) mouse.accepted = true
                else mouse.accepted = false
            }
        }

        //保存按钮
        //制定策略按钮
        Rectangle{
            id:saveRec
            width: parent.width / 5
            height:  header.height * 0.55
            color: allColor
            radius: dp(3)
            anchors{
                top: parent.top
                topMargin: dp(3)
                horizontalCenter: parent.horizontalCenter
            }
            Text {
                anchors.centerIn: parent
                text: "保 存"
                color: "white"
                font.pixelSize: dp(4)
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                }
            }
        }

        Column{
            id:ro
            width: parent.width * 0.8
            height: parent.height * 0.6
            anchors{
                top: saveRec.bottom
                topMargin: dp(3)
                horizontalCenter: parent.horizontalCenter
            }
            spacing: dp(2)

            //设置单词个数
            Rectangle{
                width: parent.width
                height: parent.height * 0.4
                color: "transparent"
                Rectangle{
                    id:wrec
                    width: parent.width / 3
                    height: parent.height
                    color: "transparent"
                    Text {
                        id: wtxt
                        anchors.centerIn: parent
                        text: "单词个数:"
                        font.pixelSize: dp(5)
                    }
                }
                SpinBox{
                    id:setSp
                    width: parent.width / 2
                    height: parent.height * 0.8
                    value: 20
                    from: 10
                    to: 100
                    stepSize: 5
                    anchors{
                        left:wrec.right
                        leftMargin: dp(3)
                        top: parent.top
                        topMargin: (parent.height - setSp.height) / 2
                    }
                    font.pixelSize: dp(5)
                }
            }

            //难度设置
            Rectangle{
                width: parent.width
                height: parent.height * 0.4
                color: "transparent"
                Rectangle{
                    id:nrec
                    width: parent.width / 3
                    height: parent.height
                    color: "transparent"
                    Text {
                        id: ntxt
                        anchors.centerIn: parent
                        text: "单词难度:"
                        font.pixelSize: dp(5)
                    }
                }
                //图形排列
                Row{
                    id:imgRow
                    anchors{
                        left: nrec.right
                        leftMargin: dp(3)
                    }
                    height: parent.height
                    width: setSp.width * 0.8
                    spacing: dp(3)

                    Image {
                        id: star1
                        source: "../../assets/mdpi/diff_grey.png"
                        height: parent.height * 0.6
                        fillMode: Image.PreserveAspectFit
                        anchors{
                            top: parent.top
                            topMargin: (parent.height - star1.height) / 2
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                parent.source = "../../assets/mdpi/diff_red.png"
                                star2.source = "../../assets/mdpi/diff_grey.png"
                                star3.source = "../../assets/mdpi/diff_grey.png"
                                diffTxt.text = "简单"
                                mdifficulty = 1;
                            }
                        }
                    }
                    Image {
                        id: star2
                        source: "../../assets/mdpi/diff_grey.png"
                        height: parent.height * 0.6
                        fillMode: Image.PreserveAspectFit
                        anchors{
                            top: parent.top
                            topMargin: (parent.height - star1.height) / 2
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                parent.source = "../../assets/mdpi/diff_red.png"
                                star1.source = "../../assets/mdpi/diff_red.png"
                                star3.source = "../../assets/mdpi/diff_grey.png"
                                diffTxt.text = "一般"
                                mdifficulty = 2;
                            }
                        }
                    }
                    Image {
                        id: star3
                        source: "../../assets/mdpi/diff_grey.png"
                        height: parent.height * 0.6
                        fillMode: Image.PreserveAspectFit
                        anchors{
                            top: parent.top
                            topMargin: (parent.height - star1.height) / 2
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                parent.source = "../../assets/mdpi/diff_red.png"
                                star1.source = "../../assets/mdpi/diff_red.png"
                                star2.source = "../../assets/mdpi/diff_red.png"
                                diffTxt.text = "困难"
                                mdifficulty = 3;
                            }
                        }
                    }
                }
                //显示难度
                Rectangle{
                    color: "transparent"
                    anchors{
                        left: imgRow.right
                        right: parent.right
                    }
                    height: parent.height
                    Text {
                        id: diffTxt
                        anchors.centerIn: parent
                        color: "red"
                        font.pixelSize: dp(4)
                        text: ""
                    }
                }
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
                    text: ""
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
        //只为获取长度
        Text{
            id:engxx
            visible: false
            font.pixelSize: dp(8)
        }

        //微调控件
        Text {
            text: "设置单词间隔时间（单位秒）"
            anchors{
                bottom:sp.top
                bottomMargin: dp(2)
                horizontalCenter: sp.horizontalCenter
            }
        }
        SpinBox{
            id:sp
            width: parent.width / 8
            height: setRec.height
            value: 5
            stepSize: 5
            from: 5
            to: 60
            anchors{
                top: parent.top
                topMargin: dp(10)
                left: parent.left
                leftMargin: (parent.width / 2 - sp.width) / 2
            }
        }

        Rectangle{
            id:sowRec
            x:0
            width: page3.width * 0.8
            height: parent.height * 0.15
            color: "white"
            anchors{
                top: parent.top
                topMargin: dp(25)
                left: parent.left
                leftMargin: page3.width * 0.1
            }
            Text {
                id:englishTxt
                width: engxx.contentWidth > parent.width ? parent.width : engxx.contentWidth
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: ""
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



                        setTime.interval = sp.value * 1000
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
                text: ""
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
        var res = wordDB.rememberWord(root.userSno,100,0.25,0.25,0.25,0.25);
        for(var i = 0 ;i < 100 ; ++i)
        {
            var tmpWord = res[i].split('&');
            englishword.push(tmpWord[0]);
            chinesemena.push(tmpWord[1]);
        }

    }

    function showTxt(index)
    {
        englishTxt.text = englishword[index];
        engxx.text = englishword[index];
        chineseTxt.text = chinesemena[index];
        chineseTxt2.text = chinesemena[index];
    }

    //选框的状态
    function setSpStatus(status)
    {
        if(!status)
        {
            sp.from = sp.value
            sp.to = sp.value
        }
        else{
            sp.from = 5
            sp.to = 60
        }
    }
}
