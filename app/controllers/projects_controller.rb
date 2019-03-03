
require 'nokogiri'
require 'prawn'
class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :login_required, except: [:index, :show]
  before_action :role_required, except: [:index, :show]


  #after_filter :cookie_setup
  #before_filter :create_cookie
  # GET /projects
  # GET /projects.json


  def index
    @projects = Project.all
    if params[:m]=="clear"
      puts 'Clearring Cookie'
      
       if cookies[:webcookie]
      puts cookies[:webcookie].size
      cookies.delete :webcookie
      #reset_session
    else
      puts "No cookie"
    end
     # puts cookies.signed[:a]
    end

  end

def pgdump
end
def documentation
	#pdf = Prawn::Document.new
	#pdf_filename = File.join( Rails.root, "public/Ps3.pdf")
	#pdf_filename.render_file "Ps3.pdf"
	#send_file( pdf_filename, :filename => "Ps3.pdf", :disposition => "inline", :type => "application/pdf")
end


 def cookie_setup(q)
    puts "In cookie setup"
    
    if cookies[:webcookie].blank?
      puts "Cookie is blank"
       cookies[:webcookie] = { :value => q }
    else
      puts "No more blank"
      cookies[:webcookie] = { :value => cookies[:webcookie] + ',' + q }
    #cookies[:a] ={ :value => cookies[:a] + q }
    puts cookies[:webcookie].size
    end
  end
#GET POST Quotation
def quotations
  
     if params[:file]
      uploaded_io = params[:file] 
      File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'w') do |file|
       file.write(uploaded_io.read) 
     end

        xmlFile = File.open("#{Rails.root}/public/uploads/" + uploaded_io.original_filename)
         doc = Nokogiri::XML(xmlFile)
          variant = doc.xpath("//quotation")

        variant.each do |quote|

        quote_hash = {:name => quote.xpath("author-name").text, :category => quote.xpath("category").text, :quote => quote.xpath("quote").text}
        Quotation.create(quote_hash) 
      end
    end

  puts cookies[:webcookie]
   if cookies[:webcookie]
      @c_array = cookies[:webcookie].split(/,/)
    end
 if params[:k]=="kill"
       @q= Quotation.find(params[:quote_id]).id
       @w = @q.to_s
      cookie_setup(@w)

   end
       

  if params[:search] 
      puts params[:search]
      puts "Creating Quotations search"
      @search_condition = "%" + params[:search] + "%" 
      if cookies[:webcookie]
        $quotationslist = Quotation.find( :all, :conditions => ['(lower(author_name) LIKE ? or lower(quote) LIKE ?) and id NOT IN (?)',@search_condition.downcase,@search_condition.downcase,@c_array] )
      else
        puts "In the search"
      $quotationslist = Quotation.find( :all, :conditions => ['lower(author_name) LIKE ? or lower(quote) LIKE ? ',@search_condition.downcase,@search_condition.downcase] )
      end   
       else 
      puts "HERE"
      if cookies[:webcookie]
      @c_array = cookies[:webcookie].split(/,/)
  
      $quotationslist = Quotation.find( :all, :conditions => ["id NOT IN (?)", @c_array])
    else
       $quotationslist = Quotation.all
    end
    end


       @list = Quotation.uniq.pluck(:category)
            if params[:quotation]
             
          @quotation = Quotation.new(params[:quotation])

            if @quotation.save
               puts "Creating Quotations3"
            flash[:notice] = 'Quotation was successfully created.'
            @quotation = Quotation.new
            end
          else
             #puts "Creating Quotations4"
            @quotation = Quotation.new
          end
          
          
          if params[:sort_by] == "date"
             #puts "Creating Quotations5"
             if  cookies[:webcookie]
            @quotations = Quotation.find( :all, :order => :created_at, :conditions => ["id NOT IN (?)", @c_array] )
            else
            @quotations = Quotation.find( :all, :order => :created_at)
            end 

          else
            if cookies[:webcookie]
              @quotations = Quotation.find( :all, :order => :category, :conditions => ["id NOT IN (?)", @c_array])
             #puts "Creating Quotations6"
           else
            @quotations = Quotation.find( :all, :order => :category )
          end
          end
          respond_to do |format|
            format.html 
            format.json { render json: @quotations}
            format.xml {render :xml => @quotations}
          end
   end

def uploadFile
  puts "In upload file"
end

def trendingNow
	begin
		@trendingList,@trendLink = Project.viewSource
	end
end


def error
	begin
	@dividebyzero = Project.divide(1,0)

	#rescue Exception => e 
	#puts e.message 
	#raise e.backtrace.inspect
	end
end

  # GET /projects/1
  # GET /projects/1.json
  def show
	
  end

  # GET /projects/new
  def new
    @project = Project.new
  end


  # GET /projects/1/edit
  def edit

  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render action: 'show', status: :created, location: @project }
      else
        format.html { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name)
    end
end
