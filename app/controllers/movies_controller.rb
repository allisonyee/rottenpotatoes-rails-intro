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
    # initialization
    @all_ratings = Movie.possible_ratings
    @checked_ratings = @all_ratings
    @movies = Movie.all
    unsorted_movies = @movies
    
    if params[:ratings]
      session[:ratings] = params[:ratings]
      @checked_ratings = params[:ratings].keys
      @movies = Movie.where("rating IN (?)", @checked_ratings)
      unsorted_movies = @movies
    end
    if params[:sorted_by_title] == 'true'
      session[:sorted_by_title] = 'true'
      session[:sorted_by_date] = nil
      @sorted_title = true
      @movies = unsorted_movies.order("title ASC")
    elsif params[:sorted_by_date] == 'true'
      session[:sorted_by_title] = nil
      session[:sorted_by_date] = 'true'
      @sorted_date = true
      @movies = unsorted_movies.order("release_date ASC")
    end
    
    # If session contains data not in URI, redirect to URI with complete params
    current_session = {}
    current_params = {}
    [:ratings, :sorted_by_title, :sorted_by_date].each do |param|
      if session[param]
        current_session[param] = session[param]
      end
      if params[param]
        current_params[param] = params[param]
      end
    end
    if current_session != current_params
      flash.keep
      redirect_to movies_path(current_session)
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
