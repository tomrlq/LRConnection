//
//  LRGalleryItem.h
//  LRConnectionDemo
//
//  Created by Ruan Lingqi on 23/05/18.
//  Copyright © 2018年 tomrlq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRGalleryItem : NSObject

@property (nonatomic, readonly, copy) NSString *itemID;
@property (nonatomic, readonly, copy) NSString *caption;
@property (nonatomic, readonly, copy) NSString *owner;
@property (nonatomic, readonly, copy) NSString *imageUrl;

- (instancetype)initWithJSON:(NSDictionary *)jsonDict;

@end
