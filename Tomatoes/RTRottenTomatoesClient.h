//
//  RTRottenTomatoesClient.h
//  Tomatoes
//
//  Created by Matt Greenwell on 1/4/14.
//  Copyright (c) 2014 Matt Greenwell. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface RTRottenTomatoesClient : AFHTTPSessionManager

+ (instancetype)sharedInstance;

- (void)searchMoviesWithQuery:(NSString *)query
                      success:(void (^)(NSArray *movies))success
                      failure:(void (^)(NSError *error))failure;

@end
