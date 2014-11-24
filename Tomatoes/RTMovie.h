//
//  RTMovie.h
//  Tomatoes
//
//  Created by Matt Greenwell on 1/4/14.
//  Copyright (c) 2014 Matt Greenwell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTMovie : NSObject <NSCoding>

@property (copy, nonatomic) NSString *movieID;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *year;
@property (strong, nonatomic) NSArray *releaseDates;
@property (strong, nonatomic) NSArray *cast;
@property (assign, nonatomic) NSInteger criticScore;
@property (strong, nonatomic) NSURL *thumbnailURL;

+ (RTMovie *)movieFromJSON:(NSDictionary *)json;

@end
