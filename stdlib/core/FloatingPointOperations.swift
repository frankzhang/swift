//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2015 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

public enum FloatingPointClassification {
  case SignalingNaN
  case QuietNaN
  case NegativeInfinity
  case NegativeNormal
  case NegativeSubnormal
  case NegativeZero
  case PositiveZero
  case PositiveSubnormal
  case PositiveNormal
  case PositiveInfinity
}


extension FloatingPointClassification : Equatable {}
public 
func ==(lhs: FloatingPointClassification, rhs: FloatingPointClassification) -> Bool {
  switch (lhs, rhs) {
  case (.SignalingNaN, .SignalingNaN),
       (.QuietNaN, .QuietNaN),
       (.NegativeInfinity, .NegativeInfinity),
       (.NegativeNormal, .NegativeNormal),
       (.NegativeSubnormal, .NegativeSubnormal),
       (.NegativeZero, .NegativeZero),
       (.PositiveZero, .PositiveZero),
       (.PositiveSubnormal, .PositiveSubnormal),
       (.PositiveNormal, .PositiveNormal),
       (.PositiveInfinity, .PositiveInfinity):
    return true

  default:
    return false
  }
}

public protocol FloatingPointNumberType : Strideable {
  typealias _BitsType
  class func _fromBitPattern(bits: _BitsType) -> Self
  func _toBitPattern() -> _BitsType

  /// The positive infinity.
  class var infinity: Self { get }

  /// A quiet NaN.
  class var NaN: Self { get }

  /// A quiet NaN.
  class var quietNaN: Self { get }

  /// @{
  /// IEEE 754-2008 Non-computational operations.

  // IEEE 754 calls this 'class', but this name is a keyword, and is too
  // general.
  var floatingPointClass: FloatingPointClassification { get }

  /// Returns true if this number has a negative sign.
  var isSignMinus: Bool { get }

  /// Returns true if this number is normal (not zero, subnormal, infinity, or
  /// NaN).
  var isNormal: Bool { get }

  /// Returns true if this number is zero, subnormal, or normal (not infinity
  /// or NaN).
  var isFinite: Bool { get }

  /// Returns true if this number is +0.0 or -0.0.
  var isZero: Bool { get }

  /// Returns true if this number is subnormal.
  var isSubnormal: Bool { get }

  /// Returns true if this number is infinity.
  var isInfinite: Bool { get }

  /// Returns true if this number is NaN.
  var isNaN: Bool { get }

  /// Returns true if this number is a signaling NaN.
  var isSignaling: Bool { get }

  // Not implemented, because it only makes sense for decimal floating point.
  // Binary floating point numbers are always canonical.
  // func isCanonical() -> Bool

  /// @}
}
