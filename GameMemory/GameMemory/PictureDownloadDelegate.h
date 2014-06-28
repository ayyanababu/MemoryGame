//
//  PictureDownloadDelegate.h
//  GameMemory
//
//  Created by Ayyanababu, Kopparthi Raja on 26/06/14.
//  Copyright (c) 2014 com.sap.memorygame. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PictureDownloadDelegate <NSObject>

- (void) startCounter;
- (void) laoadImagesOnGrid;

@optional

- (void) networkNotAvailable;

@end
