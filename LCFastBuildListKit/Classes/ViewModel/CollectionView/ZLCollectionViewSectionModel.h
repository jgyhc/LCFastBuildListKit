//
//  ZLCollectionViewSectionModel.h
//  ZhenLearnDriving_Coach
//
//  Created by 刘聪 on 2019/4/3.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZLCollectionViewRowModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZLCollectionViewSectionModel : NSObject

@property (nonatomic, copy) NSString *headerIdentifier;

@property (nonatomic, copy) NSString *footerIdentifier;

@property (nonatomic, strong) NSArray<ZLCollectionViewRowModel *> *items;

@property (nonatomic, strong) id headerData;

@property (nonatomic, strong) id footerData;

@property (nonatomic, assign) CGSize headerSize;

@property (nonatomic, assign) CGSize footerSize;

@property (nonatomic, assign) UIEdgeInsets insets;

@property (nonatomic, assign) CGFloat minimumLineSpacing;

@property (nonatomic, assign) CGFloat minimumInteritemSpacing;


@end

NS_ASSUME_NONNULL_END
