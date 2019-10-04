//
//  ZLCollectionViewDelegateManager.h
//  ZhenLearnDriving_Coach
//
//  Created by 刘聪 on 2019/4/3.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZLCollectionViewSectionModel.h"

NS_ASSUME_NONNULL_BEGIN


@class ZLCollectionViewDelegateManager;
@protocol ZLCollectionViewDelegateManagerDelegate <NSObject>

- (NSArray<ZLCollectionViewSectionModel *> *)dataSource:(ZLCollectionViewDelegateManager *)manager;

@optional

- (void)scrollViewDidScroll:(UIScrollView *)scrollView manager:(ZLCollectionViewDelegateManager *)manager;

- (void)cellInitializeWithModel:(ZLCollectionViewRowModel *)model cell:(UICollectionViewCell *)cell manager:(ZLCollectionViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath;

- (void)didSelectRowAtModel:(ZLCollectionViewRowModel *)model manager:(ZLCollectionViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;


//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath;
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath;
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath;
@end

@interface ZLCollectionViewDelegateManager : NSObject

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, weak) id<ZLCollectionViewDelegateManagerDelegate> delegate;

/**
 调此方法会调一次数据源的代理方法
 */
- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
