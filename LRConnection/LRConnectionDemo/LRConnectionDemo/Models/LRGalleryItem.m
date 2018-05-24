//
//  LRGalleryItem.m
//  LRConnectionDemo
//
//  Created by Ruan Lingqi on 23/05/18.
//  Copyright © 2018年 tomrlq. All rights reserved.
//

#import "LRGalleryItem.h"

@implementation LRGalleryItem

- (instancetype)initWithJSON:(NSDictionary *)jsonDict {
    self = [super init];
    if (self) {
        _itemID = jsonDict[@"id"];
        _caption = jsonDict[@"title"];
        _owner = jsonDict[@"owner"];
        _imageUrl = jsonDict[@"url_s"];
    }
    return self;
}

@end
