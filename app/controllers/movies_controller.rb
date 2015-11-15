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
    do_redirect = false
    if not params[:order_by].nil?
      session[:order_by] = params[:order_by]
    elsif not session[:order_by].nil?
      flash.keep
      params[:order_by] = session[:order_by]
      do_redirect = true
    end
    @all_ratings = Movie.ratings
    if not params[:ratings].nil? 
      @chosen_ratings = params[:ratings].keys
      session[:chosen_ratings] = params[:ratings].keys
    elsif not session[:chosen_ratings].nil?
      flash.keep
      params[:ratings] = Hash[session[:chosen_ratings].map { |rating| [rating, '1'] }]
      @chosen_ratings = session[:chosen_ratings]
      do_redirect = true
    else
       @chosen_ratings = @all_ratings
    end
    if do_redirect then redirect_to movies_path(params) end
    flash.clear
    flash[session[:order_by]] = 'hilite'
    @movies = Movie.all.order(session[:order_by]).where(:rating => @chosen_ratings)
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
