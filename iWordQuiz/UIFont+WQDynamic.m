//
//  UIFont+WQDynamic.m
//  iWordQuiz
//
//  Created by Peter Hedlund on 12/28/13.
//
//

#import "UIFont+WQDynamic.h"

@implementation UIFont (WQDynamic)

+ (UIFont *)preferredWQFontForTextStyle:(NSString *)textStyle {

	CGFloat fontSize = 17.0;
	NSString *contentSize = [UIApplication sharedApplication].preferredContentSizeCategory;
	
	if ([contentSize isEqualToString:UIContentSizeCategoryExtraSmall]) {
		fontSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)? 11.0f : 13.0;
	} else if ([contentSize isEqualToString:UIContentSizeCategorySmall]) {
		fontSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)? 12.0f : 15.0;
	} else if ([contentSize isEqualToString:UIContentSizeCategoryMedium]) {
		fontSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)? 13.0f : 17.0;
	} else if ([contentSize isEqualToString:UIContentSizeCategoryLarge]) {
		fontSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)? 14.0f : 19.0;
	} else if ([contentSize isEqualToString:UIContentSizeCategoryExtraLarge]) {
		fontSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)? 15.0f : 21.0;
	} else if ([contentSize isEqualToString:UIContentSizeCategoryExtraExtraLarge]) {
		fontSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)? 16.0f : 23.0;
	} else if ([contentSize isEqualToString:UIContentSizeCategoryExtraExtraExtraLarge]) {
		fontSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)? 17.0f : 25.0;
	}
	
	if ([textStyle isEqualToString:UIFontTextStyleHeadline] || [textStyle isEqualToString:UIFontTextStyleSubheadline]) {
		return [UIFont boldSystemFontOfSize:fontSize + 1];
	} else {
		return [UIFont systemFontOfSize:fontSize];
	}
}

@end
