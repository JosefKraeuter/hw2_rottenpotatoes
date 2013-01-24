class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

	
	@all_ratings = Movie.getratings
	

	if params[:id]
		session[:id] = params[:id]
	end

	if params[:ratings]
		session[:ratings] = params[:ratings]
	end

	if session[:id] and session[:ratings]
		@movies = Movie.order("#{session[:id]} ASC").where(:rating => session[:ratings].keys)
	elsif session[:id] 
		@movies = Movie.order("#{session[:id]} ASC").all
	elsif session[:ratings]
	    	
		@movies = Movie.where(:rating => session[:ratings].keys)
	else
		@movies = Movie.all  
	end

	

	if (session[:id] == "title")
		@movi = 'hilite'
		@dati = ''
	elsif (session[:id] == "release_date")
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
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
