//
//  FWTPieChartExampleViewController.m
//  FWTEnhancedPieChartView
//
//  Created by Carlos Vidal on 27/03/2014.
//
//

#import "FWTPieChartExampleViewController.h"
#import "FWTPieChartView.h"

@interface FWTPieChartExampleViewController ()

@property (nonatomic, strong) FWTPieChartView *pieChartView;

@end

@implementation FWTPieChartExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Remastered FWTPieChartView";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    FWTPieChartSegmentData *firstSegment = [FWTPieChartSegmentData pieChartSegmentWithValue:@0.22f
                                                                                      color:[UIColor colorWithRed:22/255.f green:86/255.f blue:219/255.f alpha:1]
                                                                                  innerText:@"A"
                                                                               andOuterText:@"2"];
    FWTPieChartSegmentData *secondSegment = [FWTPieChartSegmentData pieChartSegmentWithValue:@0.44f
                                                                                      color:[UIColor colorWithRed:235/255.f green:81/255.f blue:29/255.f alpha:1]
                                                                                  innerText:@"B"
                                                                               andOuterText:@"4"];
    FWTPieChartSegmentData *thirdSegment = [FWTPieChartSegmentData pieChartSegmentWithValue:@0.34f
                                                                                      color:[UIColor colorWithRed:98/255.f green:200/255.f blue:24/255.f alpha:1]
                                                                                  innerText:@"C"
                                                                               andOuterText:@"3"];
    
    [self.pieChartView addSegment:firstSegment];
    [self.pieChartView addSegment:secondSegment];
    [self.pieChartView addSegment:thirdSegment];
    
    [self.pieChartView reloadAnimated:YES];
}

- (IBAction)_zoomIn:(id)sender
{
    [self.pieChartView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.pieChartView.frame)+20)];
    self.pieChartView.center = self.view.center;
}

- (IBAction)_zoomOut:(id)sender
{
    [self.pieChartView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.pieChartView.frame)-20)];
    
    self.pieChartView.center = self.view.center;
}

- (IBAction)_performAnimation:(id)sender
{
    [self.pieChartView reloadAnimated:YES];
}

#pragma mark - Lazy loading
- (FWTPieChartView*)pieChartView
{
    if (self->_pieChartView == nil){
        self->_pieChartView = [[FWTPieChartView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 300)];
        self->_pieChartView.center = self.view.center;
    }
    
    if (self->_pieChartView.superview == nil){
        [self.view addSubview:self->_pieChartView];
    }
    
    return self->_pieChartView;
}

@end
