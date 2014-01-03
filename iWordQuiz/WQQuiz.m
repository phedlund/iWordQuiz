//
//  WQQuiz.m
//  iWordQuiz
//

/************************************************************************

Copyright 2012-2013 Peter Hedlund peter.hedlund@me.com

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

#import "WQQuiz.h"
#import "WQQuizItem.h"
#import "WQUtils.h"

@implementation WQQuiz

@synthesize entries;
@synthesize frontIdentifier;
@synthesize backIdentifier;
@synthesize quizMode = m_quizMode;
@synthesize correctCount = m_correctCount;
@synthesize errorCount = m_errorCount;
@synthesize fileName;
@synthesize quizType = _quizType;

- init {
	if(![super init]){
		return nil;
	}
	
    frontIdentifier = @"Front";
    backIdentifier = @"Back";
    
    entries = [[NSMutableArray alloc] init];
	m_list = [[NSMutableArray alloc] init];
	m_errorList = [[NSMutableArray alloc] init];
	
	return self;
}

int randomSort(id obj1, id obj2, void *context ) {
	// returns random number -1 0 1
	return (random()%3 - 1);	
}


int rand_lim(int limit) {
	/* return a random number between 0 and limit inclusive.
	 */
	
    int divisor = RAND_MAX/(limit+1);
    int retval;
	
    do { 
        retval = rand() / divisor;
    } while (retval > limit);
	
    return retval;
}

- (void) activateErrorList
{
	[m_list removeAllObjects];
	for (NSArray *entry in m_errorList) {
		[m_list addObject:entry];
	}
	
	[m_errorList removeAllObjects];
	
	m_questionCount = [m_list count];
	m_currentQuestion = 0;
	m_correctCount = 0;
	m_errorCount = 0;
}

- (void) activateBaseList
{
	[m_list removeAllObjects];
	[m_errorList removeAllObjects];
	
	for (NSArray *entry in self.entries) {
        WQQuizItem *item = [[WQQuizItem alloc] init];
        if ([WQUtils isOdd:self.quizMode]) {
            item.frontIdentifier = [self frontIdentifier];
            item.backIdentifier = [self backIdentifier];
            item.front = [entry objectAtIndex:0];
            item.back = [entry objectAtIndex:1];
            if (self.quizMode == 5) {
                WQQuizItem *itemReverse = [[WQQuizItem alloc] init];
                itemReverse.frontIdentifier = [self backIdentifier];
                itemReverse.backIdentifier = [self frontIdentifier];
                itemReverse.front = [entry objectAtIndex:1];
                itemReverse.back = [entry objectAtIndex:0];
                [m_list addObject:itemReverse];
            }
        }
        else {
            item.frontIdentifier = [self backIdentifier];
            item.backIdentifier = [self frontIdentifier];
            item.front = [entry objectAtIndex:1];
            item.back = [entry objectAtIndex:0];
        }
        [m_list addObject:item];
	}
    
	if (self.quizMode > 2) {
		[m_list sortUsingFunction:randomSort context:nil];
	}
	
	m_questionCount = [m_list count];
	m_currentQuestion = 0;
	m_correctCount = 0;
	m_errorCount = 0;
}

- (void) finish
{}

- (void) toNext
{
	++m_currentQuestion;
}

- (bool) atEnd
{
	return m_currentQuestion >= [self questionCount];
}

- (bool) checkAnswer:(NSString *)anAnswer
{
	bool result = false;
	result = [anAnswer isEqualToString:[self answer]];
 
	if (!result) {
		[m_errorList addObject:[m_list objectAtIndex:m_currentQuestion]];
	}
 
	return result;
}

- (bool) hasErrors
{
	bool result = false;
    switch (_quizType) {
        case WQQuizTypeFC:
            result = ([m_errorList count] > 0);
            break;
        case WQQuizTypeMC:
            result = ([m_errorList count] > 2);
            break;
        case WQQuizTypeQA:
            result = ([m_errorList count] > 0);
            break;
        default:
            result = false;
            break;
    }
    return result;
}


- (NSString*) question
{
    WQQuizItem *item = (WQQuizItem*)[m_list objectAtIndex:m_currentQuestion];
    return item.front;
}

- (NSString*) answer
{
    WQQuizItem *item = (WQQuizItem*)[m_list objectAtIndex:m_currentQuestion];
    return item.back;
}

- (int) questionCount
{
	return m_questionCount;
}

- (NSString*) langQuestion
{
    WQQuizItem *item = (WQQuizItem*)[m_list objectAtIndex:m_currentQuestion];
	return item.frontIdentifier;
}


- (NSString*) langAnswer
{
    WQQuizItem *item = (WQQuizItem*)[m_list objectAtIndex:m_currentQuestion];
	return item.backIdentifier;
}

- (void) countIncrement:(int )aValue {
	if (aValue == 1) {
		m_correctCount++;
	}
	if (aValue == -1) {
		m_errorCount++;
	}
}

- (NSArray *) multiOptions {
	
	NSArray * result;
	NSString * mo1;
	NSString * mo2;
	NSString * mo3;
	
	int a = -1;
	int b = -1;
	
	do
		a = rand_lim(m_questionCount - 1);
	while(a == m_currentQuestion);
	
	do
		b = rand_lim(m_questionCount - 1);
	while(b == m_currentQuestion || b == a);

    WQQuizItem *item = (WQQuizItem*)[m_list objectAtIndex:m_currentQuestion];
    mo1 = item.back;
    item = (WQQuizItem*)[m_list objectAtIndex:a];
    mo2 = item.back;
    item = (WQQuizItem*)[m_list objectAtIndex:b];
    mo3 = item.back;
	result = @[mo1, mo2, mo3];
	
	return [result sortedArrayUsingFunction:randomSort context:nil];
}

- (void)dealloc {
    [entries removeAllObjects];
}

@end
