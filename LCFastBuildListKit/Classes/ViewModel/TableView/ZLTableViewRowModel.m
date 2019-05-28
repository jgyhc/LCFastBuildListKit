//
//  ZLTableViewRowModel.m
//  ZhenLearnDriving_Coach
//
//  Created by 刘聪 on 2019/4/3.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "ZLTableViewRowModel.h"

@implementation ZLTableViewRowModel


- (id)copyWithZone:(nullable NSZone *)zone {
    ZLTableViewRowModel *model = [[[self class] allocWithZone:zone] init];
    model.identifier = _identifier;
    model.data = _data;
    model.cellHeight = _cellHeight;
    return model;
}


@end
