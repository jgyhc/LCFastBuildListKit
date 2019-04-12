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
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(registerCellNibs:)]) {
            NSArray *array = [self.delegate registerCellNibs:self];
            [array enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [tableView registerNib:[UINib nibWithNibName:obj bundle:[NSBundle mainBundle]] forCellReuseIdentifier:obj];
            }];
        }
        if ([self.delegate respondsToSelector:@selector(registerCellClassNames:)]) {
            NSArray *array = [self.delegate registerCellClassNames:self];
            [array enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [tableView registerClass:NSClassFromString(obj) forCellReuseIdentifier:obj];
            }];
        }
        if ([self.delegate respondsToSelector:@selector(registerHeaderFooterNibs:)]) {
            NSArray *array = [self.delegate registerHeaderFooterNibs:self];
            [array enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [tableView registerNib:[UINib nibWithNibName:obj bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:obj];
            }];
        }
        if ([self.delegate respondsToSelector:@selector(registerHeaderFooterClassNames:)]) {
            NSArray *array = [self.delegate registerHeaderFooterClassNames:self];
            [array enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [tableView registerClass:NSClassFromString(obj) forHeaderFooterViewReuseIdentifier:obj];
            }];
        }
    }
    [self reloadData];
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellInitializeWithModel:cell:manager:)]) {
        [self.delegate cellInitializeWithModel:rowModel cell:cell manager:self];
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectRowAtModel:manager:)]) {
        [self.delegate didSelectRowAtModel:rowModel manager:self];
    }
}

@end
