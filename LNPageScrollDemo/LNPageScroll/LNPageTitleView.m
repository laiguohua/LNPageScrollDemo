//
//  LNTestViewController.m
//  LNPageScrollDemo
//
//  Created by Mr.lai on 2018/3/25.
//  Copyright © 2018年 Mr.lai. All rights reserved.
//

#import "LNPageTitleView.h"

@implementation PageTitleModel
- (id)init{
    self = [super init];
    if(self){
        [self makeDefaultValue];
    }
    return self;
}
- (id)initWithNorStr:(NSString *)norStr{
    self = [super init];
    if(self){
        self.norStr = norStr;
        [self makeDefaultValue];
    }
    return self;
}

- (void)makeDefaultValue{
    self.afont = [UIFont systemFontOfSize:14];
    self.norColor = [UIColor blackColor];
    self.selectedColor = [UIColor redColor];
}

@end

@interface LNPageTitleView()

@property (nonatomic,strong)NSArray <PageTitleModel *>*allTitles;

@property (nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,assign)CGFloat allTitleLength;

@property (nonatomic,copy)void(^buttonClikBlock)(UIButton *,NSInteger);

@property (nonatomic,strong)UIView *bottomLineView;

@end

static NSString *pageMaxStr(PageTitleModel *model){
    return model.norStr.length > model.selectedStr.length?model.norStr:model.selectedStr;
}
static CGSize stringSize(PageTitleModel *model){
    // 计算文本的大小
    return [pageMaxStr(model) boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                        attributes:@{NSFontAttributeName:model.afont}        // 文字的属性
                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
}

@implementation LNPageTitleView

- (id)initWithTitleConfigs:(NSArray <PageTitleModel *>*)titles clikBlock:(void(^)(UIButton *,NSInteger))clikBlock{
    self = [super init];
    if(self){
        self.allTitles = [titles copy];
        self.buttonClikBlock = [clikBlock copy];
        self.leftGap = 15;
        self.rightGap = 15;
        self.middleGap = 50;
        [self prepareLayoutSubView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    CGFloat width = self.leftGap + self.rightGap + self.middleGap * (self.allTitles.count -1) + self.allTitleLength;
    //如果总长比本身视图还小，则修正间距，计算成等分
    if(width < CGRectGetWidth(self.frame)){
        self.middleGap = (CGRectGetWidth(self.frame) - self.leftGap - self.rightGap - self.allTitleLength) / (self.allTitles.count - 1);
    }
    CGFloat height = CGRectGetHeight(self.frame);
    __block UIView *tempBtn;
    __block UIButton *btn = [(UIButton *)self.scrollView viewWithTag:1000];
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[UIButton class]] && obj.tag >= 1000){
            NSInteger index = obj.tag - 1000;
            CGSize asize = stringSize(self.allTitles[index]);
            CGFloat originx = self.leftGap;
            CGFloat btnHeight = asize.height;
            btnHeight = btnHeight > 30?btnHeight:30;
            if(tempBtn){
                originx = tempBtn.frame.origin.x+tempBtn.frame.size.width + self.middleGap;
            }
            obj.frame = CGRectMake(originx, (height - btnHeight) / 2.0, asize.width, btnHeight);
            tempBtn = obj;
            UIButton *abtn = (UIButton *)obj;
            if(abtn.selected){
                btn = abtn;
            }
        }
    }];
    self.scrollView.contentSize = CGSizeMake(width, height);
    btn.selected = YES;
    self.bottomLineView.frame = CGRectMake(self.leftGap, height - 2, btn.frame.size.width, 2);
    CGPoint linePoint = self.bottomLineView.center;
    linePoint.x = btn.center.x;
    self.bottomLineView.center = linePoint;
}

- (void)prepareLayoutSubView{
    if(!self.allTitles || self.allTitles.count == 0) return;
    [self addSubview:self.scrollView];
    NSMutableString *muStr = [NSMutableString string];
    [self.allTitles enumerateObjectsUsingBlock:^(PageTitleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.scrollView addSubview:[self createButtonWithConfig:obj index:idx]];
        [muStr appendString:pageMaxStr(obj)];
    }];
    PageTitleModel *tempModel = [self.allTitles firstObject];
    // 计算文本的大小
    CGSize sizeToFit = [muStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                       attributes:@{NSFontAttributeName:tempModel.afont}        // 文字的属性
                                          context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    //计算出来了所有的文字所占的长度
    self.allTitleLength = sizeToFit.width;
    
    self.bottomLineView = [UIView new];
    self.bottomLineView.backgroundColor = tempModel.selectedColor?:[UIColor redColor];
    [self.scrollView addSubview:self.bottomLineView];
    
}

