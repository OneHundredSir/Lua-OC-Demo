//
//  ZSExchangePlanformCenter.h
//  FishGame
//
//  Created by ZEUS on 16/10/27.
//
//

#import <Foundation/Foundation.h>
#import "ZSActionHeader.h"
@interface ZSExchangePlanformCenter : NSObject

    
//这个类是与lua做交互进行页面调到兑换!
+ (void) SendCoinToMD5:(NSDictionary *)idInfo;
    
@end
