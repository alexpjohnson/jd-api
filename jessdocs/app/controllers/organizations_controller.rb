class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :add_user, :current_user_role, :users, :update, :destroy]

  # GET /organizations
  # GET /organizations.json
  def index
    @organizations = Organization.all

    render json: @organizations
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
    render json: @organization
  end
  
  def current_user_role
    roles = current_user.roles.where(:resource_id => @organization.id).first
    
    render json: roles
  end
  
  def users
    users = @organization.users
    
    render json: users
  end

  # POST /organizations
  # POST /organizations.json
  def create
    @organization = Organization.new(organization_params)

    if @organization.save
      render json: @organization, status: :created, location: @organization
    else
      render json: @organization.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /organizations/1
  # PATCH/PUT /organizations/1.json
  def update
    user = User.find(update_params[:user_id])
    
    if user
      @organization.users.delete(user)
    end
    
    head :no_content
  end
  
  def add_user
    user = User.where(:email => add_user_params[:email]).first
    
    if user
      user.organizations << @organization
    end
    
    head :no_content
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    @organization.destroy

    head :no_content
  end

  private

    def set_organization
      @organization = Organization.find(params[:id])
    end

    def organization_params
      params[:organization]
    end
    
    def update_params
      params.require(:org).permit(:user_id)
    end
    
    def add_user_params
      params.require(:org).permit(:email)
    end
end
