//
//  RTFavoritesSaver.h
//  Tomatoes
//
//  Created by John Andrews on 11/25/14.
//  Copyright (c) 2014 Matt Greenwell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTMovie.h"


@interface RTFavoritesSaver : NSObject
+ (BOOL)checkIfMovieIsAlreadyFavorited:(NSString *)movieID;
+ (void)saveMovie:(RTMovie *)movie;
+ (NSArray *)fetchAllMovieFavorites;
+ (void)deleteMovieFromFavorites:(NSString *)movieID;

@end
