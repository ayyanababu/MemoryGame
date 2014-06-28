//
//  GridPictures.h
//  GameMemory
//
//  Created by Ayyanababu, Kopparthi Raja on 25/06/14.
//  Copyright (c) 2014 com.sap.memorygame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PictureDownloadDelegate.h"



@interface GridPictures : NSObject <PictureDownloadDelegate>
{
    NSMutableArray *phototitles;
    NSMutableArray *images;
    id<PictureDownloadDelegate> delegate;
    
}

@property (strong, nonatomic) NSMutableArray *phototitles;
@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) id<PictureDownloadDelegate> delegate;

- (void) getPhotosFromFlicker;





@end
