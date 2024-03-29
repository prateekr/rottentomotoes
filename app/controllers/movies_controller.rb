class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.get_ratings
    @need_redirect = false

    #Retrieve attribute to filter by
    if params['options'] == nil
      @options = session[:sorting_option]
      params['options'] = session[:sorting_option]
      @need_redirect = true if session[:sorting_option] != nil
    else
      @options = params['options']
      session[:sorting_option] = params['options']
    end

    #Retrieve ratings to filter by
    if session[:enabled_ratings] == nil
      session[:enabled_ratings] = Hash.new
      @all_ratings.each{|rating| session[:enabled_ratings][rating] = 1}
      params[:sorting_option] = session[:enabled_ratings]
      @need_redirect = true
    elsif params[:ratings] != nil
      session[:enabled_ratings] = params[:ratings]
    elsif params[:ratings] == nil
      params[:ratings] = session[:enabled_ratings]
      @need_redirect = true
    end

    @movies = Movie.find(:all, :conditions => ["rating IN (?)", session[:enabled_ratings].keys])

    @movies = @movies.sort_by {|movie| movie.title} if @options == 'sort_by_title'
    @movies = @movies.sort_by {|movie| movie.release_date} if @options == 'sort_by_date'
    redirect_to movies_path(params) if @need_redirect
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
