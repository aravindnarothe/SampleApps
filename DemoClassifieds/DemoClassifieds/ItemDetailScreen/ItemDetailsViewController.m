//
//  ItemDetailsViewController.m
//  DemoClassifieds
//
//  Created by Aravind on 11/12/2021.
//

#import "ItemDetailsViewController.h"
#import "ItemsDetailsViewModel.h"
#import "DemoClassifieds-Swift.h"
#import "ItemDetailsCell.h"

@interface ItemDetailsViewController () <UICollisionBehaviorDelegate, UICollectionViewDataSource, UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) UIDocumentInteractionController *documentsInteractioController;

@end

@implementation ItemDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindViewModel];
    [self loadItemDataOnScreen];
    [self setupImageGallery];
}

- (void)loadItemDataOnScreen {
    self.title = self.viewModel.item.name;
    self.name.text = self.viewModel.item.name;
    self.price.text = self.viewModel.item.price;
    self.date.text = [NSString stringWithFormat:@"Posted on %@", self.viewModel.item.humanReadableDate];
}

- (void)setupImageGallery {
    self.imageGallery.collectionViewLayout = [self galleryLayout];
}

- (void)imageFetchDoneAtIndex:(NSUInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:index];
    [self.imageGallery reloadItemsAtIndexPaths:@[indexPath]];
}

- (void)bindViewModel {
    [self.viewModel bind:self
             updateBlock:^(ItemsDetailsScreenUpdate update, NSError *error, NSDictionary *userInfo) {
        switch (update) {
            case ItemsDetailsScreenUpdateImageFetchDone: {
                NSUInteger index = [[userInfo objectForKey:indexKeyInUserInfo] integerValue];
                [self imageFetchDoneAtIndex:index];
            }
                break;
                
            default:
                break;
        }
    }];
}

- (UICollectionViewCompositionalLayout *)galleryLayout {
    
    NSCollectionLayoutDimension *width = [NSCollectionLayoutDimension fractionalWidthDimension:1.0];
    NSCollectionLayoutDimension *height = [NSCollectionLayoutDimension fractionalHeightDimension:1.0];

    NSCollectionLayoutSize *itemLayoutSize = [NSCollectionLayoutSize sizeWithWidthDimension:width
                                                                            heightDimension:height];
    NSCollectionLayoutItem *eachImageItem = [NSCollectionLayoutItem itemWithLayoutSize:itemLayoutSize];
    
    NSCollectionLayoutGroup *galleryLayout = [NSCollectionLayoutGroup verticalGroupWithLayoutSize:itemLayoutSize
                                                                                          subitem:eachImageItem
                                                                                            count:1];
    
    NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:galleryLayout];
    section.orthogonalScrollingBehavior = UICollectionLayoutSectionOrthogonalScrollingBehaviorGroupPaging;
    
    UICollectionViewCompositionalLayout *layout = [[UICollectionViewCompositionalLayout alloc] initWithSection:section];
    return layout;
}

#pragma mark -
#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.item.imageUrls.count;
}

#pragma mark -
#pragma mark UICollectionViewDelegate

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ItemDetailsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemDetailsCell" forIndexPath:indexPath];
    NSString *imageId = [self.viewModel.item fullImageIdWithIndex:indexPath.row];
    UIImage *cachedImage = [self.viewModel.item.cachedImages objectForKey:imageId];
    if (cachedImage) {
        [cell setImage:cachedImage];
    } else {
        [self.viewModel fetchImageAtIndex:indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel clickedOnImageAtIndex:indexPath.row];
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}

@end
