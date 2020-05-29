class DocumentsController < ApplicationController
  layout 'with_sidebar'
  before_action :find_project
  before_action :set_document, only: [:show, :edit, :update, :destroy, :get_doc_categories]
  before_action :authenticate_user!, except: [:index, :show]


  # GET /documents
  # GET /documents.json
  def index
    # Bryan: So that Sampriti doesn't spam us with emails
    redirect_to project_path @project
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    @children = @document.children.order(created_at: :desc).includes(:user)
  end

  def get_doc_categories
    @categories = @project.documents.where(parent_id: nil)
    render partial: "categories"
  end

  private
  def find_project
    @project = Project.friendly.find(params[:project_id])
  end

  def set_document
    @document = @project.documents.find_by_slug!(params[:id])
  end
end
