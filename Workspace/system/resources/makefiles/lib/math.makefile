# Copyright (c) 2019 Ayoume Inc.
# All rights reserved.
#
# "Math Util For Makefile" version 1.0
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#    * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above
# copyright notice, this list of conditions and the following disclaimer
# in the documentation and/or other materials provided with the
# distribution.
#    * Neither the name of Ayoume Inc. nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES_; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# ---
# Author:  Zichoole
# Created: 2019-03-07 10:46:00
# E-mail:  zichoole@gmail.com
#
# ---
# Description:
#   Math util for makefile.
#
###############################################################################

ifndef __MATH__
define __MATH__
endef

###############################################################################

override MATH_CALCULATE ?= function MATH_CALCULATE() { \
	awk "BEGIN {print $$*}"; \
}; MATH_CALCULATE

override MATH_FLOOR ?= function MATH_FLOOR() { \
	local -r var="$$($(MATH_CALCULATE) "$${1}")"; \
	awk -v var="$${var}" "BEGIN {print int(var)}"; \
}; MATH_FLOOR

override MATH_ROUND ?= function MATH_ROUND() { \
	local -r var="$$($(MATH_CALCULATE) "$${1}")"; \
	awk -v var="$${var}" "BEGIN {print int(var+0.5)}"; \
}; MATH_ROUND

override MATH_MIN ?= function MATH_MIN() { \
	local -r var1="$$($(MATH_CALCULATE) "$${1}")"; \
	local -r var2="$$($(MATH_CALCULATE) "$${2}")"; \
	awk -v var1="$${var1}" -v var2="$${var2}" \
		"BEGIN { \
			if (var1<=var2) print var1; else print var2 \
		}"; \
}; MATH_MIN

override MATH_MAX ?= function MATH_MAX() { \
	local -r var1="$$($(MATH_CALCULATE) "$${1}")"; \
	local -r var2="$$($(MATH_CALCULATE) "$${2}")"; \
	awk -v var1="$${var1}" -v var2="$${var2}" \
		"BEGIN { \
			if (var1>var2) print var1; else print var2 \
		}"; \
}; MATH_MAX

###############################################################################

endif
