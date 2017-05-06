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

@synthesize documentText;
@synthesize delegate;
@synthesize frontIdentifier;
@synthesize backIdentifier;
@synthesize entries;

- (void)setDocumentText:(NSString *)newText {
    documentText = [newText copy];
}

- (id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    if (!self.documentText)
        self.documentText = @"";
    if (self.hasUnsavedChanges) {
        self.documentText = [self xmlText];
    }
    NSData *docData = [self.documentText dataUsingEncoding:NSUTF8StringEncoding];
    
    return docData;
}

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    if ([contents length] > 0) {
        self.documentText = [[NSString alloc] initWithData:contents encoding:NSUTF8StringEncoding];
        [self load];
    }
    else
        self.documentText = @"";
    
    // Tell the delegate that the document contents changed.
    if (self.delegate && [self.delegate respondsToSelector:@selector(documentContentsDidChange:)])
        [self.delegate documentContentsDidChange:self];
    
    return YES;
}

- (id) initWithFileURL:(NSURL*)url {
    self = [super initWithFileURL:url];
    if (self) {
        self.frontIdentifier = @"Front";
        self.backIdentifier = @"Back";
    
        self.entries = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *) savingFileType {
   return @"com.peterandlinda.vocabulary.kvtml";    
}

- (void) load {
	[self.entries removeAllObjects];

    if ([[self.fileURL pathExtension] caseInsensitiveCompare:@"kvtml"] == NSOrderedSame) {
        [self loadKvtml];
    }
  
    if ([[self.fileURL pathExtension] caseInsensitiveCompare:@"csv"] == NSOrderedSame) {
        [self loadCvs];
    }
}

- (void) loadKvtml {

    NSString *f = @"";
    NSString *b = @"";
    
    //NSString *fileString = [NSString stringWithContentsOfURL:self.fileURL encoding:NSUTF8StringEncoding error:NULL];
    
    DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithXMLString:self.documentText options:0 error:nil];
    NSArray *identifierNodes = [xmlDoc nodesForXPath:@"/kvtml/identifiers/identifier/name" error:nil];
    
    self.frontIdentifier = [[identifierNodes objectAtIndex:0] stringValue];
    self.backIdentifier  = [[identifierNodes objectAtIndex:1] stringValue];
    
    NSArray *textNodes = [xmlDoc nodesForXPath:@"/kvtml/entries/entry/translation/text" error:nil];
    NSInteger colCount = [identifierNodes count];
    int i = 0;
    
    for (DDXMLNode *textNode in textNodes){
        
        if (i == 0) {
            f = [textNode stringValue];
        }
        
        if (i == 1) {
            b = [textNode stringValue];
        }
        
        if (i == (colCount - 1)) {
            [self.entries addObject:@[f, b]];
        }
        
        if (i == (colCount - 1)) {
            i = 0;
        } else {
            ++i;
        }      
    }
}

- (void) loadCvs {
    
    NSString *fileString = [NSString stringWithContentsOfURL:self.fileURL encoding:NSUTF8StringEncoding error:NULL];
    
    NSUInteger length = [fileString length];
    NSUInteger paraStart = 0, paraEnd = 0, contentsEnd = 0;
    NSMutableArray *lines = [[NSMutableArray alloc] init];
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
                [self.entries addObject:@[[values objectAtIndex:0], [values objectAtIndex:1]]];
            }
        }
    }
}

- (NSString *)xmlText {
    DDXMLDocument* xmlDoc = [[DDXMLDocument alloc] initWithXMLString:@"<!DOCTYPE kvtml PUBLIC \"kvtml2.dtd\" \"http://edu.kde.org/kvtml/kvtml2.dtd\"><kvtml/>" options:0 error:nil];
    DDXMLElement* root = [xmlDoc rootElement];
    [root addAttribute:[DDXMLNode attributeWithName:@"version" stringValue:@"2.0"]];
    
    DDXMLElement* information =[DDXMLNode elementWithName:@"information"];
    DDXMLElement* identifiers =[DDXMLNode elementWithName:@"identifiers"];
    DDXMLElement* listEntries =[DDXMLNode elementWithName:@"entries"];

    [root addChild:information];
    [root addChild:identifiers];
    [root addChild:listEntries];
    
    DDXMLElement* generator =[DDXMLNode elementWithName:@"generator" stringValue:[NSString stringWithFormat:@"wordquiz-for-ios %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
    DDXMLElement* title =[DDXMLNode elementWithName:@"title" stringValue:[self.fileURL.lastPathComponent stringByDeletingPathExtension]];
    
    [information addChild:generator];
    [information addChild:title];
    
    DDXMLElement* identifier1 =[DDXMLNode elementWithName:@"identifier"];
    [identifier1 addAttribute:[DDXMLNode attributeWithName:@"id" stringValue:@"0"]];
    [identifier1 addChild:[DDXMLNode elementWithName:@"name" stringValue:frontIdentifier]];
    [identifier1 addChild:[DDXMLNode elementWithName:@"locale" stringValue:frontIdentifier]];
    
    DDXMLElement* identifier2 =[DDXMLNode elementWithName:@"identifier"];
    [identifier2 addAttribute:[DDXMLNode attributeWithName:@"id" stringValue:@"1"]];
    [identifier2 addChild:[DDXMLNode elementWithName:@"name" stringValue:backIdentifier]];
    [identifier2 addChild:[DDXMLNode elementWithName:@"locale" stringValue:backIdentifier]];
    
    [identifiers addChild:identifier1];
    [identifiers addChild:identifier2];
    
    __block NSArray *listEntry;
    [self.entries enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        listEntry = (NSArray*)obj;
        DDXMLElement* xmlListEntry =[DDXMLNode elementWithName:@"entry"];
        [xmlListEntry addAttribute:[DDXMLNode attributeWithName:@"id" stringValue:[NSString stringWithFormat:@"%lu", (unsigned long)idx]]];
        
        DDXMLElement* translation1 =[DDXMLNode elementWithName:@"translation"];
        [translation1 addAttribute:[DDXMLNode attributeWithName:@"id" stringValue:@"0"]];
        [translation1 addChild:[DDXMLNode elementWithName:@"text" stringValue:[listEntry objectAtIndex:0]]];
        
        DDXMLElement* translation2 =[DDXMLNode elementWithName:@"translation"];
        [translation2 addAttribute:[DDXMLNode attributeWithName:@"id" stringValue:@"1"]];
        [translation2 addChild:[DDXMLNode elementWithName:@"text" stringValue:[listEntry objectAtIndex:1]]];
        
        [xmlListEntry addChild:translation1];
        [xmlListEntry addChild:translation2];
        
        [listEntries addChild:xmlListEntry];

    }];
    
    //NSLog(@"xml: %@", [[NSString alloc] initWithData:[xmlDoc XMLData] encoding:NSUTF8StringEncoding]);
    return [[NSString alloc] initWithData:[xmlDoc XMLData] encoding:NSUTF8StringEncoding];
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
}

@end
