//
//  ATImageLoader.m
//  Animetick
//
//  Created by Yuya Yaguchi on 11/27/13.
//  Copyright (c) 2013 yayugu. All rights reserved.
//

#import "ATImageLoader.h"
#import "UIImage+ATAdditions.h"
#import <TMCache.h>

@implementation ATImageLoader

+ (void)loadProcessedImageForAnimeIconWithUrl:(NSURL*)url
                                   completion:(ATImageLoaderCompletion)completion
{
    [[TMCache sharedCache]
     objectForKey:[url absoluteString]
     block:^(TMCache *cache, NSString *key, id object) {
         if (object) {
             UIImage *image = (UIImage *)object;
             dispatch_async(dispatch_get_main_queue(), ^{
                 completion(image, nil);
             });
         } else {
             [self requestProcessedImageForAnimeIconWithUrl:url completion:completion];
         }
     }];
}

+ (void)requestProcessedImageForAnimeIconWithUrl:(NSURL*)url
                                      completion:(ATImageLoaderCompletion)completion
{
    [NSURLConnection
     sendAsynchronousRequest:[NSURLRequest requestWithURL:url]
     queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
         if (error) {
             completion(nil, error);
             return;
         }
         __block UIImage *image = [UIImage imageWithData:data];
         
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
             image = [image processedImageForAnimeIcon];
             [[TMCache sharedCache] setObject:image forKey:[url absoluteString]];
             dispatch_async(dispatch_get_main_queue(), ^{
                 completion(image, nil);
                 return;
             });
         });
     }];
}

@end
