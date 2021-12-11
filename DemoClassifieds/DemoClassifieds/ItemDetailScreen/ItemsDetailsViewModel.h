//
//  ItemsDetailsViewModel.h
//  DemoClassifieds
//
//  Created by Aravind on 11/12/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const indexKeyInUserInfo;

typedef NS_ENUM(NSInteger, ItemsDetailsScreenUpdate) {
    ItemsDetailsScreenUpdateImageFetchDone,
    ItemsDetailsScreenUpdateImageFetchFailed
};
typedef void(^ItemsDetailsScreenUpdateBlock) (ItemsDetailsScreenUpdate update, NSError *error, NSDictionary *userInfo);

@class ItemDetailsViewController, Item;

@interface ItemsDetailsViewModel : NSObject

@property (nonatomic, readonly) Item *item;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWith:(Item *)item NS_DESIGNATED_INITIALIZER;

- (void)bind:(ItemDetailsViewController *)view
 updateBlock:(ItemsDetailsScreenUpdateBlock)updateBlock;
- (void)fetchImageAtIndex:(NSUInteger)index;
- (NSString *)cacheURLForFullImageAtIndex:(NSUInteger)index;
- (void)clickedOnImageAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
