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

@synthesize documentText = _documentText;
@synthesize delegate = _delegate;
@synthesize frontIdentifier;
@synthesize backIdentifier;
@synthesize entries;

- (void)setDocumentText:(NSString *)newText {
    //NSString* oldText = _documentText;
    _documentText = [newText copy];
    
    // Register the undo operation.
    //[self.undoManager setActionName:@"Text Change"];
    //[self.undoManager registerUndoWithTarget:self selector:@selector(setDocumentText:) object:oldText];
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
        frontIdentifier = @"Front";
        backIdentifier = @"Back";
    
        entries = [[NSMutableArray alloc] init];
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
}

- (void) loadCvs {
    
    NSString *fileString = [NSString stringWithContentsOfURL:self.fileURL encoding:NSUTF8StringEncoding error:NULL];
    
    unsigned length = [fileString length];
    unsigned paraStart = 0, paraEnd = 0, contentsEnd = 0;
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
                [self.entries addObject:[NSArray arrayWithObjects:[values objectAtIndex:0], [values objectAtIndex:1], nil]];
            }
        }
    }
}

- (NSString *)xmlText {
	NSMutableString *xmlStr = [NSMutableString stringWithCapacity:100];
    [xmlStr appendString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"];
    [xmlStr appendString:@"<!DOCTYPE kvtml PUBLIC \"kvtml2.dtd\" \"http://edu.kde.org/kanagram/kvtml2.dtd\">"];
    [xmlStr appendString:@"<kvtml version=\"2.0\">"];
    [xmlStr appendString:@"<information>"];
    [xmlStr appendFormat:@"<generator>wordquiz-for-ios %@</generator>", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [xmlStr appendFormat:@"<title>%@</title>", [self.fileURL.lastPathComponent stringByDeletingPathExtension]];
    [xmlStr appendString:@"</information>"];
    
    [xmlStr appendString:@"<identifiers>"];
    [xmlStr appendString:@"<identifier id=\"0\" >"];
    [xmlStr appendFormat:@"<name>%@</name>", frontIdentifier];
    [xmlStr appendFormat:@"<locale>%@</locale>", frontIdentifier];
    [xmlStr appendString:@"</identifier>"];
    [xmlStr appendString:@"<identifier id=\"1\" >"];
    [xmlStr appendFormat:@"<name>%@</name>", backIdentifier];
    [xmlStr appendFormat:@"<locale>%@</locale>", backIdentifier];
    [xmlStr appendString:@"</identifier>"];
    [xmlStr appendString:@"</identifiers>"];
    
    [xmlStr appendString:@"<entries>"];
    int i = 0;
    for (NSArray *entry in self.entries) {
		[xmlStr appendFormat:@"<entry id=\"%@\">", [NSNumber numberWithInt:i]];
        [xmlStr appendString:@"<translation id=\"0\" >"];
        [xmlStr appendFormat:@"<text>%@</text>", [entry objectAtIndex:0]];
        [xmlStr appendString:@"</translation>"];
        [xmlStr appendString:@"<translation id=\"1\" >"];
        [xmlStr appendFormat:@"<text>%@</text>", [entry objectAtIndex:1]];
        [xmlStr appendString:@"</translation>"];
        [xmlStr appendString:@"</entry>"];
        ++i;
	}
   
    [xmlStr appendString:@"</entries>"];
    [xmlStr appendString:@"</kvtml>"];
    
    return xmlStr;
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
