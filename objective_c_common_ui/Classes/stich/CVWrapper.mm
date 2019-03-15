//
//  CVWrapper.m
//  CVOpenTemplate
//
//  Created by Washe on 02/01/2013.
//  Copyright (c) 2013 foundry. All rights reserved.
//

#import "CVWrapper.h"
#import "UIImage+OpenCV.h"
#import "stitching.h"
#import "UIImage+Rotate.h"
#import "imui.h"


@implementation CVWrapper

+(void) initStitcher
{
    initStitcher();
    //rois = NULL;
}

+ (UIImage*) processImageWithOpenCV: (UIImage*) inputImage
{
    NSArray* imageArray = [NSArray arrayWithObject:inputImage];
    UIImage* result;// = [[self class] processWithArray:imageArray];
    return result;
}

+ (UIImage*) processWithOpenCVImage1:(UIImage*)inputImage1 image2:(UIImage*)inputImage2;
{
    NSArray* imageArray = [NSArray arrayWithObjects:inputImage1,inputImage2,nil];
    UIImage* result;// = [[self class] processWithArray:imageArray];
    return result;
}

+ (NSMutableArray*) processWithArray:(NSArray*)imageArray horizontalAngles:(NSArray*) horizontalAngles oneHorizontalAngleUntiToPixel:(double) oneHorizontalAngleUntiToPixel verticleAngles:(NSArray*) verticleAngles oneVerticleAngleUntiToPixel:(double) oneVerticleAngleUntiToPixel tiltAngles:(NSArray*) tiltAngles oneTiltAngleUntiToPixel:(double) oneTiltAngleUntiToPixel focalLengths:(NSArray*) focalLengths
{
    if ([imageArray count]==0)
    {
        NSLog (@"imageArray is empty");
        return 0;
    }
    
    for (id image in imageArray)
    {
        if ([image isKindOfClass: [UIImage class]])
        {
            /*
             All images taken with the iPhone/iPa cameras are LANDSCAPE LEFT orientation. The  UIImage imageOrientation flag is an instruction to the OS to transform the image during display only. When we feed images into openCV, they need to be the actual orientation that we expect them to be for stitching. So we rotate the actual pixel matrix here if required.
             */
            
            UIImage* rotatedImage = [image rotateToImageOrientation];
        }
    }
    
    for (id angle in horizontalAngles)
    {
//        horizontalAnglesVector.push_back( [angle doubleValue] );
    }
    
    for (id angle in verticleAngles)
    {
//        verticleAnglesVector.push_back( [angle doubleValue] );
    }
    
    for (id angle in tiltAngles)
    {
//        tiltAnglesVector.push_back( [angle doubleValue] );
    }
    
    for (id angle in focalLengths)
    {
//        focalLengthsVector.push_back( [angle doubleValue] );
    }
    
    NSLog (@"stitching...");
    
    int resultCode = 0;
    NSMutableArray* resultImages = [[NSMutableArray alloc] init];
  
    if( resultCode != 0 )
    {
        if( resultCode == 1 )
        {
            [imui errorMsg:1 forMsg:@"stitch error ERR_NEED_MORE_IMGS"];
        }
        else if( resultCode == 2 )
        {
            [imui errorMsg:1 forMsg:@"stitch error ERR_HOMOGRAPHY_EST_FAIL"];
        }
        else if( resultCode == 3 )
        {
            [imui errorMsg:1 forMsg:@"stitch error ERR_CAMERA_PARAMS_ADJUST_FAIL"];
        }
    }
    
    return resultImages;
}

@end
