module SpreadsheetHelper
  require 'roo'

  def decode_upload_file(base64_data) # rubocop:disable Metrics/MethodLength
    data = split_base_url(base64_data)
    return unless data&.dig(:data)

    temp_file = Tempfile.new('data_uri-upload')
    temp_file.binmode
    temp_file << Base64.decode64(data[:data])
    temp_file.rewind

    case data[:extension]
    when 'vnd.oasis.opendocument.spreadsheet'
      data[:extension] = 'ods'
    when 'vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      data[:extension] = 'xlsx'
    when 'vnd.ms-excel.sheet.macroEnabled.12'
      data[:extension] = 'xlsm'
    end

    {
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

  def get_headers(file)
    spreadsheet = Roo::Spreadsheet.open(file[:file], extension: file[:extension])
    sheet = spreadsheet.sheet(0)
    sheet.row(1)
  end

  def get_rows(file)
    spreadsheet = Roo::Spreadsheet.open(file[:file], extension: file[:extension])

    sheet = spreadsheet.sheet(0)
    headers = sheet.row(1)

    (2..sheet.last_row).map do |i|
      headers.zip(sheet.row(i)).to_h
    end
  end
end
