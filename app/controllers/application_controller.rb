require 'json'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
  end

  def get_branch_details
    if params[:ifsc].nil? || params[:ifsc].empty?
      error = "Invalid arguments!"
    else
      error = ""
      branch = Branch.where(:ifsc => params[:ifsc].upcase)
      error = "No such IFSC exists" if branch.empty?
    end

  	if error.empty?
  		bank = branch[0].bank.name
  		render json: branch
  	else
  		render json: {error: error}
  	end
  end

  def get_city_branches
    if params[:name].nil? || params[:city].nil? || params[:name].empty? || params[:city].empty?
      error = "Invalid arguments!"
    else
      error = ""
    	bank = Bank.where(:name => params[:name].upcase)
    	if bank.empty?
    		error = "No such bank. Please check again"
    	else
    		branches = bank[0].branches.where(:city => params[:city].upcase)
    		if branches.empty?
    			error = "No branches found of the bank."
    		else
    			branches_json = []
    			branches.each do |branch|
    				branches_json << branch
    			end
    		end
      end
  	end

  	if error.empty?
  		render json: branches_json
  	else
  		render json: {error: error}
  	end
  end

end
