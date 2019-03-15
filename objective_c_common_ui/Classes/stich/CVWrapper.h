//
//  CVWrapper.h
//  CVOpenTemplate
//
//  Created by Washe on 02/01/2013.
//  Copyright (c) 2013 foundry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface CVWrapper : NSObject

+(void) initStitcher;

+ (UIImage*) processImageWithOpenCV: (UIImage*) inputImage;

+ (UIImage*) processWithOpenCVImage1:(UIImage*)inputImage1 image2:(UIImage*)inputImage2;

+ (NSMutableArray*) processWithArray:(NSArray<UIImage*>*)imageArray horizontalAngles:(NSArray*) horizontalAngles oneHorizontalAngleUntiToPixel:(double) oneHorizontalAngleUntiToPixel verticleAngles:(NSArray*) verticleAngles oneVerticleAngleUntiToPixel:(double) oneVerticleAngleUntiToPixel tiltAngles:(NSArray*) tiltAngles oneTiltAngleUntiToPixel:(double) oneTiltAngleUntiToPixel focalLengths:(NSArray*) focalLengths;

+ (UIImage*) composePano:(NSArray<UIImage*>*)imageArray;

@end
NS_ASSUME_NONNULL_END
