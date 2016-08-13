# WickedPDF Global Configuration
#
# Use this to set up shared configuration options for your entire application.
# Any of the configuration options shown here can also be applied to single
# models by passing arguments to the `render :pdf` call.
#
# To learn more, check out the README:
#
# https://github.com/mileszs/wicked_pdf/blob/master/README.md

WickedPdf.config = {
  # Path to the wkhtmltopdf executable: This usually isn't needed if using
  # one of the wkhtmltopdf-binary family of gems.
   exe_path: !Rails.env.development? ? Rails.root.join('bin', 'wkhtmltopdf').to_s : ENV['WICKED_PDF_PATH']

  #   or
  # exe_path: Gem.bin_path('wkhtmltopdf-binary', 'wkhtmltopdf')
      
  # if Rails.env.staging? || Rails.env.production?
  #   exe_path = Rails.root.join('bin', 'wkhtmltopdf').to_s
  # else
  #   exe_path = Rails.root.join('bin', 'wkhtmltopdf').to_s
  #   # exe_path = '/usr/local/bin/wkhtmltopdf'
  # end 
  


  # Layout file to be used for all PDFs
  # (but can be overridden in `render :pdf` calls)
  # layout: 'pdf.html',
}
