require 'prawn'

# All text is converted to Windows-1252 in #printable, so the built-in fonts suffice
Prawn::Fonts::AFM.hide_m17n_warning = true

# Renders an approved declaration as a single A4: the details on top and the receipt
# (or the reason why it is missing) scaled into the remaining space
class DeclarationPdf
  DETAILS_MAX_HEIGHT = 220
  REASON_MAX_HEIGHT = 400

  def initialize(declaration)
    @declaration = declaration
  end

  # e.g. 2026-11-18_jan_de-vries_12_declaratie.pdf, based on the submission date so it never changes
  def filename
    first_name = user.first_name.parameterize
    last_name = [user.last_name_prefix, user.last_name].compact_blank.join(' ').parameterize
    "#{submitted_on.iso8601}_#{first_name}_#{last_name}_#{@declaration.id}_declaratie.pdf"
  end

  def folder
    submitted_on.year.to_s
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

  def submitted_on
    (@declaration.created_at || Time.zone.now).to_date
  end

  def render_header(document)
    document.text 'Declaratie C.S.V. Alpha', size: 20, style: :bold
    document.move_down 12
  end

  def render_details(document)
    fragments = details.flat_map do |label, value|
      [{ text: "#{label}: ", styles: [:bold] }, { text: "#{printable(value)}\n" }]
    end
    bounded_text(document, fragments, DETAILS_MAX_HEIGHT)
    document.move_down 12
  end

  # Text is rendered in a box of limited height that shrinks the font when needed,
  # so long or multiline input can never push the receipt onto a second page
  def bounded_text(document, fragments, max_height)
    box = Prawn::Text::Formatted::Box.new(fragments, document:, at: [0, document.cursor],
                                                     width: document.bounds.width, height: max_height,
                                                     overflow: :shrink_to_fit, min_font_size: 5)
    box.render
    document.move_down box.height
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
      bounded_text(document, [{ text: "Reden: #{printable(@declaration.missing_receipt_reason)}" }],
                   [document.cursor, REASON_MAX_HEIGHT].min)
    end
  end

  # The built-in PDF fonts only support Windows-1252, replace anything else (e.g. emoji)
  def printable(value)
    value.to_s.encode('Windows-1252', invalid: :replace, undef: :replace, replace: '?').encode('UTF-8')
  end

  # Prawn can only embed JPG and PNG, receipts are stored as JPG or PDF.
  # For a PDF receipt the first page is rasterized, see PdfRasterizer.
  def receipt_image_path
    return @declaration.receipt.path unless @declaration.receipt.pdf?

    @rasterized_receipt ||= PdfRasterizer.first_page(@declaration.receipt.path)
    @rasterized_receipt.path
  end
end
