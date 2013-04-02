//===-- Frontend.h - frontend utility methods ----------------------------===//
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
//
// This file contains declarations of utility methods for parsing and
// performing semantic on modules.
//
//===----------------------------------------------------------------------===//

#include <string>
#include <vector>

namespace swift {
  class ASTContext;
  class TranslationUnit;
  class REPLContext;
  
  TranslationUnit* buildSingleTranslationUnit(ASTContext &Context,
                                              std::string OutputName,
                                              std::vector<unsigned> BufferIDs,
                                              bool ParseOnly,
                                              bool IsMainModule);

  bool appendToREPLTranslationUnit(TranslationUnit *TU,
                                   REPLContext &RC,
                                   unsigned &BufferOffset,
                                   unsigned BufferEndOffset);
}
