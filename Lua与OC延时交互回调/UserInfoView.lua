printInfo("load UserInfoView")

local UserInfoView = class("UserInfoView", cc.load("mvc").ViewBase)

UserInfoView.RESOURCE_FILENAME = "Games/fishKing/UserInfo/UserInfo.csb"  -- ÉèÖÃ¼ÓÔØµÄ csb ÎÄ¼þ
UserInfoView.RESOURCE_BINDING = { -- °ó¶¨¿Ø¼þ
    ["deposit"]   = {["varname"] = "btnDeposit" },
    ["make_name"]   = {["varname"] = "btnMakeName" },
    ["make_face"]   = {["varname"] = "btnMakeFace" },
    ["money"] = {["varname"] = "money"},
    ["exit"] = {["varname"] = "btnExit"},
    ["bg"] = {["varname"] = "imageBg"},
    ["moneybg"] = {["varname"] = "moneyBtn"}
}

UserInfoView.exchangeCoin = 0;
UserInfoView.totalChangCoin = 0;


--在最后IOS和Lua做交互
function UserInfoView:onCreate(data)
    printInfo("UserInfoView:onCreate")
    local saveGold = getSaveValue(1,"cost_gold")
    if saveGold then
    self.totalChangCoin= saveGold;
    end

    --add coins
    self.moneyBtn:addClickEventListener(function(sender)
        if self.exchangeCoin < self.totalChangCoin then
            print("showJob",self.exchangeCoin)
            print("showJob1",self.totalChangCoin)
            self.exchangeCoin = self.exchangeCoin +1
            self.money:setText(tostring(self.exchangeCoin))
        else
            showTip("Your Coin up to limited")
        end
    end)
    self.btnDeposit:addClickEventListener(function(sender)
        print("info","btnDeposit")

        if device.platform == "android" then
            local luaj = require "cocos.cocos2d.luaj";
            local className = "com/yfsd/game/fish/AppActivity";
            local sigs = "(Ljava/lang/String;)Ljava/lang/String;"
            luaj.callStaticMethod(className,"showUserInfo",{""},sigs)

        elseif device.platform == "ios" then
            --limit click to change it
            
            --make tmp value to send 10 coins To web
            local param = {totalCoin=tostring(self.totalChangCoin),exchanCoin=tostring(self.exchangeCoin)}
            --game Communicate with OC
            local luaoc = require "cocos.cocos2d.luaoc";
            luaoc.callStaticMethod("ZSExchangePlanformCenter", "SendCoinToMD5", param)
            self:removeFromParent()
        end
    end)


end


return UserInfoView
