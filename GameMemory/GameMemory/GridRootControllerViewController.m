//
//  GridRootControllerViewController.m
//  GameMemory
//
//  Created by Ayyanababu, Kopparthi Raja on 25/06/14.
//  Copyright (c) 2014 com.sap.memorygame. All rights reserved.
//

#import "GridRootControllerViewController.h"
#import "GridView.h"

@interface GridRootControllerViewController ()

@end

@implementation GridRootControllerViewController

@synthesize collView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIImage *image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"background.png"]];
        if(image != nil)
        {
             self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"background.png"]]];
        }else{
             self.view.backgroundColor = [UIColor colorWithRed:51/255.0 green:54/255.0 blue:57/255.0 alpha:1.0];

        }
       

    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    collView = [[GridView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.view = collView;
    
  }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
