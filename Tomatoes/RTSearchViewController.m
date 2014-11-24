//
//  RTViewController.m
//  Tomatoes
//
//  Created by Matt Greenwell on 1/3/14.
//  Copyright (c) 2014 Matt Greenwell. All rights reserved.
//

#import "RTSearchViewController.h"
#import "RTRottenTomatoesClient.h"
#import "RTMoviePosterCollectionViewCell.h"

@interface RTSearchViewController ()

@end

@implementation RTSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.moviePosterCollectionView.delegate = self;
    self.moviePosterCollectionView.dataSource = self;
    
    [RTRottenTomatoesClient sharedInstance];
    
    RTRottenTomatoesClient *rtNetworking = [[RTRottenTomatoesClient alloc] init];
    
    [rtNetworking searchMoviesWithQuery:@"action" success:^(NSArray *movies) {
        NSLog(@"movies =%@", movies);
    } failure:^(NSError *error) {
        NSLog(@"error =%@", [error localizedDescription]);
    }];
}

- (void)updateUI
{
    
}

#pragma mark - UICollectionViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Collection View Data Source Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RTMoviePosterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"moviePosterCell" forIndexPath:indexPath];

    return cell;
}

@end
