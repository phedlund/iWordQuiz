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
		fontSize = 13.0;
	} else if ([contentSize isEqualToString:UIContentSizeCategorySmall]) {
		fontSize = 15.0;
	} else if ([contentSize isEqualToString:UIContentSizeCategoryMedium]) {
		fontSize = 17.0;
	} else if ([contentSize isEqualToString:UIContentSizeCategoryLarge]) {
		fontSize = 19.0;
	} else if ([contentSize isEqualToString:UIContentSizeCategoryExtraLarge]) {
		fontSize = 21.0;
	} else if ([contentSize isEqualToString:UIContentSizeCategoryExtraExtraLarge]) {
		fontSize = 23.0;
	} else if ([contentSize isEqualToString:UIContentSizeCategoryExtraExtraExtraLarge]) {
		fontSize = 25.0;
	}
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        fontSize = fontSize - 3;
    }
	
	if ([textStyle isEqualToString:UIFontTextStyleHeadline] || [textStyle isEqualToString:UIFontTextStyleSubheadline]) {
		return [UIFont boldSystemFontOfSize:fontSize + 1];
	} else {
		return [UIFont systemFontOfSize:fontSize];
	}
}

@end
