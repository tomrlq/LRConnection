//
//  LRConnectionManager.h
//  LRConnection
//
//  Created by Ruan Lingqi on 13/01/18.
//  Copyright © 2018年 Suntoyo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LRHTTPMethod) {
    LRHTTPMethodGET,
    LRHTTPMethodPOST,
};

typedef void(^LRConnectionProgressBlock)(NSProgress *_Nonnull progress);    // progress callback
typedef void(^LRConnectionSuccessBlock)(NSData *_Nonnull data);             // success callback
typedef void(^LRConnectionFailureBlock)(NSError *_Nonnull error);           // failure callback

/**
 A singleton with convenience methods for making HTTP requests
 */
@interface LRConnectionManager : NSObject

/// singleton
+ (nonnull LRConnectionManager *)sharedManager;

/// start URL request
- (void)requestURL:(nonnull NSString *)url
            method:(LRHTTPMethod)method
            params:(nullable NSDictionary *)params
          progress:(nullable LRConnectionProgressBlock)progressBlock
           success:(nullable LRConnectionSuccessBlock)successBlock
           failure:(nullable LRConnectionFailureBlock)failureBlock;

@end
