//
//  ShippingAddressCell.m
//  nen
//
//  Created by nenios101 on 2017/3/28.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ShippingAddressCell.h"
#import "AddresslistModel.h"
@interface ShippingAddressCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *giveBtn;

@property(nonatomic,copy) NSString *deleteId;
@property(nonatomic,copy) NSString *selectedId;
@property(nonatomic,copy) NSString *editId;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation ShippingAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
}

-(void)setModel:(AddresslistModel *)model
{
    _model = model;
    self.nameLabel.text = model.relation_name;
    self.numberLabel.text = model.relation_tel;
    self.locationLabel.text = model.address;
    self.deleteId = model.id;
    self.selectedId = model.id;
    self.editId = model.id;
    
    NSInteger tacitNumber = [model.is_default integerValue];
    
    if (tacitNumber == 1)
    {
        self.giveBtn.selected = YES;
      
        // 记录当前按钮为选中按钮
        self.managerVC.selcectBtn = self.giveBtn;
    }
}

 // 默认选中

- (IBAction)giveClickBtn:(UIButton *)sender
{
   // 进来的时候把之前记录选中的按钮清除
    self.managerVC.selcectBtn.selected = NO;
    // 显示选中当前按钮
    sender.selected = YES;
    // 记录当前按钮为选中按钮
    self.managerVC.selcectBtn = sender;
    
    NSDictionary *dict = @{@"selected":self.selectedId};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selected" object:self userInfo:dict];
    
}


// 编辑
- (IBAction)editBtn:(UIButton *)sender
{
    NSDictionary *dict  = @{@"editId":self.editId,@"name":self.model.relation_name,@"address":self.model.address,@"postcode":@"1",@"phone":self.model.relation_tel};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"edit" object:self userInfo:dict];
    
}

// 删除
- (IBAction)deleteBtn:(UIButton *)sender
{
    NSDictionary *dict = @{@"delete":self.deleteId};
    
    self.giveBtn.selected = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"delete" object:self userInfo:dict];
}


@end
