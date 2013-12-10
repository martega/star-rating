//
//  StarRating.h
//  StarRating
//
//  Created by Martin Ortega on 11/27/13.
//  Copyright (c) 2013 Rakuten. All rights reserved.
//

#import <UIKit/UIKit.h>

////////////////////////////////////////////////////////////////////////////

@protocol StarRatingDelegate <NSObject>

@optional

- (void)userDidBeginEditingRating;
- (void)userDidEndEditingRating;

@end

////////////////////////////////////////////////////////////////////////////

@interface StarRating : UIControl

@property (nonatomic, weak) IBOutlet id<StarRatingDelegate> delegate;

@property (nonatomic, assign) float value;
@property (nonatomic, assign) float ratingDelta;
@property (nonatomic, strong) UIImage *starImage;
@property (nonatomic, strong) UIImage *starImageHighlighted;

- (id)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars;

@end
