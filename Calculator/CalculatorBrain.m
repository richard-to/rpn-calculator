//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Richard To on 12/28/12.
//  Copyright (c) 2012 Richard To. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
{
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (id)program
{
    return [self.programStack copy];
}

- (void)pushOperandOrOperator:(NSString *)operand
{
    [self.programStack addObject: operand];
}

- (void)pushOperand:(double)operand
{
    [self.programStack addObject: [NSNumber numberWithDouble:operand]];
}

- (void)popOperand {
    id topOfStack = [self.programStack lastObject];
    if (topOfStack) [self.programStack removeLastObject];
}

- (void)clearOperands {
    [self.programStack removeAllObjects];
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program
                usingVariableValues: [[NSDictionary alloc] init]];
}

+ (NSString *)popDescriptionOffProgramStack:(NSMutableArray *)stack
{
    NSString *description = [[NSString alloc] init];

    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        description = [description stringByAppendingFormat:@"%@", topOfStack];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        NSCharacterSet *numericOnly = [NSCharacterSet decimalDigitCharacterSet];
        NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString: operation];
        
        if ([numericOnly isSupersetOfSet: myStringSet]) {
            description = [description stringByAppendingString:operation];
        } else if ([operation isEqualToString:@"pi"]) {
            description = [description stringByAppendingFormat:@"%@", operation];
        } else if ([operation isEqualToString:@"sin"]) {
            NSString * equation = [self removeParens:[self popDescriptionOffProgramStack: stack]];
            description = [description stringByAppendingFormat:@"sin(%@)", equation];
        } else if ([operation isEqualToString:@"cos"]) {
            NSString * equation = [self removeParens:[self popDescriptionOffProgramStack: stack]];
            description = [description stringByAppendingFormat:@"cos(%@)", equation];
        } else if ([operation isEqualToString:@"sqrt"]) {
            NSString * equation = [self removeParens:[self popDescriptionOffProgramStack: stack]];
            description = [description stringByAppendingFormat:@"sqrt(%@)", equation];
        } else if ([operation isEqualToString:@"+"]) {
            NSString *operator = [self popDescriptionOffProgramStack: stack];
            description = [description stringByAppendingFormat:@"(%@ + %@)",
                [self popDescriptionOffProgramStack: stack],
                operator];
        } else if ([@"*" isEqualToString:operation]) {
            NSString *operator = [self popDescriptionOffProgramStack: stack];
            description = [description stringByAppendingFormat:@"(%@ * %@)",
                           [self popDescriptionOffProgramStack: stack],
                           operator];
        } else if ([operation isEqualToString:@"-"]) {
            NSString *subtrahend = [self popDescriptionOffProgramStack: stack];
            description = [description stringByAppendingFormat:@"(%@ - %@)",
                           [self popDescriptionOffProgramStack: stack],
                           subtrahend];
        } else if ([operation isEqualToString:@"/"]) {
            NSString *divisor = [self popDescriptionOffProgramStack: stack];
            description = [description stringByAppendingFormat:@"(%@ / %@)",
                           [self popDescriptionOffProgramStack: stack],
                           divisor];
        } else {
            description = [description stringByAppendingString:operation];
        }
    }
    return description;
}

+ (NSString *)descriptionOfProgram:(id)program
{
    NSMutableArray *eqStack = [[NSMutableArray alloc] init];
    NSMutableArray *stack;
    
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    eqStack = [[self class] buildProgramDescription:stack
                                  withEquationStack:eqStack];
    return [eqStack componentsJoinedByString: @", "];
}

+ (NSString *) removeParens:(NSString *)result
{
    if ([result characterAtIndex:0] == '(' &&
        [result characterAtIndex:result.length - 1] == ')') {
        result = [result substringWithRange: NSMakeRange(1, [result length] - 2)];
    }
    return result;
}
+ (NSMutableArray *)buildProgramDescription:(NSMutableArray *)stack
                          withEquationStack:(NSMutableArray *)eqStack
{
    if ([stack count] == 0) {
        return eqStack;
    } else {      
        [eqStack addObject: [self removeParens:[self popDescriptionOffProgramStack: stack]]];
        return [self buildProgramDescription: stack withEquationStack: eqStack];
    }
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
                usingVariableValues:(NSDictionary *)varDict
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        NSCharacterSet *numericOnly = [NSCharacterSet decimalDigitCharacterSet];
        NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString: operation];
        
        if ([numericOnly isSupersetOfSet: myStringSet]) {
            result = [operation doubleValue];
        } else if ([operation isEqualToString:@"pi"]) {
            result = M_PI;
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffProgramStack:stack
                                     usingVariableValues: varDict]);
            
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffProgramStack:stack
                                     usingVariableValues: varDict]);
        } else if ([operation isEqualToString:@"sqrt"]) {
            double number = [self popOperandOffProgramStack:stack
                                        usingVariableValues: varDict];
            if (number > 0) {
                result = sqrt(number);
            }
        } else if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack
                                 usingVariableValues: varDict] +
            [self popOperandOffProgramStack:stack
                        usingVariableValues: varDict];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack
                                 usingVariableValues: varDict] *
            [self popOperandOffProgramStack:stack
                        usingVariableValues: varDict];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack
                                            usingVariableValues: varDict];
            result = [self popOperandOffProgramStack:stack
                                 usingVariableValues: varDict] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack
                                         usingVariableValues: varDict];
            if (divisor) result = [self popOperandOffProgramStack:stack
                                              usingVariableValues: varDict] / divisor;
        } else {
            NSNumber *value = [varDict valueForKey:operation];
            if (value) {
                result = [value doubleValue];
            }
        }
    }
    
    return result;
}


+ (void)findVariablesInProgram:(NSMutableArray *)stack
                       withOps: (NSSet *)opsSet
                         inSet: (NSMutableSet *)varSet {
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSString class]] &&
            [opsSet containsObject:topOfStack] == NO) {
        [varSet addObject:topOfStack];
    }
    
    if ([stack count] > 0) {
        [[self class] findVariablesInProgram:stack
                                     withOps:opsSet
                                       inSet:varSet];
    }
}

+ (double)runProgram:(id)program
{
    return [self runProgram:program
        usingVariableValues:[[NSDictionary alloc] init]];
}

+ (double)runProgram:(id)program
  usingVariableValues:(NSDictionary *)varDict
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    NSDictionary *dict = [varDict copy];
    return [self popOperandOffProgramStack:stack usingVariableValues:dict];
}

+ (NSSet *)variablesUsedInProgram:(id)program
{
    NSMutableArray *stack = [[NSMutableArray alloc] init];
    NSMutableSet *varSet = [[NSMutableSet alloc] init];
    NSSet *opsSet = [[NSSet alloc] initWithObjects:
                     @"cos", @"sin", @"pi", @"sqrt", @"+", @"-", @"/", @"*", nil];
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    [self findVariablesInProgram:stack withOps: opsSet inSet:varSet];
    
    if ([varSet count] > 0) {
        return [varSet copy];
    } else {
        return nil;
    }
}

@end