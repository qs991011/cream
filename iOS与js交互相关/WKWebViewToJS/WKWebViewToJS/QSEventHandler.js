var QSEventHandler = {
callNativeFunction:function(nativeMethodName,params,callBackID,callBack) {
    window.webkit.messageHandlers.QSEventHandler.postMessage(1);
}
};
