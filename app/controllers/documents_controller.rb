class DocumentsController < ApplicationController
  layout 'with_sidebar'
  before_action :find_project
  before_action :set_document, only: [:show, :edit, :update, :destroy, :get_doc_categories, :update_parent_id]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    redirect_to project_path @project
  end

  def show
    setup_children
  end

  def update_parent_id
    change_document_parent(params[:new_parent_id]) if params[:new_parent_id]
    redirect_to project_document_path
  end

  def get_doc_categories
    @categories = @project.documents.where(parent_id: nil)
    render partial: "categories"
  end

  def new
    set_parent
    @document = Document.new
  end

  def edit
    set_parent
    @document = Document.friendly.find(params[:id])
  end

  def update
    @document = Document.friendly.find(params[:id])
    if @document.update_attributes(document_params)
      @document.create_activity :update, owner: current_user
      setup_children
      render :show, notice: 'Document was successfully updated.'
    else
      render :edit, alert: 'Changes were not saved.'
    end
  end

  def create
    @document = @project.documents.build(document_params.merge(user_id: current_user.id))
    respond_to do |format|
      if @document.save
        @document.create_activity :create, owner: current_user
        format.html { redirect_to project_document_path(@project, @document), notice: 'Document was successfully created.' }
        format.json { render action: 'show', status: :created, location: @document }
      else
        set_parent
        format.html { render action: 'new' }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    id = @document.project_id
    @document.destroy
    respond_to do |format|
      format.html { redirect_to project_documents_path(id), notice: 'Document was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  def setup_children
    @children = @document.children.order(created_at: :desc).includes(:user)
  end

  def find_project
    @project = Project.friendly.find(params[:project_id])
  end

  def set_document
    @document = @project.documents.find_by_slug!(params[:id])
  end

  def set_parent
    @parent = Document.find(params[:parent_id]) if params[:parent_id].present?
  end

  def change_document_parent(new_parent_id)
    valid_category = Document.find_by_id(new_parent_id)
    if valid_category
      @document.parent_id = valid_category.id
      flash[:notice] = "You have successfully moved #{@document.title} to the #{valid_category.title} section." if @document.save
    else
      flash[:error] = "Could not find the new parent document"
    end
  end

  def document_params
    params.require(:document).permit(:title, :body, :parent_id, :user_id)
  end
end
