# Retrieve a banner from the known list and format it according to the passed
# options
#
Puppet::Functions.create_function(:'simp_banners::fetch') do
  # @param name
  #   The banner to fetch
  #
  #   * This may need to include the relative path to the file. For example,
  #     the US Department of Commerce banner would be named
  #     'us/department_of_commerce'
  #
  # @param format
  #   Formatting options
  # @option cr_escape [Boolean]
  #   Escape all Carriage Return characters
  # @option format [Boolean] 'file_source'
  #   Return a String suitable for a File `source` option
  #
  #   * Takes precedence over all other formatting options if set
  #
  # @raise [Puppet::ParseError]
  #   An error containing a list of supported banners will be raised if the
  #   requested banner cannot be found
  #
  # @return [String]
  #   The banner formatted according to the `format` options
  dispatch :fetch do
    required_param 'String[1]', :name

    optional_param 'Struct[{
        "cr_escape"   => Optional[Boolean],
        "file_source" => Optional[Boolean]
      }]', :format
  end

  def fetch(name, format = {})
    format_defaults = {
      'cr_escape'   => false,
      'file_source' => false
    }

    format = format_defaults.merge(format)

    files_path = File.join(call_function('get_module_path', 'simp_banners'), 'files')

    supported_banners = {}

    require 'find'

    Find.find(files_path) do |path|
      value = path.dup
      path.slice!(0..files_path.length)

      supported_banners[path] = value
    end

    raise(Puppet::ParseError, "No banners found under '#{files_path}'") if supported_banners.empty?

    unless supported_banners[name]
      raise(
        Puppet::ParseError,
        %(Banner '#{name}' not found. Supported banners:\n  * #{supported_banners.keys.join("\n  * ")}),
      )
    end

    if format['file_source']
      "puppet:///simp_banners/#{name}"
    elsif format['cr_escape']
      File.read(supported_banners[name]).gsub(%r{[\r\n]}, '\n')
    else
      File.read(supported_banners[name])
    end
  end
end
