require 'open-uri'

class GamesController < ApplicationController

  def new
    puts current_user
    @letters = generate_grid(10)
    @highest_score = session[:points]
  end

  def score
    @messages = []

    if params[:word] && params[:letters]
      @word = params[:word]
      @letters = params[:letters].split('')
      letters = @letters.dup

      @messages << "Sorry but \"#{@word}\" can't be built out of #{letters}" unless used_only_letters?
      @messages << "Sorry but \"#{@word}\" does not seem to be a valid English word..." unless english_word?
      if @messages.empty? 
        @messages << "Congratulations! \"#{@word}\" is a valid English word!" 
        @current_score = count_point
        session[:points] = session[:points] ? session[:points] + @current_score : 0
      end
    else
      @messages << "Something went wrong... please try again!"
    end

    @highest_score = session[:points]
  end

  private

  DICTIONARY_API = 'https://wagon-dictionary.herokuapp.com'

  def generate_grid(grid_size)
    (1..grid_size).map { rand(65..90).chr }
  end

  def used_only_letters?
    @word.upcase.split("").all? do |letter|
      if @letters.include?(letter)
        @letters.delete_at(@letters.find_index(letter))
      else
        return false
      end
    end
  end

  def english_word?
    dictionary_reponse['found']
  end

  def dictionary_reponse
    result = open("#{DICTIONARY_API}/#{@word}").read
    JSON.parse(result)
  end

  def count_point
    @word.length ** 2
  end

  def current_user
    @_current_user ||= session[:current_user_id] &&
      User.find_by(id: session[:current_user_id])
  end

end
