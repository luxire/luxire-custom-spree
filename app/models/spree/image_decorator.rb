Spree::Image.class_eval do
       has_attached_file :attachment,
	styles: { mini: '100x100>', small: '240x240>', product: '480X480#', large: '' },
                     default_style: :product,
                     url: '/spree/products/:id/:style/:basename.:extension',
                     path: ':rails_root/public/spree/products/:id/:style/:basename.:extension',
                     convert_options: { all: '-strip -auto-orient -colorspace sRGB -depth 300', large: '-gravity center -resize 40% -crop "600X600+0+0"'}
# large: " -gravity center -resize '346.906x346.906+0+0'", product: " -gravity southeast" }
end
