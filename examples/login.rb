# frozen_string_literal: true

###############################################################################
#
# JObfuscator — login
#
# Version        : v1.0.6
# Language       : Ruby
# Author         : Bartosz Wójcik
# Web page       : https://www.pelock.com
#
###############################################################################

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "jobfuscator"

p JObfuscator.new("YOUR-WEB-API-KEY").login
