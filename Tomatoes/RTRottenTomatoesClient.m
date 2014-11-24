//
//  RTRottenTomatoesClient.m
//  Tomatoes
//
//  Created by Matt Greenwell on 1/4/14.
//  Copyright (c) 2014 Matt Greenwell. All rights reserved.
//

#import "RTRottenTomatoesClient.h"

#import "RTResponseSerializer.h"

NSString * const kAPIKey = @"fx6jwcz6zkenn5jfrw993cbr";

NSString * const baseURLString = @"http://api.rottentomatoes.com/api/public/v1.0/";

@implementation RTRottenTomatoesClient

+ (instancetype)sharedInstance {
    static RTRottenTomatoesClient *_client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _client = [[self alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
    });
    return _client;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        self.responseSerializer = [[RTResponseSerializer alloc] init];
    }
    return self;
}

- (void)searchMoviesWithQuery:(NSString *)query
                      success:(void (^)(NSArray *))success
                      failure:(void (^)(NSError *))failure {
    
    //@TODO: apikey needs to be sent with everything, so factor this out.
    NSDictionary *params = @{@"q" : query,
                             @"apikey" : kAPIKey};
    
    NSString *initialBoxOffice = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=16&country=us&apikey=fx6jwcz6zkenn5jfrw993cbr";


    //@"movies.json"
    [self GET:initialBoxOffice
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          success(responseObject);
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          failure(error);
      }];
}

@end
