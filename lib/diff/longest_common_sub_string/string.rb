#--#
# Copyright: (c) 2006-2008 The LogiLogi Foundation <foundation@logilogi.org>
#
# License:
#   This file is part of the Diff-LongestCommonSubString library. Diff-
#   LongestCommonSubString is Free Software. You can run/distribute/modify
#   Diff-LongestCommonSubString under the terms of the GNU Affero General
#   Public License version 3. The Affero GPL states that running a modified
#   version or a derivative work also requires you to make the sourcecode of
#   that work available to everyone that can interact with it. We chose the
#   Affero GPL to ensure that Diff-LongestCommonSubString remains open and
#   libre (doc/LICENSE.txt contains the full text of the legally binding
#   license).
#++#

require 'diff/longest_common_sub_string'

class String
  include Diff::LongestCommonSubString
end
