//
//  ZLTableViewRowModel.h
//  ZhenLearnDriving_Coach
//
//  Created by 刘聪 on 2019/4/3.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLTableViewRowModel : NSObject

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) id data;

@end

NS_ASSUME_NONNULL_END
