//
//  LRConnectionDataDelegate.h
//  LRConnection
//
//  Created by Ruan Lingqi on 13/01/18.
//  Copyright © 2018年 tomrlq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRConnectionManager.h"

@interface LRConnectionDataDelegate : NSObject <NSURLSessionDataDelegate>

@property (nonatomic, readonly) LRHTTPMethod httpMethod;

- (instancetype)initWithHTTPMethod:(LRHTTPMethod)httpMethod;

/// add callback to delegate
- (void)addProgress:(LRConnectionProgressBlock)progressBlock
            success:(LRConnectionSuccessBlock)successBlock
            failure:(LRConnectionFailureBlock)failureBlock;

@end
