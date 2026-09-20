# frozen_string_literal: true

require "base64"
require "json"
require "zlib"

class JObfuscator
  API_URL = "https://www.pelock.com/api/jobfuscator/v1"
  ERROR_SUCCESS = 0
  ERROR_INPUT_SIZE = 1
  ERROR_INPUT = 2
  ERROR_PARSING = 3
  ERROR_OBFUSCATION = 4
  ERROR_OUTPUT = 5
  USER_AGENT = "PELock JObfuscator"

  # Defaults match JObfuscator.php (split_strings is false; remove_comments is always on).
  FLAG_PARAMS = {
    array_int_crypt: "array_int_crypt",
    array_char_crypt: "array_char_crypt",
    array_double_crypt: "array_double_crypt",
    array_string_crypt: "array_string_crypt",
    split_strings: "split_strings",
    crypt_strings: "crypt_strings",
    rename_methods: "rename_methods",
    shuffle_methods: "shuffle_methods",
    ints_math_crypt: "ints_math_crypt",
    dbls_math_crypt: "dbls_math_crypt",
    rename_variables: "rename_variables",
    mix_code_flow: "mix_code_flow",
    string_char_vault: "string_char_vault",
    ints_from_double_math: "ints_from_double_math",
    opaque_mixer_chain: "opaque_mixer_chain",
    complexify_booleans: "complexify_booleans",
    try_finally_noise: "try_finally_noise",
    ints_to_arrays: "ints_to_arrays",
    dbls_to_arrays: "dbls_to_arrays"
  }.freeze

  attr_accessor :enable_compression, *FLAG_PARAMS.keys

  def initialize(api_key = nil)
    @api_key = api_key
    @enable_compression = true
    @remove_comments = true
    FLAG_PARAMS.each_key { |name| instance_variable_set("@#{name}", true) }
    @split_strings = false
  end

  def login(return_as_object = true)
    post_request({ "command" => "login" }, return_as_object)
  end

  def obfuscate_java_file(java_file_path, return_as_object = true)
    source = File.read(java_file_path, encoding: "UTF-8")
    return nil if source.nil? || source.empty?

    obfuscate_java_source(source, return_as_object)
  rescue StandardError
    nil
  end

  def obfuscate_java_source(java_source, return_as_object = true)
    post_request({ "command" => "obfuscate", "source" => java_source }, return_as_object)
  end

  private

  def post_request(params_array, return_as_object)
    params = params_array.dup
    params["key"] = @api_key unless @api_key.nil? || @api_key.to_s.empty?

    FLAG_PARAMS.each do |name, key|
      params[key] = "1" if instance_variable_get("@#{name}")
    end
    params["remove_comments"] = "1" if @remove_comments

    if @enable_compression && params["source"] && !params["source"].to_s.empty?
      params["source"] = Base64.strict_encode64(Zlib::Deflate.deflate(params["source"], 9))
      params["compression"] = "1"
    end

    body = Http.post_multipart(API_URL, params, user_agent: USER_AGENT)
    return false if body.nil? || body.empty?

    result = Http.parse_json(body)
    return false if result.nil? || result.empty?

    depacked = false
    if @enable_compression && result["error"] == ERROR_SUCCESS
      begin
        result["output"] = Zlib::Inflate.inflate(Base64.decode64(result["output"].to_s))
        depacked = true
      rescue StandardError
        # keep packed output
      end
    end

    return result if return_as_object
    return JSON.generate(result) if depacked

    body
  end
end
