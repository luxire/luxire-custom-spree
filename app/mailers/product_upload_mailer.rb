class ProductUploadMailer < ApplicationMailer
	def product_upload_status(buggy_record, count, attachment_path)
		if attachment_path
			attachments['error.xlsx'] = File.read(attachment_path)
		end
		@buggy_record = buggy_record
		@uploaded_product = count - buggy_record.length
		mail(:to => Spree.admin_email,
			:subject =>"Product upload status #{Time.current}"
		)
	end

end
