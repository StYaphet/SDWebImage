//
//  SDWebImageCompat.m
//  SDWebImage
//
//  Created by Olivier Poitrey on 11/12/12.
//  Copyright (c) 2012 Dailymotion. All rights reserved.
//

#import "SDWebImageCompat.h"

#if !__has_feature(objc_arc)
#error SDWebImage is ARC only. Either turn on ARC for the project or use -fobjc-arc flag
#endif

inline UIImage *SDScaledImageForKey(NSString *key, UIImage *image) {
    if (!image) {
        return nil;
    }
    //  animated image
    if ([image.images count] > 0) {
        NSMutableArray *scaledImages = [NSMutableArray array];

        //  对animated image中的每一张图片都调用SDScaledImageForKey（递归）
        //  进行缩放
        for (UIImage *tempImage in image.images) {
            [scaledImages addObject:SDScaledImageForKey(key, tempImage)];
        }
        //  返回缩放后的animated image
        //  animated image是通过这个来做的
        return [UIImage animatedImageWithImages:scaledImages duration:image.duration];
    }
    //  不是animated image
    else {
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            CGFloat scale = 1;
            //  key是用来存储 image 的 name
            //  根据name中的 @2x  、  @3x  来对应的进行缩放
            if (key.length >= 8) {
                NSRange range = [key rangeOfString:@"@2x."];
                if (range.location != NSNotFound) {
                    scale = 2.0;
                }
                
                range = [key rangeOfString:@"@3x."];
                if (range.location != NSNotFound) {
                    scale = 3.0;
                }
            }

            UIImage *scaledImage = [[UIImage alloc] initWithCGImage:image.CGImage scale:scale orientation:image.imageOrientation];
            image = scaledImage;
        }
        return image;
    }
}

NSString *const SDWebImageErrorDomain = @"SDWebImageErrorDomain";
