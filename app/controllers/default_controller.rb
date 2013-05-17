class DefaultController < ApplicationController
  def default
  end

  def files
    if params[:file]
      send_file "files/#{params[:file]}"
    else
      @files = Dir.entries("files").select { |fn| fn && !fn.start_with?('.') }
    end
  end

  def admin
    if params[:password]
      if params[:password] == 'letmein'
        session[:admin] = true
        flash[:success] = 'Password Accepted'
        redirect_to :admin
      else
        flash[:error] = 'Bad Password'
        redirect_to :admin
      end
    elsif params[:logout]
      session.delete(:admin)
      flash[:info] = 'Logged Out'
      redirect_to :admin
    else
      if session[:admin]
        @secret = "The meaning of life and everything is '42'" 
      else
        render :admin, :status => :forbidden
      end
    end
  end

  def email
    if params[:token]
      if params[:token] == session[:token]
        flash[:success] = 'Email Successfully Verified'
        session.delete(:token)
        redirect_to :email
      else
        flash[:error] = 'Invalid Token'
        redirect_to :email
      end  
    elsif params[:email]
	session[:token] = SecureRandom.hex(32)
        flash[:info] = 'Verification Email Sent'
        redirect_to :email
    end  
  end

  def store
    if ! session[:credits]
      session[:credits] = 0
    end
    if params[:buy]
      if session[:credits] >= 10
        session[:credits] -= 10
        flash[:success] = '10 Credit Purchase Successful'
        flash[:purchased] = true
        redirect_to :store
      else
        flash[:error] = 'Not enough credits'
        redirect_to :store
      end
    elsif params[:cc]
      credits = params[:credits].to_i
      session[:credits] += credits
      flash[:success] = "#{credits} Credit Refill Successful" 
      redirect_to :store
    end
  end
end
