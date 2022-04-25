import QtQuick 2.0


//下拉刷新
ListView{
    id:lv
    property int pageSize: 20
    property int currentPage: 0
    property var headerComponent;
    property bool snapHeader: true      //是否自动收缩
    property string initPosition: "first"   //初始化定位：first header

    //数据加载事件
    signal load(var model);
    signal loadMore(var model,int page);

    property bool pressed: false
    property bool needReflesh: false
    property bool needLoadMore: false

    function moveToHeader(){
        contentY = -headerItem.loader.height;
    }

    function moveToFirst(){
        contentY = 0;
    }

    //下拉刷新区域
    header: Column{
        width: parent.width
        property alias indicator: headerIndicator
        property alias loader: headerLoader
        function goState(name){
            if(name == '') {imgHead.source = "../../assets/mdpi/xlistview_arrow.png"; txt.text='下拉刷新';}
            else if(name == "ready") {imgHead.source = "../../assets/mdpi/abc_btn_radio_to_on_mtrl_000.png";txt.text='放开即可刷新';}
            else if(name == 'load') {imgHead.source = "../../assets/mdpi/radiobtn_off.png";txt.text='加载中';}
            else if(name == 'ok') {imgHead.source = "../../assets/mdpi/ic_checked.png";txt.text='下拉刷新'; txtDt.text=getDateString();}
        }
        function getDateString(){
            return Qt.formatDateTime(new Date(), 'HH:mm:ss');
        }

        //下拉指示器
        Item{
            id:headerIndicator
            width: dp(50)
            height: dp(13)
            anchors.horizontalCenter: parent.horizontalCenter
            clip: true
            AnimatedImage{
                id:imgHead
                x:7
                y:1
                source: "../../assets/mdpi/xlistview_arrow.png";
                playing: true
                visible: true
                height: parent.height * 0.6
                fillMode: Image.PreserveAspectFit
            }
            Text {
                id: txt
                x:54
                y:2
                color: "#c0c0c0"
                text: "下拉可以刷新"
                font.pixelSize: dp(3.5)
            }
            Text {
                id: txtDt
                x:54
                y:18
                color: "#c0c0c0"
                text: "Last Update"
                font.pixelSize: dp(3.5)
            }
        }
        //自定义头部组件
        Loader{
            id:headerLoader
            sourceComponent: headerComponent
        }
    }

    //下拉刷新和上拉分页逻辑
    onMovementEnded: {
        //刷新数据
        if(needReflesh){
            lv.headerItem.goState('load');
            model.reflesh()
            needReflesh = false
        }
        //加载新数据
        else if(needLoadMore){
            model.loadMore()
            needLoadMore = false
        }
        else{
            var h1 = lv.headerItem.loader.height
            var h2 = lv.headerItem.indicator.height

            //头部区域自动隐藏(拖动过小隐藏头部，反之显示)
            if(snapHeader){
                if(contentY >= -h1/3 && contentY < 0)
                    moveToFirst()
                if(contentY >= -h1 && contentY < -h1/3)
                    moveToHeader()
            }
            //刷新区自动隐藏
            if(contentY >= -(h1 + h2) && contentY < -h1)
                moveToHeader()
        }
    }
    onContentYChanged: {
        //下拉刷新判断逻辑，已经到头了还下拉一定距离
        if(contentY < originY){
            var dy = contentY - originY
            if(dy < -10){
                lv.headerItem.goState('ready')
                needReflesh = true
            }
            else{
                if(pressed){
                    lv.headerItem.goState('')
                }
            }
        }
        //上拉加载判断逻辑；已经到底了还上拉一定距离
        if(contentHeight > height && contentY - originY > contentHeight - height){
            var dy = (contentY - originY) - (contentHeight - height)
            if(dy > 40){
                needLoadMore = true
            }
        }
    }
    onModelChanged: {
        if(lv.headerItem != null)
            lv.headerItem.goState('ok')
    }

    //定位到第一个元素（不显示header）
    Component.onCompleted: {
        model.reflesh()
        if(initPosition == 'header')
            moveToHeader()
        else
            moveToFirst()
    }

    //动画
    Behavior on contentY {
        NumberAnimation {duration: 200; easing.type: Easing.InOutQuad}
    }

    //滚动轴
    FlickableScrollBar{
        target: lv
        orientation: Qt.Vertical
    }
}
