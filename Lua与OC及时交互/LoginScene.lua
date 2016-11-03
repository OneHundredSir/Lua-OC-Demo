local LoginScene = class("LoginScene", cc.load("mvc").ViewBase)
LoginScene.userNameTextView = nil;
LoginScene.userPassTextView = nil;
LoginScene.userNameString = nil;
LoginScene.userPassString = nil;
LoginScene.main = nil;
LoginScene.indexAni = nil;

--回调的loginIOS的数据
LoginScene.iosCallBack = function(arg)
    --转table
    local b = stringToTable(arg);

    sendToOnline(5000,b);


end;


--ios端登录判断
LoginScene.islogining = false;


function LoginScene:initView()
    self.indexAni:removeFromParent();
    self.userNameTextView =  seekByName(self.main,"login_username");
    self.userPassTextView = seekByName(self.main,"login_userpass");

    cc.Director:getInstance():setDisplayStats(true)
--联网模式
    self:connect(self.debugModeClickTimes > 5);
    
    local function callback(obj, e)
        if e == ccui.TouchEventType.ended then
            if obj:getName() == "login_start" then
                --让按钮失效

                self:login();
            elseif obj:getName() == "login_regist" then
                self:regist();
            elseif obj:getName() == "Image_3" then
                self:debugMode();
            end
        end
    end

    toBtn(self.main, "login_start", callback)
    toBtn(self.main, "login_regist", callback)
    toBtn(self.main, "Image_3",callback);

    self:initCache();

end


--JAVA交互数据!
function LoginScene:callJavaMethod(method,args)
    print(args);

    local luaj = require "cocos.cocos2d.luaj";
    local className = "com/yfsd/game/fish/AppActivity";
    local sigs = "(Ljava/lang/String;)Ljava/lang/String;" 

    local ok,ret = luaj.callStaticMethod(className,method,{args},sigs)  
    if ok then
        return ret; 
    end  
end

--这里就是调用lua和OC的方法!
--IOS交互数据!
function LoginScene:callIOSMethod(class,classMethod,args)
    print(args)
    --导入LUA转OC的函数!并且实例化
    local luaoc = require "cocos.cocos2d.luaoc";
    local ok, ret = luaoc.callStaticMethod(class, classMethod, args)
    if not ok then
        print(string.format("SDKNdCom.payForCoins() - call API failure, error code: %s", tostring(ret)))
        return
    end
    --如果传入成功就传ret
    print("这是原来的传的信息\n")
    dump(ret)
    return ret
end

--登录
function LoginScene:login()
    if self:checkInput() then
        local param = {acc11=self.userNameString,pass11=self.userPassString}

        -- sendToOnline(499,param);
        if device.platform == "android" then
            local args = self.userNameString .. "!##!" .. "2143214!##!" .. self.userPassString;
            --安卓还没有做处理登录的接口
            local result = self:callJavaMethod("registUser",args);
            if result ~= "" then
                showTip("登录成功！");
            end
        elseif device.platform == "windows" then
            sendToOnline(500,param);
        elseif device.platform == "ios" then
            --  暂时不设置按钮隐藏,设置判断值
            --self:loginBtnStatus(false);
            -- 调用IOS登录方法
            self:iosLogin(self.userNameString,self.userPassString)
        end
    end

end

function LoginScene:loginBtnStatus(status)
    self.loginBtn = seekByName(self.main,"login_start");
    self.loginBtn:setEnabled(status)
end



--ios登录的方法
function LoginScene:iosLogin(tmpAccount,tmpPassword)
    print("这是传递的判断值",self.islogining)
    if not self.islogining then
        --print("--->💩💩💩💩💩111")
        -- 传入3个数字,账号,密码,回调函数!
        local iosLoginParam = {acc11=tmpAccount,pass11=tmpPassword,callback11 = self.iosCallBack}
        local result = self:callIOSMethod("ZSGameWebWork", "loginForGame", iosLoginParam)
        --sendToOnline(5000,result);
        self.islogining = true
        --sendToOnline(500,param);
        dump(param)

    else
        --print("--->💩💩💩💩💩222")
        showTip("正在登录..")
    end

end


-- 检查输入
function LoginScene:checkInput()
    
    if not isConnect() then
        showTip("未连接到服务器，正在重连！");
        self:connect(self.debugModeClickTimes > 5);
        return;
    end
    

    self.userNameString = self.userNameTextView:getString();
    self.userPassString = self.userPassTextView:getString();
    if string.len(self.userNameString) == 0 then
        showTip("请输入账号！");
        return false;
    end
    if string.len(self.userPassString) == 0 then
        showTip("请输入密码！");
        return false;
    end
    saveValue(2,"user_name",self.userNameString);
    saveValue(2,"user_pass",self.userPassString);

    return true;
end

function LoginScene:recvData(cmd, data)

     print("recvData from: " .. cmd)


    if cmd == 5000 then

        for k,v in pairs(data) do
            if k == "error_code" then
                if v == 0 then
                    showTip("登录成功！");
                else
                    errorTips(v)
                end
                --设置取消正在登陆
                self.islogining = false
                print("设置数据变化",self.islogining)
            end

            -- 保存用户id
            if k == "player_id" then
                saveValue(1,"save_userid",v);

            end

        end
    end
end

-- 联网
function LoginScene:connect(debug)
    print("这是打印的debug与否",debug)
    if debug then
        DataExchange:getInstance():startNetWork("10.1.1.181", 8888)
    else
        DataExchange:getInstance():startNetWork("120.76.27.59", 8889)
    end
end

-- 调试模式
function LoginScene:debugMode()
    if self.debugModeClickTimes > 3 then
        showTip(self.debugModeClickTimes > 5 and "当前已是本地调试模式" or "点击"..tostring(6-self.debugModeClickTimes).."次进入本地调试模式");
    end

    self.debugModeClickTimes = self.debugModeClickTimes + 1;
end


return LoginScene
