//
//  MainViewController.m
//  StarRating
//
//  Created by Martin Ortega on 11/27/13.
//  Copyright (c) 2013 Rakuten. All rights reserved.
//

#import "MainViewController.h"
#import "StarRating.h"

////////////////////////////////////////////////////////////////////////////

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet StarRating *starRating;
@property (weak, nonatomic) IBOutlet UILabel *starLabel;

@property (weak, nonatomic) IBOutlet StarRating *rakutenStarRating;
@property (weak, nonatomic) IBOutlet UILabel *rakutenLabel;

@end

////////////////////////////////////////////////////////////////////////////

@implementation MainViewController

- (void)viewDidLoad
{
    [self.starRating addTarget:self action:@selector(userDidUpdateStarRating) forControlEvents:UIControlEventValueChanged];
    
    [self.rakutenStarRating addTarget:self action:@selector(userDidUpdateRakutenStarRating) forControlEvents:UIControlEventValueChanged];
    self.rakutenStarRating.starImage = [UIImage imageNamed:@"rakuten-logo.png"];
    self.rakutenStarRating.starImageHighlighted = [UIImage imageNamed:@"rakuten-logo-highlighted.png"];
    self.rakutenStarRating.ratingDelta = 1;
    
    [self updateStarLabel];
    [self updateRakutenLabel];
}


- (void)userDidUpdateStarRating
{
    [self updateStarLabel];
}


- (void)userDidUpdateRakutenStarRating
{
    [self updateRakutenLabel];
}


- (void)updateStarLabel
{
    self.starLabel.text = self.starRating.value == 0 ? @"Unrated" : [NSString stringWithFormat:@"%0.1f stars", self.starRating.value];
}


- (void)updateRakutenLabel
{
    self.rakutenLabel.text = self.rakutenStarRating.value == 0 ? @"Unrated" : [NSString stringWithFormat:@"%0.1f R's", self.rakutenStarRating.value];
}

@end
