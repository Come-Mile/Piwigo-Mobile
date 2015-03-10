//
//  AlbumTableViewCell.m
//  piwigo
//
//  Created by Spencer Baker on 1/24/15.
//  Copyright (c) 2015 bakercrew. All rights reserved.
//

#import "AlbumTableViewCell.h"
#import "PiwigoAlbumData.h"
#import "ImageService.h"
#import "LEColorPicker.h"
#import "OutlinedText.h"

@interface AlbumTableViewCell()

@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) OutlinedText *albumName;
@property (nonatomic, strong) UILabel *numberOfImages;
@property (nonatomic, strong) UILabel *date;
@property (nonatomic, strong) UIView *textUnderlay;
@property (nonatomic, strong) UIImageView *cellDisclosure;
@property (nonatomic, strong) AFHTTPRequestOperation *cellDataRequest;

@end

@implementation AlbumTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if(self)
	{
		self.backgroundColor = [UIColor piwigoGray];
		
		self.backgroundImage = [UIImageView new];
		self.backgroundImage.translatesAutoresizingMaskIntoConstraints = NO;
		self.backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
		self.backgroundImage.clipsToBounds = YES;
		self.backgroundImage.backgroundColor = [UIColor piwigoGray];
		self.backgroundImage.image = [UIImage imageNamed:@"placeholder"];
		[self.contentView addSubview:self.backgroundImage];
		[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-5-[img]-5-|"
																				 options:kNilOptions
																				 metrics:nil
																				   views:@{@"img" : self.backgroundImage}]];
		[self.contentView addConstraints:[NSLayoutConstraint constraintFillHeight:self.backgroundImage]];
		
		if(IS_OS_8_OR_LATER)
		{
			UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
			self.textUnderlay = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
		}
		else
		{
			self.textUnderlay = [UIView new];
			self.textUnderlay.alpha = 0.5;
		}
		self.textUnderlay.translatesAutoresizingMaskIntoConstraints = NO;
		[self.contentView addSubview:self.textUnderlay];
		
		self.albumName = [OutlinedText new];
		self.albumName.translatesAutoresizingMaskIntoConstraints = NO;
		self.albumName.font = [UIFont piwigoFontNormal];
		self.albumName.font = [self.albumName.font fontWithSize:21.0];
		self.albumName.textColor = [UIColor piwigoOrange];
		self.albumName.adjustsFontSizeToFitWidth = YES;
		self.albumName.minimumScaleFactor = 0.6;
		[self.contentView addSubview:self.albumName];
		
		self.numberOfImages = [UILabel new];
		self.numberOfImages.translatesAutoresizingMaskIntoConstraints = NO;
		self.numberOfImages.font = [UIFont piwigoFontNormal];
		self.numberOfImages.font = [self.numberOfImages.font fontWithSize:16.0];
		self.numberOfImages.textColor = [UIColor piwigoWhiteCream];
		self.numberOfImages.adjustsFontSizeToFitWidth = YES;
		self.numberOfImages.minimumScaleFactor = 0.8;
		self.numberOfImages.lineBreakMode = NSLineBreakByTruncatingMiddle;
		[self.numberOfImages setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
		[self.contentView addSubview:self.numberOfImages];
		
		self.date = [UILabel new];
		self.date.translatesAutoresizingMaskIntoConstraints = NO;
		self.date.font = [UIFont piwigoFontNormal];
		self.date.font = [self.date.font fontWithSize:16.0];
		self.date.textColor = [UIColor piwigoWhiteCream];
		self.date.textAlignment = NSTextAlignmentRight;
		[self.date setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
		[self.contentView addSubview:self.date];
		
		UIImage *cellDisclosureImg = [UIImage imageNamed:@"cellDisclosure"];
		self.cellDisclosure = [UIImageView new];
		self.cellDisclosure.translatesAutoresizingMaskIntoConstraints = NO;
		self.cellDisclosure.image = [cellDisclosureImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		self.cellDisclosure.tintColor = [UIColor piwigoWhiteCream];
		self.cellDisclosure.contentMode = UIViewContentModeScaleAspectFit;
		[self.contentView addSubview:self.cellDisclosure];
		
		[self setupAutoLayout];
	}
	return self;
}

-(void)setupAutoLayout
{
	NSDictionary *views = @{
							@"name" : self.albumName,
							@"numImages" : self.numberOfImages,
							@"date" : self.date
							};
	
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[name]-5-[numImages]-15-|"
																			 options:kNilOptions
																			 metrics:nil
																			   views:views]];
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.albumName
																 attribute:NSLayoutAttributeLeft
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.contentView
																 attribute:NSLayoutAttributeLeft
																multiplier:1.0
																  constant:20]];
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.albumName
																 attribute:NSLayoutAttributeRight
																 relatedBy:NSLayoutRelationLessThanOrEqual
																	toItem:self.contentView
																 attribute:NSLayoutAttributeRight
																multiplier:1.0
																  constant:-30]];
	
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[numImages]-[date]-20-|"
																			 options:kNilOptions
																			 metrics:nil
																			   views:views]];
