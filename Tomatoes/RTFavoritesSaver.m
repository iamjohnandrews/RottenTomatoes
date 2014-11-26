//
//  RTFavoritesSaver.m
//  Tomatoes
//
//  Created by John Andrews on 11/25/14.
//  Copyright (c) 2014 Matt Greenwell. All rights reserved.
//

#import "RTFavoritesSaver.h"
#import "RTMovie.h"

@implementation RTFavoritesSaver

+ (BOOL)checkIfMovieIsAlreadyFavorited:(NSString *)movieID
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *movieFilePath = [[documentsPath stringByAppendingString:@"/movieFavorites/"] stringByAppendingString:movieID];
    BOOL movieExists = [fileManager fileExistsAtPath:movieFilePath];
  
    return movieExists;
}

+ (void)saveMovie:(RTMovie *)movie
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *favoritesDirectory = [documentsPath stringByAppendingString:@"/movieFavorites"];
    if (![fileManager fileExistsAtPath:favoritesDirectory]) {
        [fileManager createDirectoryAtPath:favoritesDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *moviePath = [favoritesDirectory stringByAppendingPathComponent:movie.movieID];
    
    [NSKeyedArchiver archiveRootObject:movie toFile:moviePath];
}

+ (NSArray *)fetchAllMovieFavorites
{
    NSMutableArray *favoitesArray = [NSMutableArray array];

    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *favoritesDirectoryPath = [documentsPath stringByAppendingString:@"/movieFavorites"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *favoritesURL = [NSURL URLWithString:favoritesDirectoryPath];
    NSArray *contents = [fileManager contentsOfDirectoryAtURL:favoritesURL
                                   includingPropertiesForKeys:@[]
                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        error:nil];
    for (NSURL *movieFile in contents) {
        RTMovie *movieDetails = [NSKeyedUnarchiver unarchiveObjectWithFile:movieFile.path]; 
        [favoitesArray addObject:movieDetails];
    }
    
    return favoitesArray;
}

+ (void)deleteMovieFromFavorites:(NSString *)movieID
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *movieFilePath = [[documentsPath stringByAppendingPathComponent:@"/movieFavorites"] stringByAppendingString:movieID];
    NSError *error = nil;
    
    if (![fileManager removeItemAtPath:movieFilePath error:&error]) {
        NSLog(@"error =%@, %@ for movieFilePath =%@", [error localizedDescription], [error description], movieFilePath);
    }
}

@end
