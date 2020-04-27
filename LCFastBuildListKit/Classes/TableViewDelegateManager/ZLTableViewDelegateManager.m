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
    [tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
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
    if ([cell respondsToSelector:@selector(delegate)] && rowModel.delegate) {
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
        return [tableView fd_heightForCellWithIdentifier:blockRowModel.identifier cacheByKey:rowModel configuration:^(id cell) {
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
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionModel.headerIdentifier?sectionModel.headerIdentifier:@"UITableViewHeaderFooterView"];
    if (sectionModel.headerBackgroundColor) {
        [view.contentView setBackgroundColor:sectionModel.headerBackgroundColor];
    }
    if ([view respondsToSelector:@selector(model)] && sectionModel.headerData) {
        [view setValue:sectionModel.headerData forKey:@"model"];
    }
    if ([view respondsToSelector:@selector(delegate)] && sectionModel.headerDelegate) {
        [view setValue:sectionModel.headerDelegate forKey:@"delegate"];
    }
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    ZLTableViewSectionModel *sectionModel = self.datas[section];
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionModel.footerIdentifier?sectionModel.footerIdentifier:@"UITableViewHeaderFooterView"];
    if (sectionModel.footerBackgroundColor) {
        if (!view) {
            view = [UIView new];
        }
        [view.contentView setBackgroundColor:sectionModel.footerBackgroundColor];
    }
    if ([view respondsToSelector:@selector(model)] && sectionModel.footerData) {
        [view setValue:sectionModel.footerData forKey:@"model"];
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }else {
        if (self.datas.count > indexPath.section) {
            ZLTableViewSectionModel *sectionModel = self.datas[indexPath.section];
            if (sectionModel.items.count > indexPath.row) {
                ZLTableViewRowModel *rowModel = sectionModel.items[indexPath.row];
                if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectRowAtModel:manager:indexPath:)]) {
                    [self.delegate didSelectRowAtModel:rowModel manager:self indexPath:indexPath];
                }
            }
        }
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

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZLTableViewSectionModel *sectionModel = self.datas[indexPath.section];
    ZLTableViewRowModel *rowModel = sectionModel.items[indexPath.row];
    return rowModel.deleteString ? rowModel.deleteString : @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    ZLTableViewSectionModel *sectionModel = self.datas[indexPath.section];
    ZLTableViewRowModel *rowModel = sectionModel.items[indexPath.row];
    return rowModel.isCanDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
        [self.delegate tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}


@end
