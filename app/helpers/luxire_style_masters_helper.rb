module LuxireStyleMastersHelper
  def real_images(luxire_style_master)
     get_images("real",luxire_style_master)
  end

  def sketch_images(luxire_style_master)
    get_images("sketch",luxire_style_master)
  end

  def get_images(image_type, luxire_style_master)
    if luxire_style_master.instance_of? Paperclip::Attachment
      luxire_style_master = luxire_style_master.instance
    end
    luxire_style_master_images = LuxireStyleMasterImage.where("lower(category) =? and luxire_style_master_id =?", image_type, luxire_style_master.id);
    real_images = []
    luxire_style_master_images.each do |luxire_style_master_img|
      real_images << {small: luxire_style_master_img.image.url(:small), medium: luxire_style_master_img.image.url(:medium), large: luxire_style_master_img.image.url(:large), alternate_text: luxire_style_master_img.alternate_text, category: luxire_style_master_img.category}
    end
    real_images
  end
end
