class Document < ActiveRecord::Base
	mount_uploader :document, DocumentsUploader
end
