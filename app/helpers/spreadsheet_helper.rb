module SpreadsheetHelper
  def decode_upload_file(base64_data)
    data = split_base_url(base64_data)
    return unless data&.dig(:data)

    temp_file = Tempfile.new('data_uri-upload')
    temp_file.binmode
    temp_file << Base64.decode64(data[:data])
    temp_file.rewind

    if data[:extension] == 'vnd.oasis.opendocument.spreadsheet'
      data[:extension] = 'ods'
    elsif data[:extension] == 'vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      data[:extension] = 'xlsx'
    elsif data[:extension] == 'vnd.ms-excel.sheet.macroEnabled.12'
      data[:extension] = 'xlsm'
    end

    result = {
      file: temp_file,
      extension: data[:extension]
    }
  end

  def split_base_url(url)
    return unless url =~ /^data:(.*?);(.*?),(.*)$/

    uri = {}
    uri[:type] = Regexp.last_match(1)
    uri[:encoder] = Regexp.last_match(2)
    uri[:data] = Regexp.last_match(3)
    uri[:extension] = Regexp.last_match(1).split('/')[1]
    uri
  end
end
