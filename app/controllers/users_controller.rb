class UsersController < ApplicationController
 
  before_action :authenticate_user!, only: [:create, :update, :destroy, :new, :edit]

#  def new
#    @article = Article.new
#  end


  def editcurrent
    @user = User.find(current_user.id)
  end


#  def show
#    @article = Article.find(params[:id])
#  end
          

#  def create
#    @article = Article.new(article_params)
#    if @article.save
#      redirect_to @article
#    else
#      render 'new'
#    end      
#   # redirect_to @article
#  end

  def update
 #     log=TLog.new
#      @@log.file = '/tmp/rail_log.txt'
#      @@log.info.text 'Start'  
      
      $log.jobBegin  
      @user = User.find(params[:id])
      @user.update(user_params)

      $log.jobEnd
#    if @user.update(user_params)
#      redirect_to @user
#    else
#      render 'edit'
#    end      
  end


#  def index
#    @articles = Article.all 
#  end


  private
  begin
    def user_params
      params.require(:user).permit(:subs)
    end
    def authenticate_user!
      msgAlert="Нужно быть авторизованным пользователем."
      if (!current_user)
        if (request.referrer)
          redirect_to request.referrer, :alert => msgAlert      
        else
          redirect_to root_path, :alert => msgAlert      
        end        
      end
    end
  end
  
end
