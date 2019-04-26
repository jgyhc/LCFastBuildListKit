# LCFastBuildListKit

[![CI Status](https://img.shields.io/travis/jgyhc/LCFastBuildListKit.svg?style=flat)](https://travis-ci.org/jgyhc/LCFastBuildListKit)
[![Version](https://img.shields.io/cocoapods/v/LCFastBuildListKit.svg?style=flat)](https://cocoapods.org/pods/LCFastBuildListKit)
[![License](https://img.shields.io/cocoapods/l/LCFastBuildListKit.svg?style=flat)](https://cocoapods.org/pods/LCFastBuildListKit)
[![Platform](https://img.shields.io/cocoapods/p/LCFastBuildListKit.svg?style=flat)](https://cocoapods.org/pods/LCFastBuildListKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

LCFastBuildListKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LCFastBuildListKit'
```

## Author

jgyhc, jgyhc@foxmail.com.com

## License

LCFastBuildListKit is available under the MIT license. See the LICENSE file for more info.
# LCFastBuildListKit

[![CI Status](https://img.shields.io/travis/jgyhc/LCFastBuildListKit.svg?style=flat)](https://travis-ci.org/jgyhc/LCFastBuildListKit)
[![Version](https://img.shields.io/cocoapods/v/LCFastBuildListKit.svg?style=flat)](https://cocoapods.org/pods/LCFastBuildListKit)
[![License](https://img.shields.io/cocoapods/l/LCFastBuildListKit.svg?style=flat)](https://cocoapods.org/pods/LCFastBuildListKit)
[![Platform](https://img.shields.io/cocoapods/p/LCFastBuildListKit.svg?style=flat)](https://cocoapods.org/pods/LCFastBuildListKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

LCFastBuildListKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LCFastBuildListKit'
```

## Author

jgyhc, jgyhc@foxmail.com

## License

LCFastBuildListKit is available under the MIT license. See the LICENSE file for more info.



### 这个库是干嘛的？（大佬请绕行）

我们在平时的开发中是否有遇到过这样的界面需求，当前界面元素非常多，种类多，常见的视图处理方案便是使用`UITableView`或者`UICollectionView`去实现，于是我们就在我们本身就臃肿的`ViewController`里开始写`UITableView`的`delegate`和`dataSource`方法了，然后我们就可能会看到`tableView:cellForRowAtIndexPath:`方法里的代码如下：

```objective-c

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 0) {
        if (indexPath.row == 0) {
            OrderHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderHeaderCell"];
            cell.status = self.data.State;
            return cell;
        } else {
            FBGroupPurchaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FBGroupPurchaseCell"];
            cell.list = self.productList;
            return cell;
        }
    } else if (section == 2) {
        
        NSArray *arr = self.resultArr[0];
        if (arr.count == 0) {
            VouchersWaitPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VouchersWaitPayCell"];
            return cell;
        } else {
            OrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderInfoCell"];
            cell.model = arr[indexPath.row];
            return cell;
        }
    } else if (section == 1) {
        OrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderInfoCell"];
        return cell;
    } else {
        OrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderInfoCell"];
        NSArray *arr = self.resultArr[section - 2];
        cell.model = arr[indexPath.row];
        if (section == 3 && indexPath.row == arr.count - 1) {
            [cell addline];
        }
        return cell;
    }
    
}
```

然后`tableView:heightForRowAtIndexPath:`方法下可能就是

```objective-c

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 0) {
        if (indexPath.row == 0) {
            return 60;
        } else {
            return 105;
        }
    } else if (section == 1) {
        return 0;
    } else if (section == 2){
        NSArray *arr = self.resultArr[0];
        if (arr.count > 0) {
            return 30;
        } else {
            return 110;
        }
    } else {
        return 30;
    }
}
```

对于业务改动不大的场景来说无可厚非，一旦需要在页面中新增一个`Cell`的时候，缺点一下就出来了，这个时候发现需要改的的地方好像略多了，需要去更改`tableView:numberOfRowsInSectio:n`、`tableView:cellForRowAtIndexPath:`等方法，而且原来对应的`indexPath`全都不适用了。

然后呢我就思考了一下，有没有比较好的方式来控制这种方式，让我在以后的维护的时候，少做这样的修改呢？

于是乎，我做过往`tableView`的数据源里装`identifier`来区分`cell`，这样我不再去考虑因为`Cell`顺序改变带来的会很大程度影响我之前写的代码。但是后来发现还是不够，我们还是需要在`tableView:cellForRowAtIndexPath:`或者`tableView:heightForRowAtIndexPath:`写大量的判断逻辑。

为了解决上面的尴尬，我就想封装了一下`UITableView`和`UICollectionView`的代理方法，统一了对`TableViewCell`、`CollectionViewCell`、`TableViewHeaderView`等的描述：

`TableViewCell`：

```objective-c
@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) id data;
```

`CollectionViewCell`:

```objective-c
@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, assign) CGSize cellSize;

@property (nonatomic, strong) id data;
```

`TableView`的组：

```objective-c
@property (nonatomic, copy) NSString *headerIdentifier;

@property (nonatomic, copy) NSString *footerIdentifier;

@property (nonatomic, strong) NSArray<ZLTableViewRowModel *> *items;

@property (nonatomic, strong) id headerData;

@property (nonatomic, strong) id footerData;

@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, assign) CGFloat footerHeight;
```

`CollectionView`的组：

```objective-c

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
```



看到这里大家应该都知道我在做什么了吧。。。。虽然不高级，但是用起来真的方便很多了。

统一`Cell`的赋值方式和注册方式:

```objective-c
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rowModel.identifier forIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(model)] && rowModel.data) {
        [cell setValue:rowModel.data forKey:@"model"];
    }
```

对的，`Cell`就靠`model`接收传值。









