//
//  ZSGameWebWork.h
//  FishGame
//
//  Created by ZEUS on 16/10/26.
//
//

#import <Foundation/Foundation.h>

@interface ZSGameWebWork : NSObject

@property(nonatomic,strong)NSDictionary *LoginDic;
@property(nonatomic,strong)NSDictionary *RegisterDic;

//登录按钮 进行数据请求  Lua交互
+ (NSDictionary *) loginForGame:(NSDictionary *)idInfo;


//注册按钮 进行数据请求  Lua交互
+ (NSDictionary *) RegiesterForGame:(NSDictionary *)idInfo;



@end
