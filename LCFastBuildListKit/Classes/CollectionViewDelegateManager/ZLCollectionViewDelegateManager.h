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
//为了方便identifier 都和cllasName  一致
- (NSArray<NSString *> *)registerCellNibs:(ZLCollectionViewDelegateManager *)manager;

- (NSArray<NSString *>  *)registerCellClassNames:(ZLCollectionViewDelegateManager *)manager;

- (NSArray<NSString *>  *)registerHeaderNibs:(ZLCollectionViewDelegateManager *)manager;

- (NSArray<NSString *>  *)registerHeaderClassNames:(ZLCollectionViewDelegateManager *)manager;

- (NSArray<NSString *>  *)registerFooterrNibs:(ZLCollectionViewDelegateManager *)manager;

- (NSArray<NSString *>  *)registerFooterClassNames:(ZLCollectionViewDelegateManager *)manager;

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
