class SpecsController < ApplicationController
  # before_filter :authenticate_user!
  before_action :set_spec, only: [:show, :update, :destroy, :breadcrumbs]

  # GET /specs
  # GET /specs.json
  def index
    @specs = Spec.all

    render json: @specs.arrange_serializable
  end
  
  def filter
    @specs = Spec.filter(params)
    render json: @specs.arrange_serializable
  end

  # GET /specs/1
  # GET /specs/1.json
  def show
    render json: @spec
  end
  
  def bookmarks
    @specs = Spec.where(:bookmarked => true)
    render json: @specs
  end
  
  def breadcrumbs
    @breadcrumbs = @spec.path
    render json: @breadcrumbs
  end

  # POST /specs
  # POST /specs.json
  def create
    @spec = Spec.new(spec_params)

    if @spec.save
      render json: @spec, status: :created, location: @spec
    else
      render json: @spec.errors, status: :unprocessable_entity
    end
  end
  
  def create_many
    parent_id = params[:parent_id]
    @selected_project_id = params[:project_id]
    
    if parent_id
      parent = Spec.find(parent_id)
      if parent.has_children?
        next_top_order = parent.children.last.spec_order + 1
      else
        next_top_order = 1
      end
    else
      next_top_order = Spec.for_project(@selected_project_id).pluck(:spec_order).max.to_i + 1
    end
    
    Spec.parse_block(params[:text], 
                      @selected_project_id, 
                      parent_id,
                      next_top_order,
                      :created_by_id => params[:created_by_id])
  end

  # PATCH/PUT /specs/1
  # PATCH/PUT /specs/1.json
  def update
    update_params.merge(:updated_by => current_user)
    if @spec.update(update_params)
      head :no_content
    else
      render json: @spec.errors, status: :unprocessable_entity
    end
  end

  # DELETE /specs/1
  # DELETE /specs/1.json
  def destroy
    @spec.destroy

    head :no_content
  end

  private

    def set_spec
      @spec = Spec.find(params[:id])
    end

    def spec_params
      params[:spec]
    end
    
    def update_params
      params.require(:spec).permit(:bookmarked, :description)
    end
end
