class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

	
	@all_ratings = Movie.getratings
	
	


	if params[:filter]
		session[:filter] = params[:filter]
	end

	if params[:ratings]
		session[:ratings] = params[:ratings]
	end

	unless (params[:filter] and params[:ratings]) 
		if session[:ratings] and session[:filter]
				redirect_to movies_url(:action =>"index",:filter => session[:filter], :ratings => session[:ratings])
		
		elsif not params[:ratings] and session[:ratings] 
				redirect_to movies_url(:action =>"index",:ratings => session[:ratings])
		
		elsif not params[:filter] and session[:filter] 
				redirect_to movies_url(:action =>"index",:filter => session[:filter])
		end
		
	end 

	@checkedratings = {}

	

	if params[:ratings]
	
		@all_ratings.each do |rating|
			@checkedratings[rating] = false
		end		

		params[:ratings].keys.each do |rating|
			@checkedratings[rating] = true
		end
		session[:checkedratings] = @checkedratings	

	elsif session[:checkedratings]
		@checkedratings	 = session[:checkedratings]

	else
		@all_ratings.each do |rating|
			@checkedratings[rating] = true
		end
	end	


	if session[:filter] and session[:ratings]
		@movies = Movie.order("#{session[:filter]} ASC").where(:rating => session[:ratings].keys)
	elsif session[:filter] 
		@movies = Movie.order("#{session[:filter]} ASC").all
	elsif session[:ratings]
	    	
		@movies = Movie.where(:rating => session[:ratings].keys)
	else
		@movies = Movie.all  
	end

	

	if (session[:filter] == "title")
		@movi = 'hilite'
		@dati = ''
	elsif (session[:filter] == "release_date")
		@movi = ''
		@dati = 'hilite'
	else 	
		@movi = ''
		@dati = ''
	end
end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:filter]
  end

  def update
    @movie = Movie.find params[:filter]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:filter])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end

