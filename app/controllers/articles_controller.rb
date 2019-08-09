class ArticlesController < ApplicationController
  include Swamp

  before_action :authenticate_user!, only: [:create, :update, :destroy, :new, :edit]

  # Load form new message
  def new
    @article = Article.new
  end



  # Edit form
  def edit
    @article = Article.find(params[:id])
  end



  # Show form
  def show
    @article = Article.find(params[:id])
  end
          


  # Create record when newform submitted
  def create
    $log.jobBegin.text "Create artice"
    @article = Article.new(article_params)
    if @article.save
      send_user(@article.title, @article.text)
      redirect_to @article
      $log.debug.text "Create articel sucessful"     
    else
      render 'new'
    end      
    $log.jobEnd
  end



  # Update article
  def update   
    $log.jobBegin.text "Update artice"

    maxCountEdit = 5

    @article = Article.find(params[:id])
    countEdit=@article.count_edit+1

    if (countEdit > maxCountEdit)
      redirect_to request.referrer, :alert => I18n.t('article.countEditError', countEdit:  maxCountEdit.to_s)  
      $log.warning.text "Excess number of edits"
    else
      if @article.update(article_params.merge(count_edit: countEdit))
        send_user(@article.title, @article.text)
        redirect_to @article
        $log.info.text("Successfull update ").param("id",@article.id).param("title",@article.title)
        $sender.sendMessage("Update article", @article.title, current_user.email, 0)
      else
        # Reload page
        render 'edit'
      end      
    end

    $log.jobEnd
  end



  def index
    @articles = Article.all 
  end



  private
  begin
  
    def send_user(title, body)
      t=Time.now
      tHour=t.hour
      st=t.strftime("%F")
      t=Time.parse(st+" 07:00:00")

      if (tHour >= 7)
        t=t+1.day
      end
      timeTommorow=t      
      
      tWDay=t.wday
      if (tWDay!=1)
        t=t+(7-tWDay+1).day
      end
      timeMonday=t
     
      listUser=User.all
      for curUser in listUser do

        if (curUser.subs == "week")
          $sender.sendMessage(title, body, curUser.email, timeMonday)
        end
        
        if (curUser.subs == "day")
          $sender.sendMessage(title, body, curUser.email, timeTommorow)
        end
        
      end
    end


    
    def article_params
      return params.require(:article).permit(:title, :text)
    end


    
    def authenticate_user!
      # this message i must move to external model but i to not know that place
      msgAlert = I18n.t('article.needAdminRight')  

      if (!current_user || current_user.role!="admin")
        if (request.referrer)
          redirect_to request.referrer, :alert => msgAlert      
        else
          redirect_to root_path, :alert => msgAlert      
        end        
      end      
    end


  end
  
end
