//
//  StarRating.m
//  StarRating
//
//  Created by Martin Ortega on 11/27/13.
//  Copyright (c) 2013 Rakuten. All rights reserved.
//

#import "StarRating.h"

static float kDefaultValue = 0;
static float kDefaultRatingDelta = 0.5;
static NSInteger kDefaultNumberOfStars = 5;

////////////////////////////////////////////////////////////////////////////

@interface StarRating ()

@property (nonatomic, assign) NSInteger numberOfStars;

@property (nonatomic, strong) UIView *stars;
@property (nonatomic, strong) UIView *highlightedStars;

@property (nonatomic, assign) CGFloat padding;

@end

////////////////////////////////////////////////////////////////////////////

@implementation StarRating

@synthesize starImage = _starImage;
@synthesize starImageHighlighted = _starImageHighlighted;

//--------------------------------------------------------------------------

#pragma mark - Initialization


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(!(self = [super initWithCoder:aDecoder])) return nil;
    
    [self configureForNumberOfStars:kDefaultNumberOfStars];
    
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    [self configureForNumberOfStars:kDefaultNumberOfStars];
    
    return self;
}


- (id)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars
{
    if (!(self = [super initWithFrame:frame])) return nil;

    [self configureForNumberOfStars:numberOfStars];
    
    return self;
}


- (void)configureForNumberOfStars:(NSInteger)numberOfStars
{
    self.numberOfStars = numberOfStars;
    self.value = kDefaultValue;
    self.ratingDelta = kDefaultRatingDelta;
}


- (void)layoutSubviews
{
    [self addSubview:self.stars];
    [self addSubview:self.highlightedStars];
}

//--------------------------------------------------------------------------

#pragma mark - User Interaction

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    self.value = [self ratingForFingerLocation:[touch locationInView:self.stars].x];
    
    if ([self.delegate respondsToSelector:@selector(userDidBeginEditingRating)]) {
        [self.delegate userDidBeginEditingRating];
    }
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    self.value = [self ratingForFingerLocation:[touch locationInView:self.stars].x];
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(userDidEndEditingRating)]) {
        [self.delegate userDidEndEditingRating];
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(userDidEndEditingRating)]) {
        [self.delegate userDidEndEditingRating];
    }
}

//--------------------------------------------------------------------------

#pragma mark - Property Getters and Setters

- (void)setValue:(float)value
{
    CGFloat oldValue = _value;
    _value = MIN(self.numberOfStars, MAX(0, value));
    self.highlightedStars.frame = [self highlightedStarsFrameForRating:_value];
    
    if (oldValue != _value) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}


- (void)setRatingDelta:(float)ratingDelta
{
    _ratingDelta = MIN(1, MAX(0, ratingDelta));
}


- (void)setNumberOfStars:(NSInteger)numberOfStars
{
    _numberOfStars = MAX(1, numberOfStars);
}


- (UIImage *)starImage
{
    if (!_starImage) {
        _starImage = [UIImage imageNamed:@"star-image.png"];
    }
    return _starImage;
}


- (void)setStarImage:(UIImage *)starImage
{
    _starImage = starImage;
    self.stars = nil;
    [self setNeedsDisplay];
}


- (UIImage *)starImageHighlighted
{
    if (!_starImageHighlighted) {
        _starImageHighlighted = [UIImage imageNamed:@"star-image-highlighted.png"];
    }
    return _starImageHighlighted;
}


- (void)setStarImageHighlighted:(UIImage *)starImageHighlighted
{
    _starImageHighlighted = starImageHighlighted;
    self.highlightedStars = nil;
    [self setNeedsDisplay];
}


- (UIView *)stars
{
    if (!_stars) {
        _stars = [self starStripWithImage:self.starImage];
    }
    return _stars;
}


- (UIView *)highlightedStars
{
    if (!_highlightedStars) {
        _highlightedStars = [self starStripWithImage:self.starImageHighlighted];
        _highlightedStars.frame = [self highlightedStarsFrameForRating:self.value];
        _highlightedStars.clipsToBounds = YES;
    }
    return _highlightedStars;
}


- (CGFloat)padding
{
    CGFloat viewWidth = self.bounds.size.width;
    CGFloat starWidth = self.starImage.size.width;
    
    return MAX(0, (viewWidth - self.numberOfStars*starWidth) / (self.numberOfStars + 1));
}


//--------------------------------------------------------------------------

#pragma mark - Star Helpers

- (UIView *)starStripWithImage:(UIImage *)image
{
    UIView *starStrip = [[UIView alloc] initWithFrame:self.bounds];
    
    for (NSInteger i = 0; i < self.numberOfStars; i++) {
        UIImageView *star = [[UIImageView alloc] initWithImage:image];
        CGFloat horizontalOffset = (i + 1)*self.padding + i*image.size.width + image.size.width/2;
        star.center = CGPointMake(horizontalOffset, starStrip.center.y);
        [starStrip addSubview:star];
    }
    
    return starStrip;
}


- (CGRect)highlightedStarsFrameForRating:(float)rating
{
    CGFloat starWidth = self.starImage.size.width;
    CGFloat numStars = floorf(rating);
    CGFloat width = (numStars + 1)*self.padding + rating*starWidth;
    
    CGRect frame = CGRectMake(0, 0, width, self.bounds.size.height);
    
    return frame;
}


- (float)ratingForFingerLocation:(CGFloat)finger
{
    CGFloat starWidth = self.starImage.size.width;
    
    CGFloat star = MIN(self.numberOfStars, MAX(0, floorf(finger/(self.padding + starWidth))));
    
    CGFloat offsetToLeadingEdgeOfStar = (star + 1)*self.padding + star*starWidth;
    CGFloat numDeltas = floorf((finger - offsetToLeadingEdgeOfStar) / (self.ratingDelta * starWidth) + 1);
    CGFloat fraction = MIN(1, MAX(0, self.ratingDelta * numDeltas));
    
    CGFloat rating = star + fraction;
    
    return rating;
}

@end
