var QSEventHandler ={
    
callNativeFunction:function(nativeMethodName,params,callBackID,callBack){
    var message;
    
    if(!callBack){
        
        message = {'methodName':nativeMethodName,'params':params};
        window.webkit.messageHandlers.QSEventHandler.postMessage(message);
        
    }else{
        message = {'methodName':nativeMethodName,'params':params,'callBackID':callBackID};
        if(!QSBridgeEvent._listeners[callBackID]){
            QSBridgeEvent.addEvent(callBackID, function(data){
                                   
                                   callBack(data);
                                   
                                   });
        }
        window.webkit.messageHandlers.QSEventHandler.postMessage(message);
    }
    
    
},
newCallNativeFunction:function(nativeMethodName,params,callBackID,successCallBack,failureCallBack){
    var message;
    if(successCallBack && failureCallBack){
        var successCallBackID = callBackID;
        successCallBackID +='successCallBack';
        
        var failureCallBackID = callBackID;
        failureCallBackID +='failureCallBack';
        
        message = {'type':'NewJSFunction','methodName':nativeMethodName,'params':params,'successCallBackID':successCallBackID,'failureCallBackID':failureCallBackID};
        if(!QSBridgeEvent._listeners[successCallBackID]){
            QSBridgeEvent.addEvent(successCallBackID, function(data){
                                   
                                   successCallBack(data);
                                   
                                   });
        }
        if(!QSBridgeEvent._listeners[failureCallBackID]){
            QSBridgeEvent.addEvent(failureCallBackID, function(data){
                                   
                                   failureCallBack(data);
                                   
                                   });
        }
        
        window.webkit.messageHandlers.QSEventHandler.postMessage(message);
        
    }else if(successCallBack && !failureCallBack){
        var successCallBackID = callBackID;
        successCallBackID +='successCallBack';
        message = {'type':'NewJSFunction','methodName':nativeMethodName,'params':params,'successCallBackID':successCallBackID};
        if(!QSBridgeEvent._listeners[successCallBackID]){
            QSBridgeEvent.addEvent(successCallBackID, function(data){
                                   
                                   successCallBack(data);
                                   
                                   });
        }
        window.webkit.messageHandlers.QSEventHandler.postMessage(message);
    }else if(failureCallBack && !successCallBack){
        var failureCallBackID = callBackID;
        failureCallBackID +='failureCallBack';
        message = {'type':'NewJSFunction','methodName':nativeMethodName,'params':params,'failureCallBackID':failureCallBackID};
        if(!QSBridgeEvent._listeners[failureCallBackID]){
            QSBridgeEvent.addEvent(failureCallBackID, function(data){
                                   
                                   failureCallBack(data);
                                   
                                   });
        }
        window.webkit.messageHandlers.QSEventHandler.postMessage(message);
    }
    else{
        message = {'type':'NewJSFunction','methodName':nativeMethodName,'params':params};
        window.webkit.messageHandlers.QSEventHandler.postMessage(message);
    }
},
    
callBack:function(callBackID,data){
    
    QSBridgeEvent.fireEvent(callBackID,data);
    
},
    
removeAllCallBacks:function(data){
    QSBridgeEvent._listeners ={};
}
    
};



var QSBridgeEvent = {
    
_listeners: {},
    
    
addEvent: function(type, fn) {
    if (typeof this._listeners[type] === "undefined") {
        this._listeners[type] = [];
    }
    if (typeof fn === "function") {
        this._listeners[type].push(fn);
    }
    
    return this;
},
    
    
fireEvent: function(type,param) {
    var arrayEvent = this._listeners[type];
    if (arrayEvent instanceof Array) {
        for (var i=0, length=arrayEvent.length; i<length; i+=1) {
            if (typeof arrayEvent[i] === "function") {
                arrayEvent[i](param);
            }
        }
    }
    
    return this;
},
    
removeEvent: function(type, fn) {
    var arrayEvent = this._listeners[type];
    if (typeof type === "string" && arrayEvent instanceof Array) {
        if (typeof fn === "function") {
            for (var i=0, length=arrayEvent.length; i<length; i+=1){
                if (arrayEvent[i] === fn){
                    this._listeners[type].splice(i, 1);
                    break;
                }
            }
        } else {
            delete this._listeners[type];
        }
    }
    
    return this;
}
};



