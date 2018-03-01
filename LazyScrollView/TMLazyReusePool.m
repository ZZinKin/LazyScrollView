//
//  TMLazyReusePool.m
//  LazyScrollView
//
//  Copyright (c) 2015-2018 Alibaba. All rights reserved.
//

#import "TMLazyReusePool.h"
#import "UIView+TMLazyScrollView.h"

@interface TMLazyReusePool () {
    NSMutableDictionary<NSString *, NSMutableSet *> *_reuseDict;
}

@end

@implementation TMLazyReusePool

- (instancetype)init
{
    if (self = [super init]) {
        _reuseDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addItemView:(UIView *)itemView forReuseIdentifier:(NSString *)reuseIdentifier
{
    if (reuseIdentifier == nil || itemView == nil) {
        return;
    }
    NSMutableSet *reuseSet = [_reuseDict tm_safeObjectForKey:reuseIdentifier];
    if (!reuseSet) {
        reuseSet = [NSMutableSet set];
        [_reuseDict setObject:reuseSet forKey:reuseIdentifier];
    }
    [reuseSet addObject:itemView];
}

- (UIView *)dequeueItemViewForReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self dequeueItemViewForReuseIdentifier:reuseIdentifier andMuiID:nil];
}

- (UIView *)dequeueItemViewForReuseIdentifier:(NSString *)reuseIdentifier andMuiID:(NSString *)muiID
{
    if (reuseIdentifier == nil) {
        return nil;
    }
    UIView *result = nil;
    NSMutableSet *reuseSet = [_reuseDict tm_safeObjectForKey:reuseIdentifier];
    if (reuseSet && reuseSet.count > 0) {
        if (!muiID) {
            result = [reuseSet anyObject];
            [reuseSet removeObject:result];
        } else {
            for (UIView *itemView in reuseSet) {
                if ([itemView.muiID isEqualToString:muiID]) {
                    result = itemView;
                    break;
                }
            }
            if (result) {
                [reuseSet removeObject:result];
            }
        }
    }
    return result;
}

- (void)clear
{
    [_reuseDict removeAllObjects];
}

@end