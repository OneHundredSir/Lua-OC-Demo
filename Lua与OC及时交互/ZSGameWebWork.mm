//
//  ZSGameWebWork.m
//  FishGame
//
//  Created by ZEUS on 16/10/26.
//
//

#import "ZSGameWebWork.h"

//必须导入交互库
#import "CCLuaBridge.h"
#import "CCLuaEngine.h"
@implementation ZSGameWebWork

//================回调的函数名称,请自己看lua==============//
#define LoginAccount @"acc11"
#define LoginPWD @"pass11"

//这都是回调名称罢了
#define GameCallBack @"callback11"

#pragma mark - 数据部分
//测试账号:wanghengjie  密码:123456
+ (NSDictionary *) loginForGame:(NSDictionary *)idInfo
{
    //解析账号信息
    NSString *account = [idInfo objectForKey:LoginAccount];
    if (!account || [account length] == 0)
    {
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        CFStringRef string = CFUUIDCreateString(NULL, theUUID);
        CFRelease(theUUID);
        account = [(NSString *)string autorelease];
    }
    
    //解析账号信息
    NSString *password = [idInfo objectForKey:LoginPWD];
    if (!password || [password length] == 0)
    {
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        CFStringRef string = CFUUIDCreateString(NULL, theUUID);
        CFRelease(theUUID);
        password = [(NSString *)string autorelease];
    }
    NSLog(@"👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽");
//根据自己需要存储信息
    [[NSUserDefaults standardUserDefaults] setObject:account forKey:LoginAccount];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:LoginPWD];

    
//这部分可以忽略,也可以不用,主要是处理block的信息,如果涉及到block的话建议这样操作
    ZSGameWebWork *instance = [[self alloc]init];
    __block BOOL isFinishWeb = YES;
    instance.LoginDic = @{};
    __strong ZSGameWebWork *weakSelf = instance;
    
    int handlerID = (int)[[idInfo objectForKey:GameCallBack] integerValue];  // lua传输过来的回调lua的方法名  取inergerValue    这里可以将该id缓存在oc层的一个全局变量中  在合适的位置再回调lua层
    
    
//    这里是登录的接口
    [[ZSSDKManager shareZSSDKManager] zs_blockforloginWithAccount:account
                                         AndPassword:password
                                        andDataBlock:^(NSString *idnum) {
                                            
                                            cocos2d::LuaBridge::pushLuaFunctionById(handlerID); //压入需要调用的方法id
                                            cocos2d::LuaStack *stack = cocos2d::LuaBridge::getStack();  //获取lua栈
                                            
                                            //这是传字典值传过去(不建议,建议还是之间传字符串)
//                                            cocos2d::LuaValueDict item;
                                            //注意这里需要把OC字符串转C字符串
//                                            item["token"] = cocos2d::LuaValue::stringValue([token UTF8String]);
//                                            item["roleid"] = cocos2d::LuaValue::stringValue([numStr UTF8String]);
//                                            stack->pushLuaValueDict(item);
//                                            stack->pushString("oc传递给lua的参数");  //将需要传递给lua层的参数通过栈传递
                                            
                                            NSString *dicStr =[NSString stringWithFormat:@"{token=\"%@\"}",idnum];
                                            stack->pushString([dicStr UTF8String]);
                                            stack->executeFunction(1);  //共有1个参数 (“oc传递给lua的参数”)，这里传参数 1
                                            cocos2d::LuaBridge::releaseLuaFunctionById
                                            isFinishWeb = NO;
//                                            weakSelf.LoginDic = @{@"token":idnum} ;
//                                            NSLog(@"这是最后拼接的数据1\n%@",weakSelf.LoginDic);
    }];
    
    
    return instance.LoginDic;
}


@end
