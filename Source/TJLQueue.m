//
//  TJLQueue.m
//  TJLQueue
//
//  Created by Terry Lewis II on 10/12/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import "TJLQueue.h"


@interface TJLNode : NSObject
@property(strong, nonatomic) TJLNode *next;
@property(strong, nonatomic) id data;
@end

@implementation TJLNode
@end

@interface TJLQueue ()
@property(strong, nonatomic) TJLNode *head;
@property(strong, nonatomic) TJLNode *tail;
@property(nonatomic) NSUInteger size;
@property(nonatomic) unsigned long mutations;
@end

@implementation TJLQueue

- (instancetype)init {
    self = [super init];
    if(!self) {
        return nil;
    }

    _size = 0;
    _head = nil;
    _tail = nil;
    _mutations = 0;

    return self;
}

- (void)addObject:(id)object {
    NSAssert((object), @"Object cannot be nil.");
    if(!self.head && !self.tail) {
        TJLNode *first = [TJLNode new];
        first.data = object;
        self.head = first;
        self.tail = first;
    }
    else {
        TJLNode *next = [TJLNode new];
        next.data = object;
        self.head.next = next;
        self.head = next;
    }
    self.size++;
    self.mutations++;
}

- (id)remove {
    if(!self.isEmpty) {
        id object = self.tail.data;
        self.tail = self.tail.next;
        self.size--;
        self.mutations--;
        return object;
    }
    else {
        self.head = nil;
        return nil;
    }
}

- (id)peek {
    return self.tail.data;
}

- (BOOL)isEmpty {
    return self.tail == nil;
}

- (NSArray *)toArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    for(id object in self) {
        [array addObject:object];
    }
    return array;
}

- (void)enumerateUsingBlock:(void (^)(id object, BOOL *stop))block {
    [self enumerate:[block copy]];
}

- (void)enumerateAsynchronouslyUsingBlock:(void (^)(id object, BOOL *stop))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {
        [self enumerateUsingBlock:[block copy]];
    });
}

- (NSUInteger)count {
    return self.size;
}

- (void)enumerate:(void (^)(id object, BOOL *stop))block {
    BOOL stop = NO;
    for(id object in self) {
        if(stop) break;
        if(block) block(object, &stop);
    }
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    if(state->state == 0) { // first time
        state->state = 1; // Must set to non-zero
        state->mutationsPtr = &_mutations;  // Can't be NULL.
        state->extra[0] = (unsigned long)_tail;
    }
    TJLNode *scan = (__bridge TJLNode *)((void *)state->extra[0]);

    NSUInteger i;
    for(i = 0; i < len && scan != nil; i++) {
        buffer[i] = scan.data;
        scan = scan.next;
    }
    state->extra[0] = (unsigned long)scan;

    state->itemsPtr = buffer;

    return i;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.head forKey:@"head"];
    [coder encodeObject:self.tail forKey:@"tail"];
    [coder encodeInteger:self.size forKey:@"size"];
    [coder encodeInt:self.mutations forKey:@"mutations"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self.head = [coder decodeObjectForKey:@"head"];
    self.tail = [coder decodeObjectForKey:@"tail"];
    self.size = (NSUInteger)[coder decodeIntegerForKey:@"size"];
    self.mutations = (unsigned long)[coder decodeIntForKey:@"mutations"];

    return self;
}

@end
