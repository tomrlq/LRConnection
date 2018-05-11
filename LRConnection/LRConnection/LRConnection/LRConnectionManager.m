//
//  LRConnectionManager.m
//  LRConnection
//
//  Created by Ruan Lingqi on 13/01/18.
//  Copyright © 2018年 Suntoyo. All rights reserved.
//

#import "LRConnectionManager.h"
#import "LRConnectionDataDelegate.h"

@interface LRConnectionManager () <NSURLSessionDataDelegate>
{
    NSURLSession *urlSession;
    NSMutableDictionary *delegateCache;     // dictionary contains all delegates
}
@end

@implementation LRConnectionManager

#pragma mark - Initialization

+ (LRConnectionManager *)sharedManager {
    static LRConnectionManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[super allocWithZone:NULL] init];
    });
    return sharedManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedManager];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        delegateCache = [NSMutableDictionary dictionary];
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        sessionConfig.HTTPCookieStorage = nil;
        urlSession = [NSURLSession sessionWithConfiguration:sessionConfig
                                                   delegate:self
                                              delegateQueue:nil];
    }
    return self;
}

#pragma mark - Public Methods

- (void)requestURL:(NSString *)URLString HTTPMethod:(LRHTTPMethod)httpMethod parameters:(NSDictionary *)parameters progress:(LRConnectionProgressBlock)progressBlock success:(LRConnectionSuccessBlock)successBlock failure:(LRConnectionFailureBlock)failureBlock
{
    NSURLRequest *request = [self requestWithURL:URLString HTTPMethod:httpMethod parameters:parameters];
    LRConnectionDataDelegate *delegate = delegateCache[request];
    if (!delegate) {
        delegate = [[LRConnectionDataDelegate alloc] initWithHTTPMethod:httpMethod];
        [delegate addProgress:progressBlock success:successBlock failure:failureBlock];
        delegateCache[request] = delegate;
        NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request];
        [dataTask resume];
    } else {
        [delegate addProgress:progressBlock success:successBlock failure:failureBlock];
    }
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    id<NSURLSessionTaskDelegate> delegate = delegateCache[task.originalRequest];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [delegate URLSession:session task:task didCompleteWithError:error];
        [delegateCache removeObjectForKey:task.originalRequest];
    }];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    id<NSURLSessionTaskDelegate> delegate = delegateCache[task.originalRequest];
    [delegate URLSession:session task:task didSendBodyData:bytesSent totalBytesSent:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
        NSURLCredential *cred = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, cred);
    }
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    LRConnectionDataDelegate *delegate = delegateCache[dataTask.originalRequest];
    [delegate URLSession:session dataTask:dataTask didReceiveData:data];
}

#pragma mark - Request Serialization

- (NSURLRequest *)requestWithURL:(NSString *)URLString HTTPMethod:(LRHTTPMethod)httpMethod parameters:(NSDictionary *)parameters {
    switch (httpMethod) {
        case LRHTTPMethodGET: {
            NSString *queryString = [self queryStringFromParameters:parameters];
            NSString *requestString = [NSString stringWithFormat:@"%@?%@", URLString, queryString];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];
            return request;
        }
        case LRHTTPMethodPOST: {
            NSString *queryString = [self queryStringFromParameters:parameters];
            NSData *queryData = [queryString dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:queryData];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            return request;
        }
    }
}

- (NSString *)queryStringFromParameters:(NSDictionary *)parameters {
    NSMutableString *query = [NSMutableString string];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [query appendFormat:@"%@=%@&", [self escapedStringFromString:[key description]], [self escapedStringFromString:[obj description]]];
    }];
    if (query.length > 0) {
        [query deleteCharactersInRange:NSMakeRange([query length] - 1, 1)];
    }
    return query;
}

- (NSString *)escapedStringFromString:(NSString *)string {
    static NSString * const kCharactersToEncode = @":#[]@!$&'()*+,;=";
    NSMutableCharacterSet *allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:kCharactersToEncode];
    return [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
}

@end
