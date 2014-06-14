class ArticlesController < ApplicationController
  layout 'articles_layout'
  before_action :authenticate_user!, except: [ :index, :show ]

  def index
    if params[:tag].present?
      @articles = Article.tagged_with(params[:tag]).order('created_at DESC')
    else
      @articles = Article.order('created_at DESC')
    end
  end

  def show
    @article = Article.friendly.find(params[:id])
  end

  def new
    @article = Article.new
    @article.tag_list = [ params[:tag] ]
  end

  def edit
    @article = Article.friendly.find(params[:id])
  end

  def create
    @article = current_user.articles.build(article_params)

    if @article.save
      flash[:notice] = "Successfully created the article \"#{@article.title}!\""
      redirect_to article_path(@article)
    else
      flash.now[:alert] = @article.errors.full_messages.join(', ')
      render 'new'
    end
  end

  def update
    @article = Article.friendly.find(params[:id])

    if @article.update_attributes(article_params)
      flash[:notice] = "Successfully updated the article \"#{@article.title}\""
      redirect_to article_path(@article)
    else
      flash.now[:alert] = @article.errors.full_messages.join(', ')
      render 'edit'
    end
  end

  def preview
    @article = Article.new(article_params)

    # fill with dummy data
    @article.created_at = Time.now
    @article.updated_at = Time.now
    @article.user = current_user
  end

  private

  def article_params
    params[:article].permit(:title, :content, :tag_list)
  end
end
