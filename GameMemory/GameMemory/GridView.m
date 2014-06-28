//
//  GridView.m
//  GameMemory
//
//  Created by Ayyanababu, Kopparthi Raja on 25/06/14.
//  Copyright (c) 2014 com.sap.memorygame. All rights reserved.
//

#import "GridView.h"
#import "GridPictures.h"
#import <QuartzCore/QuartzCore.h>

@implementation GridView

@synthesize timer;
@synthesize timerlabel;
@synthesize flickerImages;
@synthesize buttonsArray;
@synthesize imageDictionary;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //Initalizeing objects Used in this class
        [self initializeObjects];
        
        //Load pictures
        [self loadPicturesFromFlickr];
        
        
        
    }
    return self;
}

- (void) initializeObjects
{
    self.buttonsArray = [[NSMutableArray alloc] init];
    globalindex = 9;
    showedImagetag = -1;
    self.flickerImages = [[NSMutableArray alloc] init];
    self.imageDictionary = [[NSMutableDictionary alloc] init];
    
    
    //This method invokes initial arrangment of UIButtons into 3*3 grid.
    [self startGame];
    
    //Adding UIlabel view
    self.timerlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.size.height -100,self.frame.size.width, 100)];
    [self.timerlabel adjustsFontSizeToFitWidth];
    [self.timerlabel setTextAlignment:NSTextAlignmentCenter];
    [self.timerlabel setBackgroundColor:[UIColor clearColor]];
    self.timerlabel.layer.masksToBounds = YES;
    self.timerlabel.textColor = [UIColor orangeColor];
    NSString *initialmessage = [NSString stringWithFormat:@"Getting Images..."];
    [self updateLableWithText:initialmessage];
    [self addSubview:self.timerlabel];
    
}


#pragma mark Grid layout
#pragma mark -----------

- (UIImage *) getCommanImage
{
    NSString *localPath = [[NSBundle mainBundle]bundlePath];
    NSString *imageName = [localPath stringByAppendingPathComponent:[[NSString alloc]initWithFormat:@"thumbnail.jpg"]];
    UIImage *commonImage = [UIImage imageWithContentsOfFile:imageName];
    return commonImage;
}

- (void) startGame
{
    
    int count = 1;
    CGRect frame;
    
    for (int i=0; i < ROW_COUNT; i++)
    {
		for (int j=0; j < COLOUMN_COUNT; j++)
        {
            frame = CGRectMake(MARGIN+(BUTTON_WIDTH+MARGIN + 5)*j, MARGIN+(BUTTON_HEIGHT + 50)*i, BUTTON_WIDTH, BUTTON_HEIGHT);
			UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
			imageButton.frame = frame;
            [imageButton setImage:[self getCommanImage] forState:UIControlStateNormal];
            [imageButton addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
            
            //Setting tag for each button on this only entire accessing and loading images ,shuffling will depend
            [imageButton setTag:count*100];
            
            count ++;
            
            imageButton.layer.borderColor = [UIColor orangeColor].CGColor;
            imageButton.layer.borderWidth = 02.0f;
            imageButton.layer.cornerRadius = 3.0f;
            
            
            [self.buttonsArray addObject:imageButton];
            [self addSubview:imageButton];
        }
    }
    
    
}

#pragma mark Button delegateMethod
#pragma mark ---------------------

- (void) imageClick:(id)sender
{
    
    UIButton *clickedButton = (UIButton *) sender;
    
    
    if(showedImagetag == -1)
    {
        if(globalindex == 1)
        {
            [self showClickedImage:clickedButton];
            [self updateLableWithText:@"No More Moves Good Job:)"];
        }
        return;
    }
    
    [self UserInteractinosOfButton:YES];
    [self showClickedImage:clickedButton];
    if(clickedButton.tag != showedImagetag){
        
        [self updateLableWithText:@"Sorry click on other one.."];
        
       /*  direction = 1;
         shakes = 0;
        [self closebuttonafterselect:clickedButton];*/
        [self performSelector:@selector(closebuttonafterselect:) withObject:clickedButton afterDelay:2.0f];

        
    }
    else{
        
        
        [self updateLableWithText:@"Good job.."];
        //sucess
        UIButton *button = (UIButton *)[self viewWithTag:showedImagetag];
        [self zoomOutImage:button];
        
        //After sucessfully identified the image I am trygin below steps
        //Reduce the buttons array to one by remove object at any index and adding into last
        //And decrement the globalindex value to 1
        //because while showing images automatically like machine generated global index will work
        
        [self.buttonsArray removeObject:button];
        [self.buttonsArray addObject:button];
        
        showedImagetag = -1;
        globalindex -= 1;
        
        
        [self updateLableWithText:@"Come on once again we will do"];
        [self UserInteractinosOfButton:NO];

        //After sucessfull identifaction show other image in grid
        
        if(globalindex != 1)
            [self performSelector:@selector(randomlyshowImageAfterSomeTime:) withObject:self afterDelay:2.0f];
        
    }
}


- (void) UserInteractinosOfButton:(BOOL)disable
{
    for(int i=0;i<self.buttonsArray.count;i++)
    {
        UIButton *button = [self.buttonsArray objectAtIndex:i];
        
        if(disable)
            [button removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        else
            [button addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}


#pragma mark AnimationMethods
#pragma mark ----------------

- (void) showClickedImage:(UIButton *)clickedButton
{
    int clickedbuttontag = clickedButton.tag;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:clickedButton cache:NO];
    UIImage *image = [self.flickerImages objectAtIndex:((clickedbuttontag-1)/100)];
    [clickedButton setImage:image forState:UIControlStateNormal];
    [UIView commitAnimations];
}

- (void) zoomOutImage:(UIButton *)button
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    CABasicAnimation *resizeOrgAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    resizeOrgAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.5, 1.5)];
    resizeOrgAnimation.duration = 0.8;
    resizeOrgAnimation.fillMode = kCAFillModeForwards;
    resizeOrgAnimation.removedOnCompletion = YES;
    [button.layer addAnimation:resizeOrgAnimation forKey:@"resizeOrgAnimation"];
    
    [UIView commitAnimations];
}

