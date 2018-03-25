//
//  LNPageTitleView.m
//  LNPageScrollDemo
//
//  Created by Mr.lai on 2018/3/25.
//  Copyright © 2018年 Mr.lai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageTitleModel : NSObject
@property (nonatomic,copy)NSString *norStr;
@property (nonatomic,copy)NSString *selectedStr;
//默认为黑色
@property (nonatomic,strong)UIColor *norColor;
//默认为红色
@property (nonatomic,strong)UIColor *selectedColor;
//默认为字体大小为14
@property (nonatomic,strong)UIFont *afont;

- (id)initWithNorStr:(NSString *)norStr;
@end

@interface LNPageTitleView : UIView

- (id)initWithTitleConfigs:(NSArray <PageTitleModel *>*)titles clikBlock:(void(^)(UIButton *,NSInteger))clikBlock;
//最左边间距，默认15
@property (nonatomic,assign)CGFloat leftGap;
//最右边间距，默认15
@property (nonatomic,assign)CGFloat rightGap;
//两个标签之间的间距，默认50，如果个数计算出来没有超过屏幕，则按屏幕大小等分
@property (nonatomic,assign)CGFloat middleGap;

//把这个方法提出外面来，是为了以后增加配置的时候，子类只需要重写此方法调super即可，一定程度上保持了对修改关闭的原则
- (UIButton *)createButtonWithConfig:(PageTitleModel *)model index:(NSInteger)index;
- (void)buttonClikAction:(UIButton *)sender;
- (void)animationWithSelectedIndex:(NSInteger)index;
- (void)lineViewScrollOffset:(CGFloat)offset;

@end
