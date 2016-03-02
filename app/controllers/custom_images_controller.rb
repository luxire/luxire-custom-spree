class CustomImagesController < ApplicationController
  wrap_parameters format: [:json, :xml, :url_encoded_form, :multipart_form]
  wrap_parameters :custom_image, include: [:id, :source, :image]
  before_action :set_custom_image, only: [:show, :edit, :update, :destroy]

  # GET /custom_images
  # GET /custom_images.json
  def index
    @custom_images = CustomImage.all
  end

  # GET /custom_images/1
  # GET /custom_images/1.json
  def show
  end

  # GET /custom_images/new
  def new
    @custom_image = CustomImage.new
  end

  # GET /custom_images/1/edit
  def edit
  end

  # POST /custom_images
  # POST /custom_images.json
  def create
    @custom_image = CustomImage.new(custom_image_params)

    respond_to do |format|
      if @custom_image.save
        format.html { redirect_to @custom_image, notice: 'Custom image was successfully created.' }
        format.json { render :show, status: :created, location: @custom_image }
      else
        format.html { render :new }
        format.json { render json: @custom_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /custom_images/1
  # PATCH/PUT /custom_images/1.json
  def update
    respond_to do |format|
      if @custom_image.update(custom_image_params)
        format.html { redirect_to @custom_image, notice: 'Custom image was successfully updated.' }
        format.json { render :show, status: :ok, location: @custom_image }
      else
        format.html { render :edit }
        format.json { render json: @custom_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /custom_images/1
  # DELETE /custom_images/1.json
  def destroy
    @custom_image.destroy
    respond_to do |format|
      format.html { redirect_to custom_images_url, notice: 'Custom image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_custom_image
      @custom_image = CustomImage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def custom_image_params
      params.require(:custom_image).permit(:source, :image)
    end
end
