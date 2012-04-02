//
//  iWQQuiz.m
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

#import "iWQQuiz.h"
#import "WQUtils.h"

@implementation iWQQuiz

@synthesize entries;
@synthesize frontIdentifier;
@synthesize backIdentifier;
@synthesize quizMode = m_quizMode;
@synthesize correctCount = m_correctCount;
@synthesize errorCount = m_errorCount;
@synthesize fileName;

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


- (int) column:(int )aColumn
{
	int result = 0;
    if ([WQUtils isOdd:self.quizMode])
        result = 1;
    return result;
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
		[m_list addObject:entry];
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
	NSString * ans = anAnswer;
	NSString *correctAnswer = [self answer];
	
	result = [ans isEqualToString:correctAnswer];
 
	if (!result) {
		[m_errorList addObject:[m_list objectAtIndex:m_currentQuestion]];
	}
 
	return result;
}

- (bool) hasErrors
{
	return ([m_errorList count] > 0);
}


- (NSString*) question
{
	NSString * result;

    if ([WQUtils isOdd:self.quizMode]) {
		
		result = [[m_list objectAtIndex:m_currentQuestion] objectAtIndex:0];
	}
	else {
		result = [[m_list objectAtIndex:m_currentQuestion] objectAtIndex:1];
	}

    return result;
}

- (NSString*) answer
{
	NSString * result;
	
    if ([WQUtils isOdd:self.quizMode]) {
		
		result = [[m_list objectAtIndex:m_currentQuestion] objectAtIndex:1];
	}
	else {
		result = [[m_list objectAtIndex:m_currentQuestion] objectAtIndex:0];
	}
	
    return result;

}


- (void) setQuizType:(int )aQuizType
{
	m_quizType = aQuizType;
}

- (int) questionCount
{
	return m_questionCount;
}

- (NSString*) langQuestion
{
	NSString * result;
	//NSLog(@"langQuestion %@", [self backIdentifier]);
	if ([WQUtils isOdd:self.quizMode]) {
		result = [self frontIdentifier];
	}
	else {
		result = [self backIdentifier];
	}
	//NSLog(@"langQuestion %@", result);
	
	return result;
}


- (NSString*) langAnswer
{
	NSString * result;
	//NSLog(@"langAnswer %@", [self frontIdentifier]);
	if ([WQUtils isOdd:self.quizMode]) {
		result = [self backIdentifier];
	}
	else {
		result = [self frontIdentifier];
	}
	//NSLog(@"langAnswer %@", result);

	return result;
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
	
    if ([WQUtils isOdd:self.quizMode]) {
		mo1 = [[m_list objectAtIndex:m_currentQuestion] objectAtIndex:1];
		mo2 = [[m_list objectAtIndex:a] objectAtIndex:1];
		mo3 = [[m_list objectAtIndex:b] objectAtIndex:1];
	}
	else {
		mo1 = [[m_list objectAtIndex:m_currentQuestion] objectAtIndex:0];
		mo2 = [[m_list objectAtIndex:a] objectAtIndex:0];
		mo3 = [[m_list objectAtIndex:b] objectAtIndex:0];
	}
	
	result = [NSArray arrayWithObjects:mo1, mo2, mo3, nil];
	
	return [result sortedArrayUsingFunction:randomSort context:nil];
}

- (void)dealloc {
    [entries removeAllObjects];
    [entries release];
    [m_list release];
	[m_errorList release];
    [frontIdentifier release];
    [backIdentifier release];
    [fileName release];
    
    [super dealloc];
}

@end
