// These tests should crash.
// RUN: mkdir -p %t
// RUN: xcrun -sdk %target-sdk-name clang++ -arch %target-cpu %S/Inputs/CatchCrashes.cpp -c -o %t/CatchCrashes.o
// RUN: %target-build-swift %s -Xlinker %t/CatchCrashes.o -o %t/a.out
//
// RUN: %target-run %t/a.out fatal 2>&1 | FileCheck %s -check-prefix=CHECK_FATAL
// RUN: %target-run %t/a.out Bool 2>&1 | FileCheck %s -check-prefix=CHECK_BOOL
// RUN: %target-run %t/a.out LogicValueType 2>&1 | FileCheck %s -check-prefix=CHECK_LOGICVALUE

// REQUIRES: swift_stdlib_asserts

import Darwin

//===---
// Utilities.
//===---

struct Truthiness : LogicValueType {
  init(_ value: Bool) { self.value = value }
  func getLogicValue() -> Bool { return value }

  var value: Bool;
}
var falsie = Truthiness(false)
var truthie = Truthiness(true)

//===---
// Tests.
//===---

func test_fatalIsNoreturn() {
  enum EA {
    case A(Bool)
    case B
  }
  func f(e: EA) -> Bool {
    switch e {
    case .A(let res):
      return res
    case .B:
      _preconditionFailure("can not happen")
      // Don't need a return statement here because fatal() is @noreturn.
    }
  }
}

func test_fatal() {
  _preconditionFailure("this should fail")
  // CHECK_FATAL: fatal error: this should fail
  // CHECK_FATAL: CRASHED: SIG{{ILL|TRAP}}
}

if (Process.arguments[1] == "fatal") {
  test_fatal()
}


func test_securityCheckBool() {
  var x = 2
  _precondition(x * 21 == 42, "should not fail")
  println("OK")
  // CHECK_BOOL: OK
  _precondition(x == 42, "this should fail")
  // CHECK_BOOL-NEXT: fatal error: this should fail
  // CHECK_BOOL-NEXT: CRASHED: SIG{{ILL|TRAP}}
}

if (Process.arguments[1] == "Bool") {
  test_securityCheckBool()
}

func test_securityCheckLogicValue() {
  _precondition(truthie, "should not fail")
  println("OK")
  // CHECK_LOGICVALUE: OK
  _precondition(falsie, "this should fail")
  // CHECK_LOGICVALUE-NEXT: fatal error: this should fail
  // CHECK_LOGICVALUE-NEXT: CRASHED: SIG{{ILL|TRAP}}
}

if (Process.arguments[1] == "LogicValueType") {
  test_securityCheckLogicValue()
}

println("BUSTED: should have crashed already")
exit(1)
