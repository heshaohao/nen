//
//  EditShoppingCarCell.m
//  nen
//
//  Created by apple on 17/4/4.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "EditShoppingCarCell.h"
#import "editShoppingCarModel.h"

@interface EditShoppingCarCell ()
{
    LZNumberChangedBlock numberAddBlock;
    LZNumberChangedBlock numberCutBlock;
    LZCellSelectedBlock cellSelectedBlock;
}
//选中按钮
@property (nonatomic,strong) UIButton *selectBtn;
//显示照片
@property (nonatomic,strong) UIImageView *lzImageView;
//商品名
@property (nonatomic,strong) UILabel *nameLabel;
//价格
@property (nonatomic,strong) UILabel *priceLabel;
//数量
@property (nonatomic,strong)UILabel *numberLabel;

@property(nonatomic,strong) NSNumber*selectId;

@end

@implementation EditShoppingCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = LZColorFromRGB(245, 246, 248);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupMainView];
    }
    return self;
}

- (void)setModel:(editShoppingCarModel *)model
{
    _model  = model;
    
    [self.lzImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_img] placeholderImage:nil];
    self.nameLabel.text = model.goods_name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    self.numberLabel.text = model.num;
    // self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)model.number];
    self.selectBtn.selected = model.select;
    
    self.selectId = model.id;
    
}

- (void)numberAddWithBlock:(LZNumberChangedBlock)block {
    numberAddBlock = block;
}

- (void)numberCutWithBlock:(LZNumberChangedBlock)block {
    numberCutBlock = block;
}

- (void)cellSelectedWithBlock:(LZCellSelectedBlock)block {
    cellSelectedBlock = block;
}
#pragma mark - 重写setter方法
- (void)setLzNumber:(NSInteger)lzNumber {
    _lzNumber = lzNumber;
    
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)lzNumber];
}

- (void)setLzSelected:(BOOL)lzSelected {
    _lzSelected = lzSelected;
    self.selectBtn.selected = lzSelected;
}
#pragma mark - 按钮点击方法
- (void)selectBtnClick:(UIButton*)button {
    button.selected = !button.selected;
    
    if (cellSelectedBlock) {
        cellSelectedBlock(button.selected);
    }
}

#pragma mark - 布局主视图
-(void)setupMainView {
    //白色背景
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, 0, ScreenWidth, sh_CartRowHeight - 10);
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderColor = LZColorFromHex(0xEEEEEE).CGColor;
    bgView.layer.borderWidth = 1;
    [self addSubview:bgView];
    
    //选中按钮
    UIButton* selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.center = CGPointMake(20, bgView.sh_height/2.0);
    selectBtn.bounds = CGRectMake(0, 0, 30, 30);
    [selectBtn setImage:[UIImage imageNamed:sh_Bottom_UnSelectButtonString] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:sh_Bottom_SelectButtonString] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:selectBtn];
    self.selectBtn = selectBtn;
    
    //照片背景
    UIView *imageBgView = [[UIView alloc]init];
    imageBgView.frame = CGRectMake(selectBtn.sh_right + 5, 5, bgView.sh_height - 10, bgView.sh_height - 10);
    imageBgView.backgroundColor = LZColorFromHex(0xF3F3F3);
    [bgView addSubview:imageBgView];
    
    //显示照片
    UIImageView* imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"default_pic_1"];
    imageView.frame = CGRectMake(imageBgView.sh_x + 5, imageBgView.sh_y + 5, imageBgView.sh_width - 10, imageBgView.sh_height - 10);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:imageView];
    self.lzImageView = imageView;
    
    CGFloat width = (bgView.sh_width - imageBgView.sh_right - 30)/2.0;
    
    
    //商品名
    UILabel* nameLabel = [[UILabel alloc]init];
    nameLabel.frame = CGRectMake(imageBgView.sh_right + 10, 10,ScreenWidth - (imageBgView.sh_right + 20), 40);
    nameLabel.numberOfLines = 0;
    nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    nameLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    //价格
    UILabel* priceLabel = [[UILabel alloc]init];
    priceLabel.frame = CGRectMake(nameLabel.sh_x, nameLabel.sh_bottom + 5, width, 30);
    priceLabel.font = [UIFont boldSystemFontOfSize:16];
    priceLabel.textColor = BASECOLOR_RED;
    priceLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    
    //数量加按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(bgView.sh_width - 35, bgView.sh_height - 35, 25, 25);
    [addBtn setImage:[UIImage imageNamed:@"cart_addBtn_nomal"] forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"cart_addBtn_highlight"] forState:UIControlStateHighlighted];
    [bgView addSubview:addBtn];
    
    //数量显示
    UILabel* numberLabel = [[UILabel alloc]init];
    numberLabel.frame = CGRectMake(addBtn.sh_x - 30, addBtn.sh_y, 30, 25);
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.text = @"1";
    numberLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:numberLabel];
    self.numberLabel = numberLabel;
    
    //数量减按钮
    UIButton *cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cutBtn.frame = CGRectMake(numberLabel.sh_x - 25, addBtn.sh_y, 25, 25);
    [cutBtn setImage:[UIImage imageNamed:@"cart_cutBtn_nomal"] forState:UIControlStateNormal];
    [cutBtn setImage:[UIImage imageNamed:@"cart_cutBtn_highlight"] forState:UIControlStateHighlighted];
    [bgView addSubview:cutBtn];
}
@end
