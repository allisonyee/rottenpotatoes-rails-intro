class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sorted_title = false
    @sorted_date = false
    @all_ratings = Movie.possible_ratings
    @checked_ratings = @all_ratings
    if params[:ratings]
      @checked_ratings = params[:ratings].keys
    end
    if params[:sorted_by_title] == 'true'
      @movies = Movie.where("rating IN (?)", @checked_ratings).order("title ASC")
      @sorted_title = true
    elsif params[:sorted_by_date] == 'true'
      @movies = Movie.where("rating IN (?)", @checked_ratings).order("release_date ASC")
      @sorted_date = true
    else 
      @movies = Movie.where("rating IN (?)", @checked_ratings)
      # @movies = Movie.where('rating = "G" OR rating = "PG"')
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
