//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Richard To on 12/28/12.
//  Copyright (c) 2012 Richard To. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;
- (void)clearOperands;
- (void)popOperand;
- (void)pushOperandOrOperator:(NSString *)operandOrOperator;

@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program
 usingVariableValues:(NSDictionary *)variableValues;
+ (NSSet *)variablesUsedInProgram:(id)program;
@end
