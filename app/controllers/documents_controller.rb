class DocumentsController < ApplicationController
  layout 'with_sidebar'
  before_action :find_project
  before_action :set_document, only: [:show, :edit, :update, :destroy, :get_doc_categories, :update_parent_id]
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

  def update_parent_id
    change_document_parent(params[:new_parent_id]) if params[:new_parent_id]
    redirect_to project_document_path
  end

  def get_doc_categories
    @categories = @project.documents.where(parent_id: nil)
    render partial: "categories"
  end

  # GET /documents/new
  def new
    set_parent
    @document = Document.new

  end

  # POST /documents
  # POST /documents.json
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

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    id = @document.project_id
    @document.destroy
    respond_to do |format|
      format.html { redirect_to project_documents_path(id), notice: 'Document was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def mercury_update
    @document = Document.friendly.find(params[:document_id])
    if @document.update_attributes(title: params[:content][:document_title][:value],
                                   body: params[:content][:document_body][:value])
      @document.create_activity :update, owner: current_user
      render text: '' # So mercury knows it is successful
    end
  end

  def mercury_saved
    redirect_to project_document_path(@project, id: params[:document_id]), notice: 'The document has been successfully updated.'
  end

  private
  def find_project
    @project = Project.friendly.find(params[:project_id])
  end

  def set_document
    @document = @project.documents.find_by_slug!(params[:id])
  end

  def set_parent
    if params[:parent_id].present?
      @parent = Document.find(params[:parent_id])
    end
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

  # Never trust parameters from the scary internet, only allow the white list through.
  def document_params
    params.require(:document).permit(:title, :body, :parent_id, :user_id)
  end
end
