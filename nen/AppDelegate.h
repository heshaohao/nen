//
//  AppDelegate.h
//  nen
//
//  Created by nenios101 on 2017/2/27.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "ApplyViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, EMChatManagerDelegate>
{
    EMConnectionState _connectionState;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MainViewController *mainController;

@end


