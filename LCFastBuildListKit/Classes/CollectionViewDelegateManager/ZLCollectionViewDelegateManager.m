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
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectRowAtModel:manager:indexPath:)]) {
        [self.delegate didSelectRowAtModel:rowModel manager:self indexPath:indexPath];
    }
}



//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:shouldHighlightItemAtIndexPath:)]) {
//        return [self.delegate collectionView:collectionView shouldHighlightItemAtIndexPath:indexPath];
//    }
//}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:didHighlightItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didHighlightItemAtIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:didUnhighlightItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didUnhighlightItemAtIndexPath:indexPath];
    }
}

//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:shouldSelectItemAtIndexPath:)]) {
//        return [self.delegate collectionView:collectionView shouldSelectItemAtIndexPath:indexPath];
//    }
//}
//
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:shouldDeselectItemAtIndexPath:)]) {
//        [self.delegate collectionView:collectionView shouldDeselectItemAtIndexPath:indexPath];
//    }
//}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:didDeselectItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath  {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:willDisplayCell:forItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:willDisplaySupplementaryView:forElementKind:atIndexPath:)]) {
        [self.delegate collectionView:collectionView willDisplaySupplementaryView:view forElementKind:elementKind atIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:didEndDisplayingCell:forItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didEndDisplayingCell:cell forItemAtIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:didEndDisplayingSupplementaryView:forElementOfKind:)]) {
        [self.delegate collectionView:collectionView didEndDisplayingSupplementaryView:view forElementOfKind:elementKind atIndexPath:indexPath];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidScroll:manager:)]) {
       [self.delegate scrollViewDidScroll:scrollView manager:self];
    }
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
           [self.delegate scrollViewDidZoom:scrollView];
       }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
           [self.delegate scrollViewWillBeginDragging:scrollView];
       }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
           [self.delegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
       }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
           [self.delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
       }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
           [self.delegate scrollViewWillBeginDecelerating:scrollView];
       }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
           [self.delegate scrollViewDidEndDecelerating:scrollView];
       }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
           [self.delegate scrollViewDidEndScrollingAnimation:scrollView];
       }
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
           [self.delegate scrollViewWillBeginZooming:scrollView withView:view];
       }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [self.delegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
       }
}


- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
           [self.delegate scrollViewDidScrollToTop:scrollView];
       }
}

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidChangeAdjustedContentInset:)]) {
           [self.delegate scrollViewDidChangeAdjustedContentInset:scrollView];
       }
}



@end
