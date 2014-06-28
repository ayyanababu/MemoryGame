//
//  GridRootControllerViewController.h
//  GameMemory
//
//  Created by Ayyanababu, Kopparthi Raja on 25/06/14.
//  Copyright (c) 2014 com.sap.memorygame. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GridView;

@interface GridRootControllerViewController : UIViewController
{
    GridView    *collView;
}

@property (strong, nonatomic) UICollectionView  *gridView;
@property (strong, nonatomic) GridView    *collView;

@end
