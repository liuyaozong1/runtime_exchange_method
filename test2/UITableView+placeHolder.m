//
//  UITableView+placeHolder.m
//  test2
//
//  Created by liuyaozong on 2021/8/15.
//

#import "UITableView+placeHolder.h"
#import <objc/runtime.h>
#import <objc/message.h>
@interface UITableView ()


@end
@implementation UITableView (placeHolder)

+(void)load
{
    //保证只交换一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //原来的方法
        Method orginMethod = class_getInstanceMethod(self, @selector(reloadData));
        //现在的方法
        Method currentMethod = class_getInstanceMethod(self, @selector(currentReloadData));
        //方法交换
        method_exchangeImplementations(orginMethod, currentMethod);
    });

}

-(void)currentReloadData {
    //调用之前的方法  这个时候已经交换了,下面的代码实际上调用的是 reloadData
    [self currentReloadData];
    //设置 placeholder
    [self setDefalutView];
}

//设置 placeHolder 获取 section 和 row  进行一个判断
-(void)setDefalutView {
    id<UITableViewDataSource> dataSource = self.dataSource;
    NSInteger section = 0;
    if ([dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        section = [dataSource numberOfSectionsInTableView:self];
    } else {
        section = 1;
    }
    
    NSInteger rows = 0;
    for (NSInteger i = 0; i < section; i++) {
        NSInteger num = [dataSource tableView: self numberOfRowsInSection:section];
        if (num != 0) {
            rows = num;
        }
    }
    //如果是空的则添加
    if (!rows) {
        if (self.placeHolder && ![self.placeHolder isDescendantOfView:self]) {
            [self addSubview:self.placeHolder];
        }
        self.placeHolder.hidden = NO;
        self.placeHolder.frame = self.bounds;
    } else {
        if (self.placeHolder) {
            self.placeHolder.hidden = YES;
        }
    }
    
}

NSInteger num = 999;
    
//添加属性
-(UIView *)placeHolder
{
    return  objc_getAssociatedObject(self, &num);
}

-(void)setPlaceHolder:(UIView *)placeHolder
{
    objc_setAssociatedObject(self, &num, placeHolder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
