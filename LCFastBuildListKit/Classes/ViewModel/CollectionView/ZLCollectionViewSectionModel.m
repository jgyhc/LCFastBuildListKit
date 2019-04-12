//
//  ZLCollectionViewSectionModel.m
//  ZhenLearnDriving_Coach
//
//  Created by 刘聪 on 2019/4/3.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "ZLCollectionViewSectionModel.h"

@interface ZLCollectionViewSectionModel ()

@end

@implementation ZLCollectionViewSectionModel

- (NSString *)headerIdentifier {
    if (!_headerIdentifier) {
        _headerIdentifier = @"UICollectionReusableView";
    }
    return _headerIdentifier;
}

- (NSString *)footerIdentifier {
    if (!_footerIdentifier) {
        _footerIdentifier = @"UICollectionReusableView";
    }
    return _footerIdentifier;
}

@end