//	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.numberOfImages
//																	attribute:NSLayoutAttributeLeft
//																	relatedBy:NSLayoutRelationEqual
//																	   toItem:self.albumName
//																	attribute:NSLayoutAttributeLeft
//																   multiplier:1.0
//																	 constant:0]];
//	
	[self.contentView addConstraint:[NSLayoutConstraint constraintViewToSameBase:self.date equalToView:self.numberOfImages]];
//	[self.contentView addConstraint:[NSLayoutConstraint constraintViewFromRight:self.date amount:20]];
	
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-5-[bg]-5-|"
																			 options:kNilOptions
																			 metrics:nil
																			   views:@{@"bg" : self.textUnderlay}]];
	[self.contentView addConstraint:[NSLayoutConstraint constraintViewFromBottom:self.textUnderlay amount:0]];
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textUnderlay
																 attribute:NSLayoutAttributeTop
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.albumName
																 attribute:NSLayoutAttributeTop
																multiplier:1.0
																  constant:-5]];
	
	[self.cellDisclosure addConstraints:[NSLayoutConstraint constraintView:self.cellDisclosure toSize:CGSizeMake(23, 23)]];
	[self.contentView addConstraint:[NSLayoutConstraint constraintViewFromRight:self.cellDisclosure amount:15]];
	[self.contentView addConstraint:[NSLayoutConstraint constraintViewFromBottom:self.cellDisclosure amount:38]];
}

-(void)setupWithAlbumData:(PiwigoAlbumData*)albumData
{
	if(!albumData) return;
	
	self.albumData = albumData;
	
	self.albumName.text = self.albumData.name;
	
	NSString *subCategoryImages = @"";
	if(self.albumData.numberOfSubAlbumImages != self.albumData.numberOfImages)
	{
		subCategoryImages = [NSString stringWithFormat:@", %@ %@", @(self.albumData.numberOfSubAlbumImages), NSLocalizedString(@"categoryTableView_subCategoryImageCount", @"photos in sub-albums")];
	}
	
	self.numberOfImages.text = [NSString stringWithFormat:@"%@ %@%@", @(self.albumData.numberOfImages), NSLocalizedString(@"categoryTableView_photoCount", @"photos"), subCategoryImages];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	self.date.text = [formatter stringFromDate:self.albumData.dateLast];
	
	if(albumData.categoryImage)
	{
		[self setupBgWithImage:albumData.categoryImage];
	}
	else
	{
		__weak typeof(self) weakSelf = self;
		self.cellDataRequest = [ImageService getImageInfoById:albumData.albumThumbnailId
					  ListOnCompletion:^(AFHTTPRequestOperation *operation, PiwigoImageData *imageData) {
						  if(!imageData.mediumPath)
						  {
							  albumData.categoryImage = [UIImage imageNamed:@"placeholder"];
						  }
						  else
						  {
							  [self.backgroundImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageData.mediumPath]]
														  placeholderImage:nil
																   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
																	   
																	   albumData.categoryImage = image;
																	   [weakSelf setupBgWithImage:image];
							  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
								  NSLog(@"fail to get imgage for album");
							  }];
						  }
					  } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
						  NSLog(@"Fail to get album bg image: %@", [error localizedDescription]);
					  }];
	}
}

-(void)setupBgWithImage:(UIImage*)image
{
	self.backgroundImage.image = image;
	
	if(!IS_OS_8_OR_LATER)
	{
		LEColorPicker *colorPicker = [LEColorPicker new];
		LEColorScheme *colorScheme = [colorPicker colorSchemeFromImage:image];
		UIColor *backgroundColor = colorScheme.backgroundColor;
	//	UIColor *primaryColor = colorScheme.primaryTextColor;
	//	UIColor *secondaryColor = colorScheme.secondaryTextColor;

		CGFloat bgRed = CGColorGetComponents(backgroundColor.CGColor)[0] * 255;
		CGFloat bgGreen = CGColorGetComponents(backgroundColor.CGColor)[1] * 255;
		CGFloat bgBlue = CGColorGetComponents(backgroundColor.CGColor)[2] * 255;


		int threshold = 105;
		int bgDelta = (bgRed * 0.299) + (bgGreen * 0.587) + (bgBlue * 0.114);
		UIColor *bgColor = (255 - bgDelta < threshold) ? [UIColor blackColor] : [UIColor whiteColor];
		self.textUnderlay.backgroundColor = bgColor;
		self.numberOfImages.textColor = (255 - bgDelta < threshold) ? [UIColor piwigoWhiteCream] : [UIColor piwigoGray];
		self.date.textColor = self.numberOfImages.textColor;
		self.cellDisclosure.tintColor = self.numberOfImages.textColor;
	}
}

-(void)prepareForReuse
{
	[super prepareForReuse];
	
	[self.cellDataRequest cancel];
	[self.backgroundImage cancelImageRequestOperation];
	self.backgroundImage.image = [UIImage imageNamed:@"placeholder"];
	
	self.albumName.text = @"";
	self.numberOfImages.text = @"";
}

-(void)setFrame:(CGRect)frame
{
	frame.size.height -= 8.0;
	[super setFrame:frame];
}

@end
