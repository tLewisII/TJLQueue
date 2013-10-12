//
//  TJLQueue.h
//  TJLQueue
//
//  Created by Terry Lewis II on 10/12/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJLQueue : NSObject <NSFastEnumeration, NSCoding>

/**
 * Adds the object to the end of the list.
 * @param object The object to add, cannot be nil.
 */
- (void)__attribute__((nonnull(1))) addObject:(id)object;

/**
 * removes an object from the front of the queue and returns it.
 * @return the first object in the queue.
 */

- (id)remove;

/**
 * @return The first object in the queue without removing it.
 */
- (id)peek;

/**
 * @return A BOOL indicating if the queue contains any objects.
 */
- (BOOL)isEmpty;

/**
 * Converts the queue to an array without modifiying the queue.
 * @return An Array with all the elements of the queue.
 */
- (NSArray *)toArray;

/**
 * Invokes the given block for each item in the stack. does not modify the stack.
 @param block The block that will be invoked for each item in the stack.
 */
- (void)enumerateUsingBlock:(void (^)(id object, BOOL *stop))block;

/**
 * Asynchronously invokes the given block for each item in the stack. does not modify the stack.
 * This is not the same as using NSEnumerationConcurrent.
 @param block The block that will be invoked for each item in the stack.
 */
- (void)enumerateAsynchronouslyUsingBlock:(void (^)(id object, BOOL *stop))block;

/**
 * The number of items in the queue.
 */
@property(readonly, nonatomic) NSUInteger count;
@end
