//
//  LRConnectionManager.h
//  LRConnection
//
//  Created by Ruan Lingqi on 13/01/18.
//  Copyright © 2018年 Suntoyo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    LRHTTPMethodGET,
    LRHTTPMethodPOST,
} LRHTTPMethod;

typedef void(^LRConnectionProgressBlock)(NSProgress *);     // progress callback
typedef void(^LRConnectionSuccessBlock)(NSData *data);      // success callback
typedef void(^LRConnectionFailureBlock)(NSError *error);    // failure callback

/**
 A singleton with convenience methods for making HTTP requests
 */
@interface LRConnectionManager : NSObject

/// singleton
+ (LRConnectionManager *)sharedManager;

/// start URL request
- (void)requestURL:(NSString *)URLString
        HTTPMethod:(LRHTTPMethod)httpMethod
        parameters:(NSDictionary *)parameters
          progress:(LRConnectionProgressBlock)progressBlock
           success:(LRConnectionSuccessBlock)successBlock
           failure:(LRConnectionFailureBlock)failureBlock;

@end
