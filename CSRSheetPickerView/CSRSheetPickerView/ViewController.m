//
//  ViewController.m
//  CSRSheetPickerView
//
//  Created by 曹书润 on 2017/3/18.
//  Copyright © 2017年 LeoAiolia. All rights reserved.
//

#import "ViewController.h"
#import "CSRSheetPickView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectedItemBtnClick:(UIButton *)sender {
    NSArray  *arr = @[@"张三",@"李四",@"王五",@"赵六",@"小明",@"小花",@"老李",@"老王",@"老曹",@"小赵"];
    
    CSRSheetPickView *pick = [CSRSheetPickView csrSheetStringPickerWithTitles:arr Andcall:^(CSRSheetPickView *pickerView, NSString *choiceString) {
        
        [sender setTitle:choiceString forState:UIControlStateNormal];
        //注意：此处的pickView需要使用block中的pickerView，而不能使用初始化的picker
        [pickerView dismissPicker];
        
    }];
    [pick show];
    
}

@end
