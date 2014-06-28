//
//  GridView.h
//  GameMemory
//
//  Created by Ayyanababu, Kopparthi Raja on 25/06/14.
//  Copyright (c) 2014 com.sap.memorygame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureDownloadDelegate.h"

#define SECONDS_LEFT            15
#define MARGIN                  20
#define BUTTON_WIDTH            80
#define BUTTON_HEIGHT           80
#define ROW_COUNT               3
#define COLOUMN_COUNT           3
#define TOTAL_IMAGES            9

@class GridPictures;

@interface GridView : UIView <PictureDownloadDelegate>
{
    NSMutableArray      *buttonsArray;
    NSTimer             *timer;
    UILabel             *timerlabel;
    NSMutableArray      *flickerImages;
    
    int                 globalindex;
    int                 showedImagetag;
    int                 secondsLeft;
   /* int direction;
    int shakes;*/
}

@property (nonatomic, strong) NSMutableArray        *buttonsArray;
@property (nonatomic, strong) NSTimer               *timer;
@property (nonatomic, strong) UILabel               *timerlabel;
@property (nonatomic, strong) NSMutableArray        *flickerImages;
@property (nonatomic, strong) NSMutableDictionary   *imageDictionary;



- (void) startTimer;
- (void) updateTimer;
- (void) stopTimer;

@end
