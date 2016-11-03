//
//  ZSExchangePlanformCenter.m
//  FishGame
//
//  Created by ZEUS on 16/10/27.


#import "ZSExchangePlanformCenter.h"
//为了给控制器的block值进行操作
#import "AppController.h"
#import "ControlView.h"
#import "CCLuaBridge.h"
#import "CCLuaEngine.h"


#define ExchangeCoin @"exchanCoin1"
#define TotalCoin @"total"
@implementation ZSExchangePlanformCenter
    //传过来的字典,然后进行访问
+ (void) SendCoinToMD5:(NSDictionary *)idInfo
{
    //做数据处理判断
    NSString *coin = [idInfo objectForKey:ExchangeCoin];
    if (!coin || [coin length] == 0)
    {
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        CFStringRef string = CFUUIDCreateString(NULL, theUUID);
        CFRelease(theUUID);
        coin = [(NSString *)string autorelease];
    }
    
    NSString *totalcoin = [idInfo objectForKey:TotalCoin];
    if (!totalcoin || [totalcoin length] == 0)
    {
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        CFStringRef string = CFUUIDCreateString(NULL, theUUID);
        CFRelease(theUUID);
        totalcoin = [(NSString *)string autorelease];
    }
    AppController *delegate = (AppController*)[UIApplication sharedApplication].delegate;
    NSLog(@"这个对象娶不到%p",delegate);
    //这里就是做的延时信息,这里是用的delegate的数据!
    delegate.myControlView.getH5Info = ^(NSString *info){
        //数据做处理,添加判断
        if ([info containsString:@"orderNum"]) {
            NSLog(@"这是回调的信息--->%@",info);
            cocos2d::LuaBridge::pushLuaFunctionById(handlerID); //压入需要调用的方法id
            cocos2d::LuaStack *stack = cocos2d::LuaBridge::getStack();  //获取lua栈
            NSString *dicStr =[NSString stringWithFormat:@"{token=\"%@\",roleid=\"%@\"}",token,idnum];
            
            stack->pushString([dicStr UTF8String]);
            stack->executeFunction(1);  //共有1个参数 (“oc传递给lua的参数”)，这里传参数 1
            cocos2d::LuaBridge::releaseLuaFunctionById(handlerID);
        }
    };

    //自己的而方法    
    [[ZSSDKManager shareZSSDKManager] sendToWeb:h5PersonUrl andTotalCoin:totalcoin andExCoin:coin];
    
    
    
}
@end
