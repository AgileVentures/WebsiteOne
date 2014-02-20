class ArticlesController < ApplicationController
  layout 'articles_layout'
  before_action :authenticate_user!, except: [ :index, :show ]

  def index
    if params[:tag].present?
      @articles = Article.tagged_with(params[:tag])
    else
      @articles = Article.all
    end
  end

  def show
    @article = Article.friendly.find(params[:id])
    @author = @article.user
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
      flash[:notice] = "Successfully created the article entitled \"#{@article.title}!\""
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

  private

  def article_params
    params[:article].permit(:title, :content, :tag_list)
  end
end
