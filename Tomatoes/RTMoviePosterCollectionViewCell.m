//
//  RTMoviePosterCollectionViewCell.m
//  Tomatoes
//
//  Created by John Andrews on 11/24/14.
//  Copyright (c) 2014 Matt Greenwell. All rights reserved.
//

#import "RTMoviePosterCollectionViewCell.h"

@implementation RTMoviePosterCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self resizeImageToThumbnail];
    
    self.moviePosterThumbnail.contentMode = UIViewContentModeScaleAspectFill;
    self.moviePosterThumbnail.clipsToBounds = YES;
}

- (void)resizeImageToThumbnail
{
    
}

@end
