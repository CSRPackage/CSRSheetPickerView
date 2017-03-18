//
//  CSRSheetPickView.m
//  Test
//
//  Created by mac on 2017/3/9.
//  Copyright © 2017年 ECjia. All rights reserved.
//
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define KScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kTopViewTintColor [UIColor colorWithRed:24/255.0 green:124/255.0 blue:251/255.0 alpha:1]
#define CSBackgroundColor [UIColor colorWithRed:210/255.0 green:214/255.0 blue:219/255.0 alpha:1.f]

#import "CSRSheetPickView.h"
#import "UIImage+CSRCategory.h"
@interface CSRSheetPickView()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong,nonatomic)UIView *bgView;               //屏幕下方看不到的view
//@property (weak,nonatomic)UILabel *titleLabel;        //中间显示的标题lab
@property (strong, nonatomic) UIPickerView *pickerView;
//@property (weak,nonatomic)UIButton *cancelButton;
@property (strong, nonatomic) UIButton *upButton;         /**   向上翻的按钮   */
@property (strong, nonatomic) UIButton *downButton;       /**   向下翻的按钮   */
@property (strong,nonatomic)UIButton *doneButton;
@property (strong,nonatomic)NSArray *dataArray;         // 用来记录传递过来的数组数据
@property (strong,nonatomic)NSString *headTitle;        //传递过来的标题头字符串
@property (strong,nonatomic)NSString *backString;       //回调的字符串

@end
@implementation CSRSheetPickView

+(instancetype)csrSheetStringPickerWithTitles:(NSArray *)titles Andcall:(CSRSheetPickerViewBlock)callBack
{
    CSRSheetPickView *pickerView = [[CSRSheetPickView alloc] initWithFrame:[UIScreen mainScreen].bounds  andTitles:titles];
    pickerView.callBack = callBack;
    return pickerView;
}

- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray*)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataArray = titles;
        _backString = self.dataArray[0];
        [self setupUI];
    }
    return self;
}

- (void)tap
{
    [self dismissPicker];
}


-(void)setupUI
{
    
    //首先创建一个位于屏幕下方看不到的view
    UIView* bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.45];
    bgView.alpha = 0.0f;
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [bgView addGestureRecognizer:g];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:bgView];
    self.bgView = bgView;
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    topView.frame = CGRectMake(0, 0, SCREEN_SIZE.width, 44);
    [self addSubview:topView];
    
    //上翻
    UIButton *upButton = [UIButton buttonWithType:UIButtonTypeCustom];
    upButton.frame = CGRectMake(6, 0, 44, 44);
    //    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"上" attributes:
    //                                      @{ NSForegroundColorAttributeName: [UIColor grayColor],
    //                                         NSFontAttributeName :           [UIFont systemFontOfSize:14],
    //                                         NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone) }];
    //    [upButton setAttributedTitle:attrString forState:UIControlStateNormal];
    //    upButton.adjustsImageWhenHighlighted = NO;
    UIImage *topImage = [[UIImage imageNamed:@"CSRPickerViewResource.bundle/icon-left-top"] imageWithTintColor:kTopViewTintColor];
    [upButton setImage:topImage forState:UIControlStateNormal];
    upButton.backgroundColor = [UIColor clearColor];
    [upButton addTarget:self action:@selector(scrollPickViewClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:upButton];
    self.upButton = upButton;
    
    //下翻
    UIButton *downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    downButton.frame = CGRectMake(55, 0, 44, 44);
    //    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:@"下" attributes:
    //                                      @{ NSForegroundColorAttributeName: [UIColor grayColor],
    //                                         NSFontAttributeName :           [UIFont systemFontOfSize:14],
    //                                         NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone) }];
    //    [downButton setAttributedTitle:attrStr forState:UIControlStateNormal];
    downButton.adjustsImageWhenHighlighted = NO;
    UIImage *bottomImage = [[UIImage imageNamed:@"CSRPickerViewResource.bundle/icon-right-bottom"] imageWithTintColor:kTopViewTintColor];
    [downButton setImage:bottomImage forState:UIControlStateNormal];
    downButton.backgroundColor = [UIColor clearColor];
    [downButton addTarget:self action:@selector(scrollPickViewClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:downButton];
    self.downButton = downButton;
    
    //完成按钮
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(KScreenWidth - 68, 0, 60, 44);
    NSAttributedString *attrString2 = [[NSAttributedString alloc] initWithString:@"完成" attributes:
                                       @{ NSForegroundColorAttributeName: kTopViewTintColor,
                                          NSFontAttributeName :           [UIFont systemFontOfSize:16],
                                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone) }];
    [doneButton setAttributedTitle:attrString2 forState:UIControlStateNormal];
    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    doneButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    doneButton.adjustsImageWhenHighlighted = NO;
    doneButton.backgroundColor = [UIColor clearColor];
    [doneButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:doneButton];
    self.doneButton = doneButton;
    
    //选择器
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(5,44, SCREEN_SIZE.width-10, 230)];
    [pickerView setShowsSelectionIndicator:YES];
    [pickerView setDelegate:self];
    [pickerView setDataSource:self];
    [self addSubview:pickerView];
    self.pickerView = pickerView;
    self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    //self
    self.backgroundColor = CSBackgroundColor;
    [self setFrame:CGRectMake(0, SCREEN_SIZE.height-300, SCREEN_SIZE.width , 300)];
    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    [self setFrame: CGRectMake(0, SCREEN_SIZE.height,SCREEN_SIZE.width , 250)];
}

//向上翻 下翻
- (void)scrollPickViewClick:(UIButton *)sender
{
    NSInteger count = self.dataArray.count;
    NSInteger currentCount = [self.pickerView selectedRowInComponent:0];
    if (sender == self.upButton) {
        if (currentCount == 0) {
            currentCount = count -1;
        }
        else {
            currentCount --;
        }
    }
    else {
        //下翻
        if (currentCount == count-1) {
            currentCount = 0;
        }
        else {
            currentCount ++;
        }
    }
    //滑动pickView
    [self.pickerView selectRow:currentCount inComponent:0 animated:YES];
    if (self.dataArray.count>currentCount) {
        _backString = self.dataArray[currentCount];
    }
}

//取消按钮   确定按钮
- (void)clicked:(UIButton *)sender
{
    if (self.callBack) {
        self.callBack(self,_backString);
    }
}

#pragma mark - 该方法的返回值决定该控件包含多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}

#pragma mark - 该方法的返回值决定该控件指定列包含多少个列表项
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataArray.count;
}

#pragma mark - 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _backString = self.dataArray[row];
}

- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* l = [[UILabel alloc] init];
    l.textColor = self.textColor;
    l.textAlignment = NSTextAlignmentCenter;
    l.text = self.dataArray[row];
    return l;
}

- (UIColor *)textColor
{
    if (!_textColor) {
        _textColor = [UIColor blackColor];
    }
    return _textColor;
}

- (void)show
{
    [UIView animateWithDuration:0.8f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
        
        [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
        self.bgView.alpha = 1.0;
        
        self.frame = CGRectMake(0, SCREEN_SIZE.height-250, SCREEN_SIZE.width, 250);
    } completion:NULL];
}

- (void)dismissPicker
{
    [UIView animateWithDuration:0.8f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
        self.bgView.alpha = 0.0;
        self.frame = CGRectMake(0, SCREEN_SIZE.height,SCREEN_SIZE.width , 250);
        
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self removeFromSuperview];
        
    }];
}



@end
