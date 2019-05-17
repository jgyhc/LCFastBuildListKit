//
//  ZLTableViewDelegateManager.m
//  ZhenLearnDriving_Coach
//
//  Created by 刘聪 on 2019/4/4.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "ZLTableViewDelegateManager.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface ZLTableViewDelegateManager ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *datas;
@end

@implementation ZLTableViewDelegateManager

- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
}

- (void)reloadData {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataSource:)]) {
        self.datas = [self.delegate dataSource:self];
    }
    [self.tableView reloadData];
}

#pragma mark -- UITableViewDataSource method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ZLTableViewSectionModel *sectionModel = self.datas[section];
    return sectionModel.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZLTableViewSectionModel *sectionModel = self.datas[indexPath.section];
    ZLTableViewRowModel *rowModel = sectionModel.items[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rowModel.identifier forIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(model)] && rowModel.data) {
        [cell setValue:rowModel.data forKey:@"model"];
    }
    if ([cell respondsToSelector:@selector(delegate) && rowModel.delegate]) {
        [cell setValue:rowModel.delegate forKey:@"delegate"];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellInitializeWithModel:cell:manager:indexPath:)]) {
        [self.delegate cellInitializeWithModel:rowModel cell:cell manager:self indexPath:indexPath];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZLTableViewSectionModel *sectionModel = self.datas[indexPath.section];
    ZLTableViewRowModel *rowModel = sectionModel.items[indexPath.row];
    if (rowModel.cellHeight == -1) {
        __block ZLTableViewRowModel *blockRowModel = rowModel;
        return [tableView fd_heightForCellWithIdentifier:blockRowModel.identifier cacheByKey:indexPath configuration:^(id cell) {
            if ([cell respondsToSelector:@selector(model)] && blockRowModel.data) {
                [cell setValue:blockRowModel.data forKey:@"model"];
            }
        }];
    }
    return rowModel.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    ZLTableViewSectionModel *sectionModel = self.datas[section];
    return sectionModel.headerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    ZLTableViewSectionModel *sectionModel = self.datas[section];
    return sectionModel.footerHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ZLTableViewSectionModel *sectionModel = self.datas[section];
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionModel.headerIdentifier];
    if ([view respondsToSelector:@selector(model)] && sectionModel.headerData) {
        [view setValue:sectionModel.headerData forKey:@"model"];
    }
    if ([view respondsToSelector:@selector(delegate) && sectionModel.headerDelegate]) {
        [view setValue:sectionModel.headerDelegate forKey:@"delegate"];
    }
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    ZLTableViewSectionModel *sectionModel = self.datas[section];
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionModel.footerIdentifier];
    if ([view respondsToSelector:@selector(model)] && sectionModel.footerData) {
        [view setValue:sectionModel.footerData forKey:@"model"];
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZLTableViewSectionModel *sectionModel = self.datas[indexPath.section];
    ZLTableViewRowModel *rowModel = sectionModel.items[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectRowAtModel:manager:indexPath:)]) {
        [self.delegate didSelectRowAtModel:rowModel manager:self indexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
        [self.delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)]) {
        [self.delegate tableView:tableView willDisplayHeaderView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:willDisplayFooterView:forSection:)]) {
        [self.delegate tableView:tableView willDisplayFooterView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)]) {
        [self.delegate tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didEndDisplayingHeaderView:forSection:)]) {
        [self.delegate tableView:tableView didEndDisplayingHeaderView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didEndDisplayingFooterView:forSection:)]) {
        [self.delegate tableView:tableView didEndDisplayingFooterView:view forSection:section];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidScroll:manager:)]) {
        [self.delegate scrollViewDidScroll:scrollView manager:self];
    }
}

@end
