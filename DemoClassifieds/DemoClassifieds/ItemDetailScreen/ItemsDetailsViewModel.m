//
//  ItemsDetailsViewModel.m
//  DemoClassifieds
//
//  Created by Aravind on 11/12/2021.
//

#import "ItemsDetailsViewModel.h"
#import "ItemDetailsViewController.h"
#import "DemoClassifieds-Swift.h"
#import "ItemsDetailsViewModel.h"
#import <ImageCache/ImageCache.h>

NSString *const indexKeyInUserInfo = @"userInfo.indexKey";

@interface ItemsDetailsViewModel ()

@property (nonatomic, strong) ItemsDetailsViewModel *viewModel;
@property (nonatomic, copy) ItemsDetailsScreenUpdateBlock updateBlock;
@property (nonatomic, strong) NetworkService *networkService;
@property (nonatomic, weak) ItemDetailsViewController *itemDetailsScreen;
@end

@implementation ItemsDetailsViewModel

- (instancetype)initWith:(Item *)item {
    self = [super init];
    if (self) {
        _item = item;
    }
    return self;
}

- (NetworkService *)networkService {
    if (!_networkService) {
        _networkService = [[NetworkService alloc] init];
    }
    return _networkService;
}


- (void)bind:(ItemDetailsViewController *)view
 updateBlock:(ItemsDetailsScreenUpdateBlock)updateBlock {
    self.itemDetailsScreen = view;
    self.updateBlock = updateBlock;
}

- (void)post:(ItemsDetailsScreenUpdate)state
       error:(NSError *)error
    userInfo:(NSDictionary *)userInfo {
    __weak ItemsDetailsViewModel *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.updateBlock(state, error, userInfo);
    });
}

- (void)donefetchingImageAtIndex:(NSUInteger)index
                           image:(UIImage *)image
                           error:(NSError *)error {
    if (error) {
        [self post:ItemsDetailsScreenUpdateImageFetchFailed error:error userInfo:nil];
    }
    NSDictionary *userInfo = @{indexKeyInUserInfo : @(index)};
    NSString *imageId = [self.item fullImageIdWithIndex:index];
    [self.item setWithImage:image key:imageId];
    [self post:ItemsDetailsScreenUpdateImageFetchDone error:nil userInfo:userInfo];
}

- (void)fetchImageAtIndex:(NSUInteger)index {
    if (index >= [[self.item imageUrls] count] ) {
        return;
    }
    NSString *imageURL = [[self.item imageUrls] objectAtIndex:index];
    NSString *imageId = [self.item fullImageIdWithIndex:index];

    __weak ItemsDetailsViewModel *weakSelf = self;
    [self.networkService fetchImageDataWithId:imageId
                                          url:imageURL
                                   completion:^(UIImage *image, NSError *error) {
        [weakSelf donefetchingImageAtIndex:index image:image error:error];
    }];
}

- (NSString *)cacheURLForFullImageAtIndex:(NSUInteger)index {
    ImageCache *cache = [ImageCache sharedInstance];
    NSString *imageId = [self.item fullImageIdWithIndex:index];
    return [cache getImageCacheURLWithId:imageId];
}

- (void)clickedOnImageAtIndex:(NSUInteger)index {
    NSString *imageId = [self.item fullImageIdWithIndex:index];
    UIImage *image = [self.item.cachedImages objectForKey:imageId];
    if (!image) {
        image = [UIImage imageNamed:@"placeholder"];
    }
    ImagePreviewNavigator *navigator = [[ImagePreviewNavigator alloc] initWithNavigationController:self.itemDetailsScreen.navigationController
                                                                                             image:image];
    [navigator start];
}

@end
