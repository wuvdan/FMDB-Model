//
//  OCUpdateViewController.m
//  DataBaseManagerDemo
//
//  Created by wudan on 2018/10/15.
//  Copyright © 2018 wudan. All rights reserved.
//

#import "OCUpdateViewController.h"
#import "DataBaseManager.h"

@interface OCUpdateViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name_TF;
@property (weak, nonatomic) IBOutlet UITextField *phone_TF;
@property (weak, nonatomic) IBOutlet UITextField *adress_TF;

@end

@implementation OCUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"OC-修改数据";
    
    self.name_TF.text = self.model.name;
    self.phone_TF.text = self.model.phone;
    self.adress_TF.text = self.model.address;
}

- (IBAction)updateTouched:(id)sender {
    if (self.name_TF.text.length == 0 || self.phone_TF.text.length == 0 || self.adress_TF.text.length == 0) {
        [[HUDManager hud] showHUDWithController:self content:@"完善信息"];
        return;
    }
    
    Model *model = [[Model alloc] init];
    model.name = self.name_TF.text;
    model.phone = self.phone_TF.text;
    model.address = self.adress_TF.text;
    [self.view endEditing:true];
    
    [[DataBaseManager defaultManager] updateDataWithModel:model uid:self.model.wd_fmdb_id successBlock:^{
        [[HUDManager hud] showHUDWithController:self content:@"修改成功" completeBlock:^{
            [self.navigationController popViewControllerAnimated:true];
        }];
        
    } failBlock:^{
        [[HUDManager hud] showHUDWithController:self content:@"修改失败"];
    }];
}
@end
