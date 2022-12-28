# frozen_string_literal: true

class ArticlesController < ApplicationController
  layout 'articles_layout'
  before_action :authenticate_user!, except: %i(index show)
  before_action :load_article, only: %i(show edit update upvote downvote cancelvote)

  def index
    @articles = if params[:tag].present?
                  Article.tagged_with(params[:tag]).order('created_at DESC').includes(:user)
                else
                  Article.order('created_at DESC').includes(:user)
                end
  end

  def show
    @author = @article.user
  end

  def new
    @article = Article.new
    @article.tag_list = [params[:tag]]
  end

  def edit; end

  def create
    @article = current_user.articles.build(article_params)

    if @article.save
      @article.create_activity :create, owner: current_user
      flash[:notice] = %(Successfully created the article "#{@article.title}!")
      redirect_to article_path(@article)
    else
      flash.now[:alert] = @article.errors.full_messages.join(', ')
      render 'new'
    end
  end

  def update
    if @article.update(article_params)
      @article.create_activity :update, owner: current_user
      flash[:notice] = %(Successfully updated the article "#{@article.title}")
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
    @author = current_user
  end

  # article voting
  def upvote
    if @article.authored_by?(current_user)
      flash[:error] = %(Can not vote for your own article "#{@article.title}")
    else
      @article.upvote_by current_user
      case @article.vote_registered?
      when true
        flash[:notice] = %(Successfully voted up the article "#{@article.title}")
      when false
        flash[:error] = 'You have already given this article an up vote'
      when nil
        flash[:error] = 'Your vote was not registered'
      end
    end
    redirect_to article_path(@article)
  end

  def downvote
    if @article.authored_by?(current_user)
      flash[:error] = %(Can not vote for your own article "#{@article.title}")
    else
      @article.downvote_by current_user
      case @article.vote_registered?
      when true
        flash[:notice] = %(Successfully voted down the article "#{@article.title}")
      when false
        flash[:error] = 'You have already given this article a down vote'
      when nil
        flash[:error] = 'Your vote was not registered'
      end
    end
    redirect_to article_path(@article)
  end

  def cancelvote
    @article.unvote_by current_user
    case @article.vote_registered?
    when true
      flash[:notice] = %(Could not cancel your vote for the article "#{@article.title}")
    when false
      flash[:notice] = %(Cancelled your vote for the article "#{@article.title}")
    when nil
      flash[:error] = 'Can not cancel when you have not voted for this article'
    end
    redirect_to article_path(@article)
  end

  private

  def article_params
    params[:article].permit(:title, :content, :tag_list)
  end

  def load_article
    @article = Article.friendly.find(params[:id])
  end
end
