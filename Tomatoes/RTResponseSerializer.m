//
//  RTResponseSerializer.m
//  Tomatoes
//
//  Created by Matt Greenwell on 1/4/14.
//  Copyright (c) 2014 Matt Greenwell. All rights reserved.
//

#import "RTResponseSerializer.h"

#import "RTMovie.h"

NSString * const kMoviesKey = @"movies";

@implementation RTResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error {
    NSDictionary *searchResponse = [super responseObjectForResponse:response
                                                               data:data
                                                              error:error];
    NSArray *moviesJSON = searchResponse[kMoviesKey];
    NSMutableArray *movies = nil;
    
    if (moviesJSON != nil) {
        movies = [NSMutableArray arrayWithCapacity:[moviesJSON count]];
        for (NSDictionary *movieJSON in moviesJSON) {
            RTMovie *movie = [RTMovie movieFromJSON:movieJSON];
            [movies addObject:movie];
        }
    }
    return movies;
}

@end
