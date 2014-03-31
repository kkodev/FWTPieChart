//
//  FWTPieChartView.m
//  FWTEnhancedPieChartView
//
//  Created by Carlos Vidal on 27/03/2014.
//
//

#import "FWTPieChartView.h"
#import "FWTPieChartLayer.h"
#import <QuartzCore/QuartzCore.h>


@interface FWTPieChartSegmentData()

@end

@implementation FWTPieChartSegmentData

+ (FWTPieChartSegmentData*)pieChartSegmentWithValue:(NSNumber*)value
                                              color:(UIColor*)color
                                          innerText:(NSString*)innerText
                                       andOuterText:(NSString*)outterText
{
    FWTPieChartSegmentData *segmentData = [[FWTPieChartSegmentData alloc] init];
    segmentData.value = value != nil ? value : @(0.f);
    segmentData.color = color != nil ? color : [UIColor whiteColor];
    segmentData.innerText = innerText != nil ? innerText : @"";
    segmentData.outterText = outterText != nil ? outterText : @"";
    
    return segmentData;
}

@end



CGFloat FLOAT_M_PI_ = 3.141592653f;

@interface FWTPieChartView ()

@property (nonatomic, strong) CALayer *containerLayer;

@property (nonatomic, strong) NSArray *segments;

@end

@implementation FWTPieChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self != nil){
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - Public methods
- (void)addSegment:(FWTPieChartSegmentData*)segmentData
{
    NSMutableArray *segmentsTemp = [NSMutableArray arrayWithArray:self.segments];
    [segmentsTemp addObject:segmentData];
    
    self.segments = segmentsTemp;
}

- (FWTPieChartSegmentData*)addSegmentWithValue:(NSNumber*)value color:(UIColor*)color innerText:(NSString*)innerText andOutterText:(NSString*)outterText
{
    FWTPieChartSegmentData *segmentData = [FWTPieChartSegmentData pieChartSegmentWithValue:value color:color innerText:innerText andOuterText:outterText];
    [self addSegment:segmentData];
    
    return segmentData;
}

- (void)removeSegment:(FWTPieChartSegmentData*)segmentData
{
    NSMutableArray *segmentsTemp = [NSMutableArray arrayWithArray:self.segments];
    
    if ([segmentsTemp containsObject:segmentData]){
        [segmentsTemp removeObject:segmentData];
    }
    
    self.segments = segmentsTemp;
}

- (void)clearSegments
{
    NSMutableArray *segmentsTemp = [NSMutableArray arrayWithArray:self.segments];
    [segmentsTemp removeAllObjects];
    
    self.segments = segmentsTemp;
}

- (void)reloadAnimated:(BOOL)animated
{
    FWTPieChartLayer *pieLayer = self.containerLayer.sublayers.firstObject;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    pieLayer.values = [self _values];
    pieLayer.colors = [self _colors];
    
    [CATransaction commit];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    CABasicAnimation *animation = (CABasicAnimation *)[pieLayer actionForKey:@"animationCompletionPercent"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = animated ? @0.f : @1.f;
    animation.toValue = @1.f;
    animation.byValue = @0.1f;
    
    [pieLayer setAnimationCompletionPercent:((NSNumber*)animation.toValue).floatValue];
    [pieLayer addAnimation:animation forKey:@"animationCompletionPercent"];
    
    [CATransaction commit];
}

#pragma mark - Private methods
- (NSArray*)_values
{
    NSMutableArray *array = [NSMutableArray array];
    for (FWTPieChartSegmentData *data in self.segments){
        [array addObject:data.value];
    }
    return array;
}

- (NSArray*)_colors
{
    NSMutableArray *array = [NSMutableArray array];
    for (FWTPieChartSegmentData *data in self.segments){
        [array addObject:data.color];
    }
    return array;
}

- (NSArray*)_innerTexts
{
    NSMutableArray *array = [NSMutableArray array];
    for (FWTPieChartSegmentData *data in self.segments){
        [array addObject:data.innerText];
    }
    return array;
}

- (NSArray*)_outterTexts
{
    NSMutableArray *array = [NSMutableArray array];
    for (FWTPieChartSegmentData *data in self.segments){
        [array addObject:data.outterText];
    }
    return array;
}

#pragma mark - Lazy loading
- (CALayer *)containerLayer
{
    if (self->_containerLayer == nil){
        self->_containerLayer = [[CALayer alloc] init];
        self->_containerLayer.frame = self.bounds;
        
        FWTPieChartLayer *portionLayer = [[FWTPieChartLayer alloc] init];
        portionLayer.startAngle = -FLOAT_M_PI_ / 2;
        portionLayer.values = [self _values];
        portionLayer.colors = [self _colors];
        portionLayer.contentsScale = [UIScreen mainScreen].scale;
        portionLayer.frame = self->_containerLayer.frame;
        
        [self->_containerLayer addSublayer:portionLayer];
    }
    
    if (self->_containerLayer.superlayer == nil){
        [self.layer addSublayer:self->_containerLayer];
    }
    
    return self->_containerLayer;
}

@end
