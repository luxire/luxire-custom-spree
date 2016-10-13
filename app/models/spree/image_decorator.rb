Spree::Image.class_eval do
       has_attached_file :attachment,
	styles: { mini: '100x100>', small: '240x240>', product: '540X540', large: '900X' },
                     default_style: :product,
                     url: '/luxire/images/products/:id/:style/:basename.:extension',
                     path: 'luxire/images/products/:id/:style/:basename.:extension',
                     convert_options: { all: '-strip -auto-orient -colorspace sRGB -depth 300'}
# large: " -gravity center -resize '346.906x346.906+0+0'", product: " -gravity southeast" }
end
