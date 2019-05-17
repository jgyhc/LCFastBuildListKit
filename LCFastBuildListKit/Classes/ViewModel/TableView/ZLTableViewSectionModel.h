//
//  ZLTableViewSectionModel.h
//  ZhenLearnDriving_Coach
//
//  Created by 刘聪 on 2019/4/3.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLTableViewRowModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZLTableViewSectionModel : NSObject

@property (nonatomic, copy) NSString *headerIdentifier;

@property (nonatomic, copy) NSString *footerIdentifier;

@property (nonatomic, strong) NSArray<ZLTableViewRowModel *> *items;

@property (nonatomic, strong) id headerData;

@property (nonatomic, strong) id footerData;

@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, assign) CGFloat footerHeight;

@property (nonatomic, weak) id headerDelegate;



@end

NS_ASSUME_NONNULL_END
