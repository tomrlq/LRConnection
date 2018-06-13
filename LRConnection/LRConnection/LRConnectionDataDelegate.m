//
//  LRConnectionDataDelegate.m
//  LRConnection
//
//  Created by Ruan Lingqi on 13/01/18.
//  Copyright © 2018年 tomrlq. All rights reserved.
//

#import "LRConnectionDataDelegate.h"

@interface LRConnectionDataDelegate ()
{
    NSMutableData *dataContainer;
    NSProgress *progress;
    NSMutableArray *progressBlocks;     // all progress callbacks
    NSMutableArray *successBlocks;      // all success callbacks
    NSMutableArray *failureBlocks;      // all failure callbacks
}
@end

@implementation LRConnectionDataDelegate

#pragma mark - Initialization

- (instancetype)initWithHTTPMethod:(LRHTTPMethod)method {
    self = [super init];
    if (self) {
        _httpMethod = method;
        dataContainer = [NSMutableData data];
        progress = [[NSProgress alloc] initWithParent:nil userInfo:nil];
        progress.totalUnitCount = NSURLSessionTransferSizeUnknown;
        progressBlocks = [NSMutableArray array];
        successBlocks = [NSMutableArray array];
        failureBlocks = [NSMutableArray array];
    }
    return self;
}

- (instancetype)init {
    return [self initWithHTTPMethod:LRHTTPMethodGET];
}

#pragma mark - Public Methods

- (void)addProgress:(LRConnectionProgressBlock)progressBlock success:(LRConnectionSuccessBlock)successBlock failure:(LRConnectionFailureBlock)failureBlock {
    progressBlock ? [progressBlocks addObject:[progressBlock copy]] : nil;
    successBlock ? [successBlocks addObject:[successBlock copy]] : nil;
    failureBlock ? [failureBlocks addObject:[failureBlock copy]] : nil;
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [dataContainer appendData:data];
    if (self.httpMethod == LRHTTPMethodGET) {
        progress.totalUnitCount = dataTask.countOfBytesExpectedToReceive;
        progress.completedUnitCount = dataTask.countOfBytesReceived;
        for (LRConnectionProgressBlock progressBlock in progressBlocks) {
            progressBlock(progress);
        }
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    if (self.httpMethod == LRHTTPMethodPOST) {
        progress.totalUnitCount = task.countOfBytesExpectedToSend;
        progress.completedUnitCount = task.countOfBytesSent;
        for (LRConnectionProgressBlock progressBlock in progressBlocks) {
            progressBlock(progress);
        }
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (!error) {
        int statusCode = (int)[(NSHTTPURLResponse *)task.response statusCode];
        int statusClass = statusCode / 100;
        if (statusClass == 4 || statusClass == 5) {
            NSString *localizedDescription = [[NSString alloc] initWithData:dataContainer encoding:NSUTF8StringEncoding];
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: localizedDescription,
                                       NSURLErrorFailingURLErrorKey: task.response.URL};
            error = [NSError errorWithDomain:@"LRConnection"
                                        code:NSURLErrorBadServerResponse
                                    userInfo:userInfo];
        }
    }
    if (!error) {
        for (LRConnectionSuccessBlock successBlock in successBlocks) {
            successBlock(dataContainer);
        }
    } else {
        for (LRConnectionFailureBlock failureBlock in failureBlocks) {
            failureBlock(error);
        }
    }
    progressBlocks = nil;
    successBlocks = nil;
    failureBlocks = nil;
}

@end
