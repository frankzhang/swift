//===--- StringUTF16.swift ------------------------------------------------===//
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

extension String {
  public struct UTF16View : Sliceable, Reflectable {
    public var startIndex: Int {
      return 0
    }
    public var endIndex: Int {
      return _length
    }

    func _toInternalIndex(i: Int) -> Int {
      return _core.startIndex + _offset + i
    }

    // This is to avoid printing "func generate() -> GeneratorOf<UInt16>"
    public typealias _GeneratorType = GeneratorOf<UInt16>
    public typealias Generator = _GeneratorType

    public func generate() -> Generator {
      var index = startIndex
      return GeneratorOf<UInt16> {
        if _fastPath(index != self.endIndex) {
          return self[index++]
        }
        return .None
      }
    }

    public subscript(i: Int) -> Generator.Element {
      _precondition(i >= 0 && i < _length,
          "out-of-range access on a UTF16View")

      var index = _toInternalIndex(i)
      let u = _core[index]
      if _fastPath((u >> 11) != 0b1101_1) {
        // Neither high-surrogate, nor low-surrogate -- well-formed sequence
        // of 1 code unit.
        return u
      }

      if (u >> 10) == 0b1101_10 {
        // `u` is a high-surrogate.  SequenceType is well-formed if it
        // is followed by a low-surrogate.
        if _fastPath(
               index + 1 < _core.count &&
               (_core[index + 1] >> 10) == 0b1101_11) {
          return u
        }
        return 0xfffd
      }

      // `u` is a low-surrogate.  SequenceType is well-formed if
      // previous code unit is a high-surrogate.
      if _fastPath(index != 0 && (_core[index - 1] >> 10) == 0b1101_10) {
        return u
      }
      return 0xfffd
    }

    public subscript(subRange: Range<Int>) -> UTF16View {
      return UTF16View(_core, offset: _toInternalIndex(subRange.startIndex),
          length: subRange.endIndex - subRange.startIndex)
    }

    internal init(_ _core: _StringCore) {
      self._offset = 0
      self._length = _core.count
      self._core = _core
    }

    internal init(_ _core: _StringCore, offset: Int, length: Int) {
      self._offset = offset
      self._length = length
      self._core = _core
    }
    
    public func getMirror() -> MirrorType {
      return _UTF16ViewMirror(self)
    }

    var _offset: Int
    var _length: Int
    let _core: _StringCore
  }

  public var utf16: UTF16View {
    return UTF16View(core)
  }
}