- (UIButton *)createButtonWithConfig:(PageTitleModel *)model index:(NSInteger)index{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 1000+index;
    if(model.afont){
        button.titleLabel.font = model.afont;
    }
    if(model.norColor){
        [button setTitleColor:model.norColor forState:UIControlStateNormal];
    }
    if(model.selectedColor){
        [button setTitleColor:model.selectedColor forState:UIControlStateSelected];
    }
    if(model.norStr){
        [button setTitle:model.norStr forState:UIControlStateNormal];
    }
    if(model.selectedStr){
        [button setTitle:model.selectedStr forState:UIControlStateSelected];
    }
    [button addTarget:self action:@selector(buttonClikAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)buttonClikAction:(UIButton *)sender{
    [self animationWithSelectedIndex:sender.tag - 1000];
    if(self.buttonClikBlock){
        self.buttonClikBlock(sender, sender.tag - 1000);
    }
}

- (void)animationWithSelectedIndex:(NSInteger)index{
    UIButton *btn = (UIButton *)[self.scrollView viewWithTag:1000+index];
    CGPoint point = btn.center;
    CGPoint linePoint = self.bottomLineView.center;
    linePoint.x = point.x;
    self.bottomLineView.center = linePoint;
    CGRect rect = self.bottomLineView.frame;
    rect.size.width =btn.frame.size.width;
    self.bottomLineView.frame = rect;

    CGFloat width = CGRectGetWidth(self.scrollView.frame);
    if(point.x > width / 2.0 &&  point.x < (self.scrollView.contentSize.width - width / 2.0)){
        [UIView animateWithDuration:.2 animations:^{
            [self.scrollView setContentOffset:CGPointMake(point.x - width / 2.0, 0)];
        }];
        
    }else if(point.x <= width / 2.0 ){
        [UIView animateWithDuration:.2 animations:^{
            [self.scrollView setContentOffset:CGPointZero];
        }];
    }else if(point.x >= (self.scrollView.contentSize.width - width / 2.0)){
        [UIView animateWithDuration:.2 animations:^{
            [self.scrollView setContentOffset:CGPointMake((self.scrollView.contentSize.width - width), 0)];
        }];
    }
    
    [UIView animateWithDuration:.2 delay:.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGAffineTransform t = CGAffineTransformMakeScale(1.1,1.1);
        btn.transform = t;
        btn.selected = YES;
        btn.alpha = 0.9;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2 animations:^{
            btn.alpha = 1.0;
        }];
    }];
    
    for(UIButton *abtn in self.scrollView.subviews){
        if([abtn isKindOfClass:[UIButton class]] && abtn.tag >= 1000 && abtn != btn && abtn.selected){
            [UIView animateWithDuration:.2 delay:.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                CGAffineTransform t = CGAffineTransformIdentity;
                abtn.transform = t;
                abtn.selected = NO;
            } completion:nil];
            break;
        }
    }
}


- (void)lineViewScrollOffset:(CGFloat)offset{
    CGFloat width = CGRectGetWidth(self.frame);
    //认为是刚好一页
    if(offset / width - floor(offset / width) < 0.0001){
        UIButton *btn = (UIButton *)[self.scrollView viewWithTag:1000+floor(offset / width)];
        if(!btn) return;
        CGPoint point = btn.center;
        CGPoint linePoint = self.bottomLineView.center;
        linePoint.x = point.x;
        self.bottomLineView.center = linePoint;
        CGRect rect = self.bottomLineView.frame;
        rect.size.width =btn.frame.size.width;
        self.bottomLineView.frame = rect;
    }else{
        CGRect rect = self.bottomLineView.frame;
        CGFloat lineOffset = offset / (self.allTitles.count * width - width) * (self.scrollView.contentSize.width - self.leftGap - self.rightGap - rect.size.width);
        rect.origin.x = self.leftGap + lineOffset;
        self.bottomLineView.frame = rect;
    }
}

#pragma mark - lazy load
- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [UIScrollView new];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

@end
