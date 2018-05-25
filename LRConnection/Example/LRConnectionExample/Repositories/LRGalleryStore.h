//
//  LRGalleryStore.h
//  LRConnectionDemo
//
//  Created by Ruan Lingqi on 23/05/18.
//  Copyright © 2018年 tomrlq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class LRGalleryItem;

@interface LRGalleryStore : NSObject

+ (LRGalleryStore *)sharedStore;

- (void)fetchRecentPhotosWithCompletion:(void (^)(NSArray *galleryItems, NSError *error))completion;

- (void)fetchImageForGalleryItem:(LRGalleryItem *)galleryItem
                      completion:(void (^)(UIImage *image, NSError *error))completion;

@end
