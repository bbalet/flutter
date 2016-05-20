// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:calculator/calc_expression.dart';
import 'package:test/test.dart';

void main() {
  test('Test order of operations: 12 + 3 * 4 = 24', () {
    CalcExpression expression = new CalcExpression.Empty();
    expression = expression.appendDigit(1);
    expression = expression.appendDigit(2);
    expression = expression.appendOperation(Operation.Addition);
    expression = expression.appendDigit(3);
    expression = expression.appendOperation(Operation.Multiplication);
    expression = expression.appendDigit(4);
    expression = expression.computeResult();
    expect(expression.state, equals(ExpressionState.Result));
    expect(expression.toString(), equals("24"));
  });

  test('Test floating point 0.1 + 0.2 = 0.3', () {
    CalcExpression expression = new CalcExpression.Empty();
    expression = expression.appendDigit(0);
    expression = expression.appendPoint();
    expression = expression.appendDigit(1);
    expression = expression.appendOperation(Operation.Addition);
    expression = expression.appendDigit(0);
    expression = expression.appendPoint();
    expression = expression.appendDigit(2);
    expression = expression.computeResult();
    expect(expression.state, equals(ExpressionState.Result));
    expect(expression.toString(), equals("0.3"));
  });

  test('Test floating point 1.0/10.0 = 0.1', () {
    CalcExpression expression = new CalcExpression.Empty();
    expression = expression.appendDigit(1);
    expression = expression.appendPoint();
    expression = expression.appendDigit(0);
    expression = expression.appendOperation(Operation.Division);
    expression = expression.appendDigit(1);
    expression = expression.appendDigit(0);
    expression = expression.appendPoint();
    expression = expression.appendDigit(0);
    expression = expression.computeResult();
    expect(expression.state, equals(ExpressionState.Result));
    expect(expression.toString(), equals("0.1"));
  });

  test('Test 1/0 = Infinity', () {
    CalcExpression expression = new CalcExpression.Empty();
    expression = expression.appendDigit(1);
    expression = expression.appendOperation(Operation.Division);
    expression = expression.appendDigit(0);
    expression = expression.computeResult();
    expect(expression.state, equals(ExpressionState.Result));
    expect(expression.toString(), equals("Infinity"));
  });

  test('Test use result in next calculation: 1 + 1 = 2 + 1 = 3 + 1 = 4', () {
    CalcExpression expression = new CalcExpression.Empty();
    expression = expression.appendDigit(1);
    expression = expression.appendOperation(Operation.Addition);
    expression = expression.appendDigit(1);
    expression = expression.computeResult();
    expression = expression.appendOperation(Operation.Addition);
    expression = expression.appendDigit(1);
    expression = expression.computeResult();
    expression = expression.appendOperation(Operation.Addition);
    expression = expression.appendDigit(1);
    expression = expression.computeResult();
    expect(expression.state, equals(ExpressionState.Result));
    expect(expression.toString(), equals("4"));
  });

  test('Test minus -3 - -2 = -1', () {
    CalcExpression expression = new CalcExpression.Empty();
    expression = expression.appendMinus();
    expression = expression.appendDigit(3);
    expression = expression.appendMinus();
    expression = expression.appendMinus();
    expression = expression.appendDigit(2);
    expression = expression.computeResult();
    expect(expression.state, equals(ExpressionState.Result));
    expect(expression.toString(), equals("-1"));
  });
}