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

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath __attribute((deprecated("建议使用下面这个👇")));

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)cellInitializeWithModel:(ZLTableViewRowModel *)model cell:(UITableViewCell *)cell manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView manager:(ZLTableViewDelegateManager *)manager;

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section;
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section;
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath;
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section;
- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section;


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface ZLTableViewDelegateManager : NSObject

@property (nonatomic, weak) id<ZLTableViewDelegateManagerDelegate> delegate;

@property (nonatomic, strong) UITableView *tableView;

/**
 调此方法会调一次数据源的代理方法
 */
- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
