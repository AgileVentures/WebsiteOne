class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]

  def index
    @articles = Article.all
  end

  def show
    @article = Article.friendly.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def edit
    @article = Article.friendly.find(params[:id])
  end

  def create
    tags = params[:article][:tags]
    params[:article][:tags] = nil

    @article = current_user.articles.build(article_params)

    @article.tag_list = tags

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

    tags = params[:article][:tags]
    params[:article][:tags] = nil

    @article.tag_list = tags

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
    params[:article].permit(:title, :content)
  end
end
