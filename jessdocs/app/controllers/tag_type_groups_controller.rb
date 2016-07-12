class TagTypeGroupsController < ApplicationController
  before_action :set_tag_type_group, only: [:show, :update, :destroy]

  # GET /tag_type_groups
  # GET /tag_type_groups.json
  def index
    @tag_type_groups = TagTypeGroup.all

    render json: @tag_type_groups
  end

  # GET /tag_type_groups/1
  # GET /tag_type_groups/1.json
  def show
    render json: @tag_type_group
  end

  # POST /tag_type_groups
  # POST /tag_type_groups.json
  def create
    @tag_type_group = TagTypeGroup.new(tag_type_group_params)

    if @tag_type_group.save
      render json: @tag_type_group, status: :created, location: @tag_type_group
    else
      render json: @tag_type_group.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tag_type_groups/1
  # PATCH/PUT /tag_type_groups/1.json
  def update
    @tag_type_group = TagTypeGroup.find(params[:id])

    if @tag_type_group.update(tag_type_group_params)
      head :no_content
    else
      render json: @tag_type_group.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tag_type_groups/1
  # DELETE /tag_type_groups/1.json
  def destroy
    @tag_type_group.destroy

    head :no_content
  end

  private

    def set_tag_type_group
      @tag_type_group = TagTypeGroup.find(params[:id])
    end

    def tag_type_group_params
      params[:tag_type_group]
    end
end
