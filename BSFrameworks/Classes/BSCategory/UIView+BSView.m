//
//  UIView+BSView.m
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/5/21.
//

#import "UIView+BSView.h"

@implementation UIView (BSView)


#pragma mark - top
-(CGFloat)top{
    
    return self.frame.origin.y;
}

-(void)setTop:(CGFloat)top{
    
    CGRect frame = self.frame;
    frame.origin.y = top;
    
    self.frame = frame;
}


#pragma mark - bottom

-(CGFloat)bottom{
    
    return self.frame.origin.y + self.frame.size.height;
}


-(void)setBottom:(CGFloat)bottom{
    
    CGRect frame = self.frame;
    frame.origin.y = bottom - self.frame.size.height;
    
    self.frame = frame;
}


#pragma mark - left

-(CGFloat)left{
    
    return self.frame.origin.x;
}


-(void)setLeft:(CGFloat)left{
    
    CGRect frame = self.frame;
    frame.origin.x = left;
    
    self.frame = frame;
}


#pragma mark - right

-(CGFloat)right{
    
    return self.frame.origin.x + self.frame.size.width;
}


-(void)setRight:(CGFloat)right{
    
    CGRect frame = self.frame;
    frame.origin.x = right - self.frame.size.width;
    
    self.frame = frame;
}


#pragma mark - width

-(CGFloat)width{
    
    return self.frame.size.width;
}


-(void)setWidth:(CGFloat)width{
    
    CGRect frame = self.frame;
    frame.size.width = width;
    
    self.frame = frame;
}


#pragma mark - height

-(CGFloat)height{
    
    return self.frame.size.height;
}


-(void)setHeight:(CGFloat)height{
    
    CGRect frame = self.frame;
    frame.size.height = height;
    
    self.frame = frame;
}


#pragma mark - centerX

-(CGFloat)centerX{
    
    CGRect frame = self.frame;
    CGFloat X = frame.origin.x + self.frame.size.width/2;
    
    return X;
}

-(void)setCenterX:(CGFloat)centerX{
    
    CGRect frame = self.frame;
    frame.origin.x = centerX - self.frame.size.width/2;
    
    self.frame = frame;
}


#pragma mark - centerY

-(CGFloat)centerY{
    
    CGRect frame = self.frame;
    CGFloat Y = frame.origin.y + self.frame.size.height/2;
    
    return Y;
}

-(void)setCenterY:(CGFloat)centerY{
    
    CGRect frame = self.frame;
    frame.origin.y = centerY - self.frame.size.height/2;
    
    self.frame = frame;
}




@end
