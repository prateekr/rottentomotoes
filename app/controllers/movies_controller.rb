class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.get_ratings
    @options = params['options']

    if session.keys.include?(:enabled_ratings) == nil
      @all_ratings.each{|rating| params[:ratings][rating.to_sym] = 1}
      session[:enabled_ratings] = params[:ratings]
    else
      session[:enabled_ratings] = params[:ratings]
    end


    @movies = Movie.find(:all, :conditions => ["rating IN (?)", params[:ratings].keys]) if params[:ratings] != nil

    @movies = @movies.sort_by {|movie| movie.title} if params['options'] == 'sort_by_title'
    @movies = @movies.sort_by {|movie| movie.release_date} if params['options'] == 'sort_by_date'
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
