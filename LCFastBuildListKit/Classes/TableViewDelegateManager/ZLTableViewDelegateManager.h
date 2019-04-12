//
//  ZLTableViewDelegateManager.h
//  ZhenLearnDriving_Coach
//
//  Created by 刘聪 on 2019/4/4.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZLTableViewSectionModel.h"

NS_ASSUME_NONNULL_BEGIN
@class ZLTableViewDelegateManager;
@protocol ZLTableViewDelegateManagerDelegate <NSObject>

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager;

@optional
//为了方便identifier 都和cllasName  一致
- (NSArray<NSString *> *)registerCellNibs:(ZLTableViewDelegateManager *)manager;

- (NSArray<NSString *> *)registerCellClassNames:(ZLTableViewDelegateManager *)manager;

- (NSArray<NSString *> *)registerHeaderFooterNibs:(ZLTableViewDelegateManager *)manager;

- (NSArray<NSString *> *)registerHeaderFooterClassNames:(ZLTableViewDelegateManager *)manager;

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager;

- (void)cellInitializeWithModel:(ZLTableViewRowModel *)model cell:(UITableViewCell *)cell manager:(ZLTableViewDelegateManager *)manager;

@end

@interface ZLTableViewDelegateManager : NSObject

@property (nonatomic, weak) id<ZLTableViewDelegateManagerDelegate> delegate;

@property (nonatomic, strong) UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
