//
//  AppDelegate.h
//  GameMemory
//
//  Created by Ayyanababu, Kopparthi Raja on 25/06/14.
//  Copyright (c) 2014 com.sap.memorygame. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GridRootControllerViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    GridRootControllerViewController *gridController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) GridRootControllerViewController *gridController;

@end
