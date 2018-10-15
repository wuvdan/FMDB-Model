//
//  OCInsterViewController.m
//  DataBaseManagerDemo
//
//  Created by wudan on 2018/10/15.
//  Copyright © 2018 wudan. All rights reserved.
//

#import "OCInsterViewController.h"
#import "OCDataViewController.h"
#import "DataBaseManagerDemo-Swift.h"
#import "DataBaseManager.h"

@interface OCInsterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name_TF;
@property (weak, nonatomic) IBOutlet UITextField *phone_TF;
@property (weak, nonatomic) IBOutlet UITextField *adress_TF;

@end

@implementation OCInsterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"OC-添加数据";
}

- (IBAction)insterTouched:(id)sender {
    if (self.name_TF.text.length == 0 || self.phone_TF.text.length == 0 || self.adress_TF.text.length == 0) {
        [[HUDManager hud] showHUDWithController:self content:@"完善信息"];
        return;
    }
    
    Model *model = [[Model alloc] init];
    model.name = self.name_TF.text;
    model.phone = self.phone_TF.text;
    model.address = self.adress_TF.text;

    [[DataBaseManager defaultManager] insertDataWithModel:model successBlock:^{
        [[HUDManager hud] showHUDWithController:self content:@"添加成功"];
    } failBlock:^{
        [[HUDManager hud] showHUDWithController:self content:@"添加成功"];
    }];

    [self.view endEditing:true];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
     [self.view endEditing:true];
}

- (IBAction)queryTouched:(id)sender {
    OCDataViewController *controller = [[OCDataViewController alloc] init];
    [self.navigationController pushViewController:controller animated:true];
}

@end
