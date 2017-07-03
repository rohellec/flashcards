class AddAttachmentPictureToCards < ActiveRecord::Migration
  def change
    add_attachment :cards, :picture
  end
end
