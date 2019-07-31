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

- (void)didSelectRowAtModel:(ZLCollectionViewRowModel *)model manager:(ZLCollectionViewDelegateManager *)manager;

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
