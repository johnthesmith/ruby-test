class ArticlesController < ApplicationController

  def new
    @article = Article.new
  end


  def edit
    @article = Article.find(params[:id])
  end


  def show
    @article = Article.find(params[:id])
  end
          

  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to @article
    else
      render 'new'
    end      
   # redirect_to @article
  end

  def update
    @article = Article.find(params[:id])
    if @article.update(article_params)
      redirect_to @article
    else
      render 'edit'
    end      
  end


  def index
    @articles = Article.all 
  end


  private
  begin
    def article_params
      params.require(:article).permit(:title, :text)
    end
  end
  
end
