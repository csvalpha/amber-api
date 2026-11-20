require 'open3'

# Renders the first page of a PDF to a JPG with ghostscript. ImageMagick is not used,
# since its default security policy often blocks PDF input.
#
# The page is always fitted on A4 at 150 dpi, which bounds the rendered size (~1240x1754 px)
# whatever page size the PDF declares, and ghostscript is killed when it exceeds the deadline.
class PdfRasterizer
  TIMEOUT = 20 # seconds

  class Error < StandardError; end

  def self.first_page(pdf_path)
    tempfile = Tempfile.new(%w[receipt .jpg])
    command = ['gs', '-dSAFER', '-dBATCH', '-dNOPAUSE', '-dQUIET', '-sDEVICE=jpeg', '-dFirstPage=1', '-dLastPage=1',
               '-r150', '-sPAPERSIZE=a4', '-dFIXEDMEDIA', '-dPDFFitPage', "-sOutputFile=#{tempfile.path}", pdf_path]
    raise Error, 'Could not rasterize PDF receipt' unless run_with_deadline(command)

    tempfile
  end

  def self.run_with_deadline(command)
    Open3.popen3(*command) do |stdin, _stdout, _stderr, wait_thread|
      stdin.close
      return wait_thread.value.success? if wait_thread.join(self::TIMEOUT)

      Process.kill('KILL', wait_thread.pid)
      wait_thread.join
      false
    end
  end
  private_class_method :run_with_deadline
end
