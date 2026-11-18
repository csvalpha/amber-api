require 'prawn'

# All text is converted to Windows-1252 in #printable, so the built-in fonts suffice
Prawn::Fonts::AFM.hide_m17n_warning = true

# Renders an approved declaration as a single A4: the details on top and the receipt
# (or the reason why it is missing) scaled into the remaining space
class DeclarationPdf
  def initialize(declaration)
    @declaration = declaration
  end

  def filename
    description = @declaration.description.parameterize.first(50)
    "#{@declaration.purchase_date.iso8601}_#{user_slug}_#{description}_EUR#{format('%.2f', @declaration.amount)}" \
      "_id#{@declaration.id}.pdf"
  end

  def folder
    @declaration.purchase_date.year.to_s
  end

  def render
    document = Prawn::Document.new(page_size: 'A4', margin: 40, info: { Title: "Declaratie #{@declaration.id}" })
    render_header(document)
    render_details(document)
    render_receipt(document)
    document.render
  end

  private

  def user
    @declaration.user
  end

  def user_slug
    [user.last_name, user.last_name_prefix, user.first_name].compact_blank.join('-').parameterize
  end

  def render_header(document)
    document.text 'Declaratie C.S.V. Alpha', size: 20, style: :bold
    document.move_down 12
  end

  def render_details(document)
    details.each do |label, value|
      document.formatted_text [{ text: "#{label}: ", styles: [:bold] }, { text: printable(value) }]
    end
    document.move_down 12
  end

  def details
    {
      'Declaratienummer' => @declaration.id,
      'Naam' => user.full_name,
      'IBAN' => iban,
      'Bedrag' => ActiveSupport::NumberHelper.number_to_currency(@declaration.amount, unit: '€', separator: ',',
                                                                                      delimiter: '.'),
      'Omschrijving' => @declaration.description
    }.merge(dates)
  end

  def dates
    {
      'Aankoopdatum' => format_date(@declaration.purchase_date),
      'Ingediend op' => format_date(@declaration.created_at),
      'Goedgekeurd door' => @declaration.approved_by&.full_name,
      'Goedgekeurd op' => format_date(@declaration.approved_at)
    }
  end

  def iban
    mandate = user.mandates.active.last
    mandate ? "#{mandate.iban} t.n.v. #{mandate.iban_holder}" : 'geen actief mandaat'
  end

  def format_date(date)
    date&.strftime('%d-%m-%Y')
  end

  def render_receipt(document)
    document.stroke_horizontal_rule
    document.move_down 12

    if @declaration.receipt.present?
      document.image receipt_image_path, fit: [document.bounds.width, document.cursor], position: :center
    else
      document.text 'Bon ontbreekt', size: 14, style: :bold
      document.move_down 6
      document.text "Reden: #{printable(@declaration.missing_receipt_reason)}"
    end
  end

  # The built-in PDF fonts only support Windows-1252, replace anything else (e.g. emoji)
  def printable(value)
    value.to_s.encode('Windows-1252', invalid: :replace, undef: :replace, replace: '?').encode('UTF-8')
  end

  # Prawn can only embed JPG and PNG, receipts are stored as JPG or PDF.
  # For a PDF receipt the first page is rasterized with ghostscript directly,
  # since ImageMagick's default security policy often blocks PDF input.
  def receipt_image_path
    return @declaration.receipt.path unless @declaration.receipt.pdf?

    @rasterized_receipt ||= rasterize_first_page(@declaration.receipt.path)
    @rasterized_receipt.path
  end

  def rasterize_first_page(pdf_path)
    tempfile = Tempfile.new(%w[receipt .jpg])
    _output, error, status = Open3.capture3('gs', '-dSAFER', '-dBATCH', '-dNOPAUSE', '-dQUIET', '-sDEVICE=jpeg',
                                            '-dFirstPage=1', '-dLastPage=1', '-r150',
                                            "-sOutputFile=#{tempfile.path}", pdf_path)
    raise "Could not rasterize PDF receipt: #{error}" unless status.success?

    tempfile
  end
end
