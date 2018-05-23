//
//  LRGalleryStore.m
//  LRConnectionDemo
//
//  Created by Ruan Lingqi on 23/05/18.
//  Copyright © 2018年 tomrlq. All rights reserved.
//

#import "LRGalleryStore.h"
#import "LRGalleryItem.h"
#import <LRConnection/LRConnection.h>

NSString * const EndPoint = @"https://api.flickr.com/services/rest";
NSString * const APIKey = @"a6d819499131071f158fd740860a5a88";
NSString * const FetchRecentsMethod = @"flickr.photos.getRecent";

@interface LRGalleryStore ()
{
    NSMutableArray *recentItems;
}
@end

@implementation LRGalleryStore

#pragma mark - Initialization

+ (LRGalleryStore *)sharedStore {
    static LRGalleryStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[super allocWithZone:NULL] init];
    });
    return sharedStore;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedStore];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        recentItems = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Networking

- (void)fetchRecentPhotosWithCompletion:(void (^)(NSArray *, NSError *))completion {
    if (recentItems.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion ? completion(recentItems, nil) : nil;
        });
        return;
    }
    NSDictionary *params = @{@"api_key" : APIKey,
                             @"format" : @"json",
                             @"nojsoncallback": @"1",
                             @"method" : FetchRecentsMethod};
    LRConnectionManager *manager = [LRConnectionManager sharedManager];
    [manager requestURL:EndPoint method:LRHTTPMethodGET params:params progress:nil success:^(NSData * _Nonnull data) {
        [self parseItems:recentItems fromJSON:data];
        completion ? completion(recentItems, nil) : nil;
    } failure:^(NSError * _Nonnull error) {
        completion ? completion(nil, error) : nil;
    }];
}

#pragma mark - Parse JSON Results

- (void)parseItems:(NSMutableArray *)items fromJSON:(NSData *)jsonData {
    [items removeAllObjects];
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                               options:0
                                                                 error:nil];
    NSArray *jsonArray = jsonObject[@"photos"][@"photo"];
    for (NSDictionary *jsonDict in jsonArray) {
        LRGalleryItem *item = [[LRGalleryItem alloc] initWithJSON:jsonDict];
        [items addObject:item];
    }
}

@end
