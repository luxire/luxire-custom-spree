Spree::Api::ImagesController.class_eval do
  before_action :authorize_for_create, only: [:add_variant_image, :add_variant_image_from_url]

         def add_variant_image
           raw_image = params[:image]
           get_variant
           image = Spree::Image.new
           image.viewable = @variant
           image.attachment = raw_image
           if image.save
             response = {msg: "Image successfully added for #{@variant.name}"}
             render json: response.to_json, status: 201
           else
             response = {msg: "Unable to add image and the reason is #{@image.errors}"}
             render json: response.to_json, status: 422
           end
         end

         def add_variant_image_from_url
           image_url = params[:imageUrl]
           get_variant
           image = Spree::Image.new
           image.viewable = @variant
           image.attachment = URI.parse(image_url)
           if image.save
             response = {msg: "Image successfully added for #{@variant.name}"}
             render json: response.to_json, status: 201
           else
             response = {msg: "Unable to add image and the reason is #{image.errors}"}
             render json: response.to_json, status: 422
           end
         end

         def delete_variant_image
           authorize! :destroy, Spree::Image
           @image = Spree::Image.find(params[:id])
           if @image.destroy
             response = {msg: "Image successfully Deleted"}
             render json: response.to_json, status: 200
           else
             response = {msg: "Unable to delete image and the reason is #{@image.errors}"}
             render json: response.to_json, status: 422
           end
         end

    private
    def get_variant
      variant_id = params[:variantId].to_i
      @variant = Spree::Variant.find(variant_id)
    end

    def authorize_for_create
      authorize! :create, Spree::Image
    end
end
