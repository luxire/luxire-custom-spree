class LuxireStyleMasterImagesController < ApplicationController
  before_action :set_luxire_style_master_image, only: [:show, :edit, :update, :destroy]

  # GET /luxire_style_master_images
  # GET /luxire_style_master_images.json
  def index
    @luxire_style_master_images = LuxireStyleMasterImage.all
  end

  # GET /luxire_style_master_images/1
  # GET /luxire_style_master_images/1.json
  def show
  end

  # GET /luxire_style_master_images/new
  def new
    @luxire_style_master_image = LuxireStyleMasterImage.new
  end

  # GET /luxire_style_master_images/1/edit
  def edit
  end

  # POST /luxire_style_master_images
  # POST /luxire_style_master_images.json
  def create
    @luxire_style_master_image = LuxireStyleMasterImage.new(luxire_style_master_image_params)

    respond_to do |format|
      if @luxire_style_master_image.save
        format.html { redirect_to @luxire_style_master_image, notice: 'Luxire style master image was successfully created.' }
        format.json { render :show, status: :created, location: @luxire_style_master_image }
      else
        format.html { render :new }
        format.json { render json: @luxire_style_master_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /luxire_style_master_images/1
  # PATCH/PUT /luxire_style_master_images/1.json
  def update
    respond_to do |format|
      if @luxire_style_master_image.update(luxire_style_master_image_params)
        format.html { redirect_to @luxire_style_master_image, notice: 'Luxire style master image was successfully updated.' }
        format.json { render :show, status: :ok, location: @luxire_style_master_image }
      else
        format.html { render :edit }
        format.json { render json: @luxire_style_master_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /luxire_style_master_images/1
  # DELETE /luxire_style_master_images/1.json
  def destroy
    @luxire_style_master_image.destroy
    respond_to do |format|
      format.html { redirect_to luxire_style_master_images_url, notice: 'Luxire style master image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_luxire_style_master_image
      @luxire_style_master_image = LuxireStyleMasterImage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def luxire_style_master_image_params
      params.require(:luxire_style_master_image).permit(:category, :luxire_style_master_id, :alternate_text, :image)
    end
end
