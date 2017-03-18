//
//  CSRSheetPickView.h
//  Test
//
//  Created by mac on 2017/3/9.
//  Copyright © 2017年 ECjia. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CSRSheetPickView : UIView
//回调  pickerView 回传类本身 用来做调用 销毁动作
//     choiceString  回传选择器 选择的单个条目字符串
typedef void(^CSRSheetPickerViewBlock)(CSRSheetPickView *pickerView,NSString *choiceString);
@property (nonatomic, copy)CSRSheetPickerViewBlock callBack;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;


//------单条选择器
+(instancetype)csrSheetStringPickerWithTitles:(NSArray *)titles Andcall:(CSRSheetPickerViewBlock)callBack;
//显示
-(void)show;
//销毁类
-(void)dismissPicker;

@end
