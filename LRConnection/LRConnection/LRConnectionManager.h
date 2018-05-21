//
//  LRConnectionManager.h
//  LRConnection
//
//  Created by Ruan Lingqi on 13/01/18.
//  Copyright © 2018年 tomrlq. All rights reserved.
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
 * 'LRConnectionManager' have convenience methods for making HTTP requests
 */
@interface LRConnectionManager : NSObject

/// singleton
+ (nonnull LRConnectionManager *)sharedManager;

/**
 Creates and runs a HTTP request
 
 @param url             The URL string used in the request
 @param method          The HTTP method to use
 @param params          The parameters to be encoded in the request.
 @param progressBlock   Callback to receive progress update. It is called on the session queue
 @param successBlock    Callback to receive the final data. It is called on the main queue
 @param failureBlock    Callback to receive the error. It is called on the main queue
 */
- (void)requestURL:(nonnull NSString *)url
            method:(LRHTTPMethod)method
            params:(nullable NSDictionary<NSString *, id> *)params
          progress:(nullable LRConnectionProgressBlock)progressBlock
           success:(nullable LRConnectionSuccessBlock)successBlock
           failure:(nullable LRConnectionFailureBlock)failureBlock;

@end
