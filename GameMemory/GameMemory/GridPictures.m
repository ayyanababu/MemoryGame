//
//  GridPictures.m
//  GameMemory
//
//  Created by Ayyanababu, Kopparthi Raja on 25/06/14.
//  Copyright (c) 2014 com.sap.memorygame. All rights reserved.
//

#import "GridPictures.h"

#define FLICKER_API_KEY @"628fcf9505a18a3d4b45d3d0c784dbaa"
#define NUMBER_OF_PICS 10

@implementation GridPictures

@synthesize phototitles;
@synthesize images;
@synthesize delegate;

-(id) init {
    self = [super init];
    if (self) {
        
        phototitles = [[NSMutableArray alloc] init];
        images = [[NSMutableArray alloc] init];

       
    }
    
    return self;
}


- (void) getPhotosFromFlicker
{
        NSString *urlString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=%d&format=json&nojsoncallback=1", FLICKER_API_KEY, @"iphone",NUMBER_OF_PICS];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
        [NSURLConnection connectionWithRequest:request delegate:self];
}




- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *photos = [[results objectForKey:@"photos"] objectForKey:@"photo"];
    
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    if([self checkImagesAlreadyExists] == YES)
    {
        return;
    }
    
    for (NSDictionary *getphoto in photos)
    {
        NSString *title = [getphoto objectForKey:@"title"];
        [self.phototitles addObject:(title.length > 0 ? title : @"Untitled")];
        
        //Get images from flicker
        NSString *farmid = [getphoto objectForKey:@"farm"];
        NSString *serverid = [getphoto objectForKey:@"server"];
        NSString *photoid = [getphoto objectForKey:@"id"];
        NSString *secretid = [getphoto objectForKey:@"secret"];
        NSString *constructedPhotoUrlString = [NSString stringWithFormat:@"https://farm%@.static.flickr.com/%@/%@_%@_s.jpg",farmid,serverid,photoid,secretid];
        
        //Request with constructed photourlstring
        NSURL *imageUrl = [NSURL URLWithString:constructedPhotoUrlString];
        UIImage *imageFromURL = [self getImageFromURL:imageUrl];
        
        //Save in a directory
        [self saveImagetoDisk:imageFromURL withFileName:[self.phototitles lastObject] ofType:@"jpg" inDirectory:documentsDirectoryPath];
        [self.images addObject:imageFromURL];
    }
    
}


-(UIImage *) getImageFromURL:(NSURL *)fileURL {
    UIImage * imagedata;
    
    NSData * data = [NSData dataWithContentsOfURL:fileURL];
    imagedata = nil;
    if(data == nil)
    {
        NSLog(@"image didnt download from given check the URL string once again");
    }else{
        imagedata = [UIImage imageWithData:data];
    }
    
    
    return imagedata;
}


-(void) saveImagetoDisk:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath
{
    if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"])
    {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"Image save failed because of = %@", extension);
    }
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"connection failed with error");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"finished downloading images from the server");
    [delegate laoadImagesOnGrid];
    
    [delegate startCounter];
    
}


- (BOOL) checkImagesAlreadyExists
{
    BOOL hasImages = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectoryPath error:nil];
    if([contents count] >= 10)
    {
        hasImages = YES;
    }
    return hasImages;
}

- (void) startCounter
{
    
}

- (void) laoadImagesOnGrid
{
    
}

@end
