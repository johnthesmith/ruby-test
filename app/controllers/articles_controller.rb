require_relative Rails.root+'vendor/swamp/message.rb'


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


  # 
  def show
    @article = Article.find(params[:id])
  end
          

  def create
    @article = Article.new(article_params)
    if @article.save
      send_user(@article.title, @article.text)
      redirect_to @article
    else
      render 'new'
    end      
   # redirect_to @article
  end


  # Update article
  def update
    $log.jobBegin.text "Update artice"
    @article = Article.find(params[:id])

    if @article.update(article_params)
      send_user(@article.title, @article.text)
      redirect_to @article
    else
      render 'edit'
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
          send_article(title, body, curUser.email, timeMonday)
        end
        
        if (curUser.subs == "day")
          send_article(title, body, curUser.email, timeTommorow)
        end
        
      end
    end


    
    def send_article(aSubject, aBody, aEmail, aMoment)
      $log.debug.text("Message will be send").param("Subject", aSubject).param("Moment", aMoment.to_s)
      message = TMessage.new $log
      message.clear
      message.content["guid"] = SecureRandom.uuid
      message.content["subject"] = aSubject
      message.content["body"] = aBody
      message.content["recipient"] = aEmail
      message.content["moment"] = aMoment.to_f.to_s
      $sender.send message    
    end



    def article_params
      params.require(:article).permit(:title, :text)
    end


    
    def authenticate_user!
      # this message i must move to external model but i to not know that place
      msgAlert="Нужны права администратора."
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
