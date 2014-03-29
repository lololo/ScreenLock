//
//  GLLockView.m
//  Lock
//
//  Created by Lei on 11/16/13.
//  Copyright (c) 2013 Lei. All rights reserved.
//

#import "GLLockView.h"

#define M_DOT_RADIUS    30
#define M_CHEST_WIDTH   300
#define M_CHEST_HEIGHT  300

#define M_DOT_COUNT     9

typedef enum {
    KDotTypeNormal      =   0,
    KDotTypeHighlight   =   1,
    KDotTypeSelected    =   2
} KDotType;

struct CGDot
{
    CGPoint center;
    KDotType type;
    int  mark;
};

struct CGDot * CGDot()
{
    struct CGDot *d;
    d = (struct CGDot *)malloc(sizeof(CGPoint) + sizeof(int)*2);
    return d;
}

void freeDot(struct CGDot *d)
{
    free(d);
}

void CGContextAddDot(CGContextRef c,struct CGDot d)
{
    CGContextSaveGState(c);
    if (d.type == KDotTypeHighlight) {
        CGContextSetFillColorWithColor(c, [UIColor blueColor].CGColor);
        CGContextAddArc(c, d.center.x, d.center.y, M_DOT_RADIUS, 0, M_PI*2, 1);
        CGContextFillPath(c);
        
        CGContextSetFillColorWithColor(c, [UIColor blackColor].CGColor);
        CGContextAddArc(c, d.center.x, d.center.y, M_DOT_RADIUS/3, 0, M_PI*2, 1);
        CGContextFillPath(c);
    }
    CGContextSetStrokeColorWithColor(c, [UIColor redColor].CGColor);
    CGContextAddArc(c, d.center.x, d.center.y, M_DOT_RADIUS, 0, M_PI*2, 1);
    CGContextStrokePath(c);
    CGContextRestoreGState(c);
}

bool CGContextDotIsTouched(struct CGDot d,CGPoint p)
{
    float distence = sqrt((d.center.x - p.x)*(d.center.x - p.x) + (d.center.y - p.y)*(d.center.y - p.y));
    return distence < M_DOT_RADIUS;
}

@interface GLLockView()
{
    struct CGDot *chest[M_DOT_COUNT];
    struct CGDot *sellectedDots[M_DOT_COUNT];
    CGPoint currentTouchPoint;
    NSInteger selectedNumber;
    bool isInitChest;
}

@end



@implementation GLLockView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        isInitChest = false;
        [self addSubview:self.displayTextLabe];
    }
    return self;
}

- (UILabel *)displayTextLabe
{
    if (!_displayTextLabe) {
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 320, 80)];
        [lb setFont:[UIFont systemFontOfSize:20]];
        [lb setBackgroundColor:[UIColor clearColor]];
        [lb setTextAlignment:NSTextAlignmentCenter];
        [lb setTextColor:[UIColor redColor]];
        _displayTextLabe = lb;
    }
    return _displayTextLabe;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef cxt = UIGraphicsGetCurrentContext();
   // static BOOL isInitChest = false;
    if (!isInitChest) {
        for (int index = 0; index < M_DOT_COUNT; index++) {
            int i = index%3;
            int j = index/3;
            
            float x = (self.frame.size.width - M_CHEST_WIDTH)/2 + 100*i + 50;
            float y = (self.frame.size.height - M_CHEST_HEIGHT)/2 + 100*j + 50;
            
            struct CGDot *d = CGDot();
            d -> center = CGPointMake(x,y);
            d -> type = KDotTypeNormal;
            d -> mark = index;
        
            chest[index] = d;
            selectedNumber = 0;
        }
        isInitChest = true;
    }
    for (int i = 0; i < M_DOT_COUNT; i++) {
        CGContextAddDot(cxt, *chest[i]);
    }
    [self drawLine:cxt];
    
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    currentTouchPoint = point;
    for (int i = 0; i < M_DOT_COUNT; i++) {
       // CGContextAddDot(cxt, *chest[i]);
        struct CGDot *d = chest[i];
        if (CGContextDotIsTouched(*d,point)) {
            d -> type = KDotTypeHighlight;
            //chest[i] = &d;
            sellectedDots[selectedNumber]=d;
            selectedNumber++;
            [self setNeedsDisplay];
            break;
        }
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    currentTouchPoint = point;
    for (int i = 0; i < M_DOT_COUNT; i++) {
        // CGContextAddDot(cxt, *chest[i]);
        struct CGDot *d = chest[i];
        if (CGContextDotIsTouched(*d,point) && d->type == KDotTypeNormal) {
            d -> type = KDotTypeHighlight;
            //chest[i] = &d;
            sellectedDots[selectedNumber]=d;
            selectedNumber++;
            break;
        }
    }
    [self setNeedsDisplay];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    currentTouchPoint = CGPointZero;
    [self clearLines];
    [self setNeedsDisplay];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    currentTouchPoint = CGPointZero;
    [self clearLines];
    [self setNeedsDisplay];
}

- (void)dealloc
{
    for (int i = 0; i < M_DOT_COUNT; i++) {
        // CGContextAddDot(cxt, *chest[i]);
        struct CGDot *d = chest[i];
        freeDot(d);
    }
    
}

- (void)drawLine:(CGContextRef) ctx
{
    if (selectedNumber > 0) {
        CGContextSaveGState(ctx);
        CGContextSetLineWidth(ctx, M_DOT_RADIUS/3);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        CGContextSetLineJoin(ctx, kCGLineJoinRound);
        CGContextMoveToPoint(ctx, sellectedDots[0]->center.x, sellectedDots[0]->center.y);
        
        for (int index = 1; index < selectedNumber; index++) {
            CGContextAddLineToPoint(ctx, sellectedDots[index]->center.x, sellectedDots[index]->center.y);
        }
        CGContextAddLineToPoint(ctx, currentTouchPoint.x, currentTouchPoint.y);
        CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
        CGContextStrokePath(ctx);
        CGContextRestoreGState(ctx);
    }
}

- (void)clearLines
{
    NSMutableString *sRes = [[NSMutableString alloc] init];
    for (int i = 0; i<selectedNumber; i++) {
        //printf("%i ",sellectedDots[i]->mark);
        [sRes appendString:[@(sellectedDots[i]->mark) stringValue]];
        sellectedDots[i] = NULL;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(lockViewResult:)]) {
        [self.delegate lockViewResult:sRes];
    }
    
    selectedNumber = 0;
    for (int i = 0; i<M_DOT_COUNT; i++) {
        struct CGDot *d = chest[i];
        if (d->type != KDotTypeNormal) {
            d->type = KDotTypeNormal;
        }
    }
}
@end


