//
//  LRPhotoGalleryViewController.m
//  LRConnectionDemo
//
//  Created by Ruan Lingqi on 23/05/18.
//  Copyright © 2018年 tomrlq. All rights reserved.
//

#import "LRPhotoGalleryViewController.h"
#import "LRGalleryItemCell.h"
#import "LRGalleryStore.h"
#import "LRGalleryItem.h"

@interface LRPhotoGalleryViewController ()
{
    NSArray *currentItems;
}
@end

@implementation LRPhotoGalleryViewController

#pragma mark - UITableViewController Overrides

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        currentItems = nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"LRConnection Demo";
    self.clearsSelectionOnViewWillAppear = NO;
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"LRGalleryItemCell" bundle:nil] forCellReuseIdentifier:@"LRGalleryItemCell"];
    [[LRGalleryStore sharedStore] fetchRecentPhotosWithCompletion:^(NSArray *galleryItems, NSError *error) {
        if (!error) {
            currentItems = galleryItems;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return currentItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LRGalleryItem *galleryItem = currentItems[indexPath.row];
    LRGalleryItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LRGalleryItemCell" forIndexPath:indexPath];
    [cell setGalleryItem:galleryItem];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

@end
