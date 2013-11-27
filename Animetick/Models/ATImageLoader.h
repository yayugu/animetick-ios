//
//  ATImageLoader.h
//  Animetick
//
//  Created by Yuya Yaguchi on 11/27/13.
//  Copyright (c) 2013 yayugu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ATImageLoaderCompletion)(UIImage *image, NSError *error);

@interface ATImageLoader : NSObject

+ (void)loadProcessedImageForAnimeIconWithUrl:(NSURL*)url completion:(ATImageLoaderCompletion)completion;

@end