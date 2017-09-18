
//

#import "SHTabBarViewController.h"
#import "SHNavigationController.h"
#import "HomeViewController.h"
#import "TheLatestHomeViewController.h"
#import "EarnMoneyViewController.h"
#import "ShareViewController.h"
#import "SpendMoneyViewController.h"
#import "MeViewController.h"
@interface SHTabBarViewController ()

@end

@implementation SHTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
   /**** 设置所有UITabBarItem的文字属性 ****/
    [self setupItemTitleTextAttributes];
    
     /**** 添加子控制器 ****/
    [self setupChildViewControllers];
    

}

+ (SHTabBarViewController *)sharedManager
{
    static SHTabBarViewController *shTabBarManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shTabBarManager = [[self alloc] init];
    });
    return shTabBarManager;
}


/**
 *  添加子控制器
 */
- (void)setupChildViewControllers
{
    [self setupOneChildViewController:[[SHNavigationController alloc] initWithRootViewController:[[TheLatestHomeViewController alloc] init]] title:@"主页" image:@"tabBar_home_icon" selectedImage:@"tabBar_home_click_icon"];
    
//    [self setupOneChildViewController:[[SHNavigationController alloc] initWithRootViewController:[[SpendMoneyViewController alloc] init]] title:@"赚钱" image:@"makeMoney_n"
//selectedImage:@"makeMoney_h"];
    
    [self setupOneChildViewController:[[SHNavigationController alloc] initWithRootViewController:[[ShareViewController alloc] init]] title:@"分享" image:@"shareTabBarIcom_n" selectedImage:@"shareTabBarIcom_h"];
    
    [self setupOneChildViewController:[[SHNavigationController alloc] initWithRootViewController:[[EarnMoneyViewController alloc] init]] title:@"花钱" image:@"thewallet_n" selectedImage:@"thewallet_h"];
    
    [self setupOneChildViewController:[[SHNavigationController alloc] initWithRootViewController:[[MeViewController alloc] init]] title:@"我的" image:@"tabBar_me_icon" selectedImage:@"tabBar_me__clickicon"];
    
    
    
}
/**
 *  设置所有UITabBarItem的文字属性
 */
- (void)setupItemTitleTextAttributes
{
    // 普通状态下的文字属性
    UITabBarItem *item = [UITabBarItem appearance];
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

/**
 *  初始化一个子控制器
 *
 *  @param vc            子控制器
 *  @param title         标题
 *  @param image         图标
 *  @param selectedImage 选中的图标
 */

- (void)setupOneChildViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    vc.tabBarItem.title = title;
    
    if (image.length) {
        
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    }
    [self addChildViewController:vc];
}


@end
