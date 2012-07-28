//
//  Regex.m
//  SomacSubtitle
//


#import "RegexMatchEnumerator.h"

@implementation NSString (RegexMatchEnumeratorAdditions)

- (RegexMatchEnumerator *)matchEnumeratorWithRegex:(NSString *)regex
{
	return([[[RegexMatchEnumerator alloc] initWithString:self regex:regex] autorelease]);
}

@end

@implementation RegexMatchEnumerator

- (id)initWithString:(NSString *)initString regex:(NSString *)initRegex
{
	if((self = [self init]) == NULL) { return(NULL); }
	string = [initString copy];
	regex  = [initRegex copy];
	return(self);
}


- (id)nextObject
{
	if(location != NSNotFound) {
		NSRange searchRange  = NSMakeRange(location, [string length] - location);
		matchedRange = [string rangeOfRegex:regex inRange:searchRange];
		
		location = NSMaxRange(matchedRange) + ((matchedRange.length == 0) ? 1 : 0);
		
		if(matchedRange.location != NSNotFound) {
			return([string substringWithRange:matchedRange]);
		}
	}
	return(NULL);
}


- (NSRange) matchedRange
{
	return matchedRange;
}

- (void) dealloc
{
	[string release];
	[regex release];
	[super dealloc];
}


@end
