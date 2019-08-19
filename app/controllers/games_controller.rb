class GamesController < ApplicationController
  VOWELS = %w[A E I O U Y]

  def new
    # @letters = ('A'..'Z').to_a.sample(10)
    # @letters = []
    # 10.times { @letters << ('A'..'Z').to_a[Random.new.rand(0..25)] }
    # @letters
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @word = params[:word].upcase.chars
    @letters_control = params[:test].split
    @response = responsive
  end

  private

  def valid_word?
    response = RestClient.get "https://wagon-dictionary.herokuapp.com/#{@word.join}"
    json_string = response.body
    json = JSON.parse(json_string)
    json['found']
  end

  def responsive
    if @word.any? { |letter| @word.join.count(letter) > @letters_control.join.count(letter) }
      "Sorry but #{@word.join} can't be built out of #{@letters_control.join(',')}"
    elsif !valid_word?
      "Sorry but #{@word.join} does not seem to be a valid English word..."
    else
      "Congratulations! #{@word.join} is a valid English word"
    end
  end
end
