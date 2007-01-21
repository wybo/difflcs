#--#
# Author: Wybo Wiersma <wybo@logilogi.org>
#
# Copyright: (c) 2006 Wybo Wiersma
#
# License:
#   This file is part of the Diff-LongestCommonSubString library. Diff-
#   LongestCommonSubString is free software. You can run/distribute/modify Diff-
#   LongestCommonSubString under the terms of the GNU General Public License 
#   version 3, or any later version, with the extra copyleft provision (covered 
#   by subsection 7b of the GPL v3) that running a modified version or a
#   derivative work also requires you to make the sourcecode of that work 
#   available to everyone that can interact with it, this to ensure that Diff-
#   LongestCommonSubString remains open and libre (doc/LICENSE.txt contains the
#   full text of the legally binding license, including that of the extra 
#   restrictions).
#++#

require 'diff/longest_common_sub_string'

class String
  include Diff::LongestCommonSubString
end
