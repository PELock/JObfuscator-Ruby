# frozen_string_literal: true

###############################################################################
#
# JObfuscator — simple example
#
# Version        : v1.0.6
# Language       : Ruby
# Author         : Bartosz Wójcik
# Web page       : https://www.pelock.com
#
###############################################################################

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "jobfuscator"

client = JObfuscator.new("YOUR-WEB-API-KEY")
source = <<~JAVA
  public class Hello {
      public static void main(String[] args) {
          System.out.println("Hello");
      }
  }
JAVA

result = client.obfuscate_java_source(source)
if result && result["error"] == JObfuscator::ERROR_SUCCESS
  puts result["output"]
else
  warn "Error: #{result.inspect}"
end
