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
    //默认注册
    [collectionView registerClass:NSClassFromString(@"UICollectionReusableView") forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView"];
    [collectionView registerClass:NSClassFromString(@"UICollectionReusableView") forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    [self reloadData];
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
    if ([cell respondsToSelector:@selector(delegate)] && rowModel.delegate) {
        [cell setValue:rowModel.delegate forKey:@"delegate"];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellInitializeWithModel:cell:manager:indexPath:)]) {
        [self.delegate cellInitializeWithModel:rowModel cell:cell manager:self indexPath:indexPath];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidScroll:manager:)]) {
        [self.delegate scrollViewDidScroll:scrollView manager:self];
    }
}

@end
