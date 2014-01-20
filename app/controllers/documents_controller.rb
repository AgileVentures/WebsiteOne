class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [ :index, :show ]

  before_action :find_project


  # GET /documents
  # GET /documents.json
  def index
    # TODO separate route for "documents for a project"
    #@documents = Document.all
    @documents = Document.where("project_id = ?", @project.id).order(:created_at)

  end

  # GET /documents/1
  # GET /documents/1.json
  def show
  end

  # GET /documents/new
  def new
    @document = Document.new
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents
  # POST /documents.json
  def create
    @document = Document.new(document_params)
    respond_to do |format|
      if @document.save
        format.html { redirect_to project_documents_path(@project), notice: 'Document was successfully created.' }
        format.json { render action: 'show', status: :created, location: @document }
      else
        format.html { render action: 'new' }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /documents/1
  # PATCH/PUT /documents/1.json
  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to project_document_path(id: @document.id, project_id: @document.project_id), notice: 'Document was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
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
    p 'i have received it laksfjlaskfj laksjlkjasfljaslfkjl akjflaksjflkfjdslkgjiowej'
    @document = Document.find(params[:document_id])
    if @document.update_attributes(title: params[:content][:document_title][:value],
                                   body: params[:content][:document_body][:value])
      render text: '' # So mercury knows it is successful
    end
  end

  private
  def find_project
    if params[:project_id]
      @project = Project.find_by_id(params[:project_id])
    end
  end

  def set_document
    @document = Document.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def document_params
    params.require(:document).permit(:title, :body, :project_id)
  end
end
