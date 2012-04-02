//
//  WQDocument.m
//  iWordQuiz
//

/************************************************************************
 
 Copyright 2012 Peter Hedlund peter.hedlund@me.com
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 
 1. Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 *************************************************************************/

#import "WQDocument.h"

#import "DDXML.h"
#import "WQUtils.h"

@implementation WQDocument

@synthesize frontIdentifier;
@synthesize backIdentifier;
@synthesize url;
@synthesize entries;

- init {
	if(![super init]){
		return nil;
	}
	
    frontIdentifier = @"Front";
    backIdentifier = @"Back";
    
	entries = [[NSMutableArray alloc] init];
	return self;
}

- (void) load {
	[self.entries removeAllObjects];
	
    if ([[url pathExtension] caseInsensitiveCompare:@"kvtml"] == NSOrderedSame) {
        [self loadKvtml];
    }
    
    if ([[url pathExtension] caseInsensitiveCompare:@"csv"] == NSOrderedSame) {
        [self loadCvs];
    }
}

- (void) loadKvtml {

    NSString *f = @"";
    NSString *b = @"";
    
    NSString *fileString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
    
    DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithXMLString:fileString options:0 error:nil];
    NSArray *identifierNodes = [xmlDoc nodesForXPath:@"/kvtml/identifiers/identifier/name" error:nil];
    
    self.frontIdentifier = [[identifierNodes objectAtIndex:0] stringValue];
    self.backIdentifier  = [[identifierNodes objectAtIndex:1] stringValue];
    
    NSArray *textNodes = [xmlDoc nodesForXPath:@"/kvtml/entries/entry/translation/text" error:nil];
    int colCount = [identifierNodes count];
    int i = 0;
    
    for (DDXMLNode *textNode in textNodes){
        
        if (i == 0) {
            f = [textNode stringValue];
        }
        
        if (i == 1) {
            b = [textNode stringValue];
        }
        
        if (i == (colCount - 1)) {
            [self.entries addObject:[NSArray arrayWithObjects:f, b, nil]];
        }
        
        if (i == (colCount - 1)) {
            i = 0;
        } else {
            ++i;
        }      
    }
    [xmlDoc release];
}

- (void) loadCvs {
    
    NSString *fileString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
    
    unsigned length = [fileString length];
    unsigned paraStart = 0, paraEnd = 0, contentsEnd = 0;
    NSMutableArray *lines = [[[NSMutableArray alloc] init] autorelease];
    NSRange currentRange;
    while (paraEnd < length) {
        [fileString getParagraphStart:&paraStart end:&paraEnd contentsEnd:&contentsEnd forRange:NSMakeRange(paraEnd, 0)];
        currentRange = NSMakeRange(paraStart, contentsEnd - paraStart);
        [lines addObject:[fileString substringWithRange:currentRange]];
    }
    
    for (NSString *theLine in lines) {
        
        if (!([WQUtils isEmpty:theLine]) && ![theLine hasPrefix:@"!"] && ![theLine hasPrefix:@"Title:"] && ![theLine hasPrefix:@"Author:"]) {   
            //ignore empty lines and lines that start with ! (old kvtml?), Title:, and Author:
            //NSLog(@"csv theLine %@", theLine);
            NSArray *values  = [theLine componentsSeparatedByString:@"\t"];
            
            if ([values count] > 1) {
                [self.entries addObject:[NSArray arrayWithObjects:[values objectAtIndex:0], [values objectAtIndex:1], nil]];
            }
        }
    }
}

- (NSMutableArray *) quizEntries {
    NSMutableArray *result = [NSMutableArray arrayWithArray:self.entries];
    NSMutableIndexSet *emptyEntries = [NSMutableIndexSet indexSet];
    for (int i = 0; i < [result count]; ++i) {
		if (([WQUtils isEmpty:[[result objectAtIndex:i] objectAtIndex:0]]) || 
            ([WQUtils isEmpty:[[result objectAtIndex:i] objectAtIndex:1]])) {
            [emptyEntries addIndex:i];
        }
	}
    [result removeObjectsAtIndexes:emptyEntries];
    return result;
}

- (void)dealloc {
    [entries removeAllObjects];
    [entries release];
    [frontIdentifier release];
    [backIdentifier release];
    
    [super dealloc];
}

@end
