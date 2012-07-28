//
//  Regex.h
//  SomacSubtitle
//


#import <Foundation/Foundation.h>

#import "RegexKitLite.h"




@interface RegexMatchEnumerator : NSEnumerator {
	NSString   *string;
	NSString   *regex;
	int location;
	NSRange matchedRange;
}

- (id)initWithString:(NSString *)initString regex:(NSString *)initRegex;
- (NSRange) matchedRange;


@end

@interface NSString (RegexMatchEnumeratorAdditions)

- (RegexMatchEnumerator *)matchEnumeratorWithRegex:(NSString *)regex;

@end