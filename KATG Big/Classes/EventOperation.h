//
//  EventOperation.h
//  KATG
//
//  Copyright 2009 Doug Russell
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//  http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//  

@protocol EventOperationDelegate;

@interface EventOperation : NSOperation 
{
@public
	id<EventOperationDelegate> delegate;
@private
	NSDictionary    * _event;
	NSDateFormatter * _formatter;
	NSDateFormatter * _dayFormatter;
	NSDateFormatter * _dateFormatter;
	NSDateFormatter * _timeFormatter;
}

@property (nonatomic, assign) id<EventOperationDelegate> delegate;
@property (nonatomic, copy)   NSDictionary    * event;
@property (nonatomic, assign) NSDateFormatter * formatter;
@property (nonatomic, assign) NSDateFormatter * dayFormatter;
@property (nonatomic, assign) NSDateFormatter * dateFormatter;
@property (nonatomic, assign) NSDateFormatter * timeFormatter;

- (id)initWithEvent:(NSDictionary *)anEvent;

@end

@protocol EventOperationDelegate
- (NSManagedObjectContext *)managedObjectContext;
- (void)eventOperationDidFinishSuccesfully:(EventOperation *)op;
- (void)eventOperationDidFail;
@end
