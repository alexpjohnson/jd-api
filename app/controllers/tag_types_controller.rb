class TagTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tag_type, only: [:show, :update, :destroy]

  # GET /tag_types
  # GET /tag_types.json
  def index
    org_id = params[:organization_id]
    @tag_types = TagType.for_org(org_id)
    @deleted_tag_types = TagType.only_deleted.for_org(org_id)

    render json: {by_group: TagType.tag_hash(:organization_id => org_id), all_types: @tag_types, deleted: @deleted_tag_types}
  end

  # GET /tag_types/1
  # GET /tag_types/1.json
  def show
    render json: @tag_type
  end

  # POST /tag_types
  # POST /tag_types.json
  def create
    @tag_type = TagType.new(create_params.merge(:created_by => current_user))

    if @tag_type.save
      render json: @tag_type, status: :created, location: @tag_type
    else
      render json: @tag_type.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tag_types/1
  # PATCH/PUT /tag_types/1.json
  def update
    if @tag_type.update(update_params)
      head :no_content
    else
      render json: @tag_type.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tag_types/1
  # DELETE /tag_types/1.json
  def destroy
    @tag_type.update!(:deleted_by_id => current_user.id)
    @tag_type.destroy

    head :no_content
  end
  
  def restore
    @tag_type = TagType.only_deleted.find(params[:id])
    @tag_type.recover
  end

  private

    def set_tag_type
      @tag_type = TagType.find(params[:id])
    end

    def tag_type_params
      params[:tag_type]
    end
    
    def index_params
      params.require(:tag_types).permit(:organization_id)
    end
    
    def create_params
      params.require(:tag_type).permit(:name, :color, :tag_type_group_id, :organization_id)
    end
    
    def update_params
      params.require(:tag_type).permit(:name, :color, :tag_type_group_id)
    end
end