- (void) closebuttonafterselect:(UIButton *)clickedButton
{
    
    [self updateLableWithText:@"Try Once again.."];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:clickedButton cache:NO];
    [UIView commitAnimations];
    [clickedButton setImage:[self getCommanImage] forState:UIControlStateNormal];
    [self UserInteractinosOfButton:NO];
   /* [UIView animateWithDuration:0.03 animations:^
     {
         clickedButton.transform = CGAffineTransformMakeTranslation(5*direction, 0);
     }
                     completion:^(BOOL finished)
     {
         if(shakes >= 10)
         {
             clickedButton.transform = CGAffineTransformIdentity;
             return;
         }
         shakes++;
         direction = direction * -1;
         [self closebuttonafterselect:clickedButton];
     }];*/
   

}


#pragma mark LoadImagesOnGrid
#pragma mark ----------------

- (void) loadFlickerImagesOnGrid
{
    for(int i = 0;i<TOTAL_IMAGES;i++)
    {
        UIButton *yetToSetFlickerImage =   [self.buttonsArray objectAtIndex:i];
        [yetToSetFlickerImage setImage:[self.flickerImages objectAtIndex:i] forState:UIControlStateNormal];
    }
}





- (void) randomlyshowImageAfterSomeTime:(id)sender
{
    
    int randomnum = arc4random()%globalindex;
    UIButton *showedbutton = [self.buttonsArray objectAtIndex:randomnum];
    showedImagetag = showedbutton.tag;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:showedbutton cache:NO];
    [UIView commitAnimations];
    
    UIImage *image = [self.flickerImages objectAtIndex:((showedImagetag-1)/100)];
    [showedbutton setImage:image forState:UIControlStateNormal];
    [self performSelector:@selector(closeImage) withObject:self afterDelay:2.0f];
    
}


- (void) closeImage
{
    UIButton *showedimage = (UIButton *)[self viewWithTag:showedImagetag];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:showedimage cache:NO];
    [UIView commitAnimations];
    [showedimage setImage:[self getCommanImage] forState:UIControlStateNormal];

    [self shuffleImages];
}


#pragma mark UIlable timer methods
#pragma mark ---------------------

- (void) updateLableWithText:(NSString *)messsage
{
    [self.timerlabel setText:messsage];
    
    
}

- (void) startTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    secondsLeft = SECONDS_LEFT;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                  target:self
                                                selector:@selector(updateTimer)
                                                userInfo:nil
                                                 repeats:YES];
}
- (void) updateTimer
{
    secondsLeft--;
    
    [self updateLableWithText:[NSString stringWithFormat:@"Time Remaining: %i",secondsLeft]];
    
    if (secondsLeft == 0) {
        [self stopTimer];
    }
}
- (void) stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
    
    [self updateLableWithText:@"Spot the Shown Image.."];
    [self setCommonImages];
    [self performSelector:@selector(randomlyshowImageAfterSomeTime:) withObject:self afterDelay:1.0f];
    
}

- (void) setCommonImages
{
    for(int i =0;i<globalindex;i++)
    {
        UIButton *button = [self.buttonsArray objectAtIndex:i];
        [button setImage:[self getCommanImage] forState:UIControlStateNormal];
    }
}


#pragma mark LoadingPictureMethods
#pragma mark ---------------------


- (void) loadPicturesFromFlickr
{
    GridPictures *gridPicObj = [[GridPictures alloc] init];
    gridPicObj.delegate = self;
    [gridPicObj getPhotosFromFlicker];
    
    
}



#pragma mark PictureDownloadDelegateImplementation
#pragma mark -------------------------------------

- (void) networkNotAvailable
{
    
}



- (void) startCounter
{
    [self updateLableWithText:[NSString stringWithFormat:@"Time Remaining: %d",SECONDS_LEFT]];
    [self performSelector:@selector(startTimer) withObject:nil afterDelay:0.1f];
    
}


- (void) laoadImagesOnGrid
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectoryPath error:nil];
    for(NSString *fileName in contents)
    {
        if([fileName isEqualToString:@".DS_Store"])
            continue;
        UIImage *image = [UIImage imageWithContentsOfFile:[documentsDirectoryPath stringByAppendingPathComponent:fileName]];
        [self.flickerImages addObject:image];
    }
    
    [self loadFlickerImagesOnGrid];
    
}

#pragma mark Shuffling Images
#pragma mark ----------------

- (void) shuffleImages
{
    [self updateLableWithText:@"Spot the Shown Image.."];
    
    int imagcount = self.buttonsArray.count;
    for(int i=0;i<imagcount;i++)
    {
        int index = random()%imagcount;
        UIButton *ranbutton = [self.buttonsArray objectAtIndex:index];
        UIButton *intialbutton = [self.buttonsArray objectAtIndex:i];
        
        
        CGRect randomFrame = ranbutton.frame;
        CGRect initialbutFrame = intialbutton.frame;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        [intialbutton setFrame:randomFrame];
        [ranbutton setFrame:initialbutFrame];
        [UIView commitAnimations];
        
    }
}




@end
