//
//  ZLCollectionViewDelegateManager.m
//  ZhenLearnDriving_Coach
//
//  Created by 刘聪 on 2019/4/3.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "ZLCollectionViewDelegateManager.h"
#import "ZLCollectionViewSectionModel.h"

@interface ZLCollectionViewDelegateManager ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *datas;

@end

@implementation ZLCollectionViewDelegateManager

- (void)setCollectionView:(UICollectionView *)collectionView {
    _collectionView = collectionView;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(registerCellNibs:)]) {
            NSArray *array = [self.delegate registerCellNibs:self];
            [array enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [collectionView registerNib:[UINib nibWithNibName:obj bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:obj];
            }];
        }
        if ([self.delegate respondsToSelector:@selector(registerCellClassNames:)]) {
            NSArray *array = [self.delegate registerCellClassNames:self];
            [array enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [collectionView registerClass:NSClassFromString(obj) forCellWithReuseIdentifier:obj];
            }];
        }
        if ([self.delegate respondsToSelector:@selector(registerHeaderNibs:)]) {
            NSArray *array = [self.delegate registerHeaderNibs:self];
            [array enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [collectionView registerNib:[UINib nibWithNibName:obj bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:obj];
            }];
        }
        if ([self.delegate respondsToSelector:@selector(registerHeaderClassNames:)]) {
            NSArray *array = [self.delegate registerHeaderClassNames:self];
            [array enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [collectionView registerClass:NSClassFromString(obj) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:obj];
            }];
        }
        if ([self.delegate respondsToSelector:@selector(registerFooterrNibs:)]) {
            NSArray *array = [self.delegate registerFooterrNibs:self];
            [array enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [collectionView registerNib:[UINib nibWithNibName:obj bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:obj];
            }];
        }
        if ([self.delegate respondsToSelector:@selector(registerFooterClassNames:)]) {
            NSArray *array = [self.delegate registerFooterClassNames:self];
            [array enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [collectionView registerClass:NSClassFromString(obj) forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:obj];
            }];
        }
    }
    //默认注册
    [collectionView registerClass:NSClassFromString(@"UICollectionReusableView") forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView"];
    [collectionView registerClass:NSClassFromString(@"UICollectionReusableView") forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataSource:)]) {
        self.datas = [self.delegate dataSource:self];
    }
    [collectionView reloadData];
}


- (void)reloadData {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataSource:)]) {
        self.datas = [self.delegate dataSource:self];
    }
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.datas.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    ZLCollectionViewSectionModel *sectionModel = self.datas[section];
    return sectionModel.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZLCollectionViewSectionModel *sectionModel = self.datas[indexPath.section];
    ZLCollectionViewRowModel *rowModel = sectionModel.items[indexPath.row];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:rowModel.identifier forIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(model)] && rowModel.data) {
        [cell setValue:rowModel.data forKey:@"model"];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    ZLCollectionViewSectionModel *sectionModel = self.datas[indexPath.section];
    if (sectionModel.headerIdentifier) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionModel.headerIdentifier forIndexPath:indexPath];
        if ([view respondsToSelector:@selector(model)] && sectionModel.headerData) {
            [view setValue:sectionModel.headerData forKey:@"model"];
        }
        return view;
    }
    if (sectionModel.footerIdentifier) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:sectionModel.headerIdentifier forIndexPath:indexPath];
        if ([view respondsToSelector:@selector(model)] && sectionModel.footerData) {
            [view setValue:sectionModel.footerData forKey:@"model"];
        }
        return view;
    }
    return nil;
}



#pragma mark <UICollectionViewDelegate>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZLCollectionViewSectionModel *sectionModel = self.datas[indexPath.section];
    ZLCollectionViewRowModel *rowModel = sectionModel.items[indexPath.row];
    return rowModel.cellSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    ZLCollectionViewSectionModel *sectionModel = self.datas[section];
    return sectionModel.insets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    ZLCollectionViewSectionModel *sectionModel = self.datas[section];
    return sectionModel.minimumLineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    ZLCollectionViewSectionModel *sectionModel = self.datas[section];
    return sectionModel.minimumInteritemSpacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    ZLCollectionViewSectionModel *sectionModel = self.datas[section];
    return sectionModel.headerSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    ZLCollectionViewSectionModel *sectionModel = self.datas[section];
    return sectionModel.footerSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZLCollectionViewSectionModel *sectionModel = self.datas[indexPath.section];
    ZLCollectionViewRowModel *rowModel = sectionModel.items[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectRowAtModel:manager:)]) {
        [self.delegate didSelectRowAtModel:rowModel manager:self];
    }
}

@end
