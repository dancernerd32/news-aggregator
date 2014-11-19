require 'sinatra'
require 'pry'
require 'sinatra/reloader'
require 'uri'

def articles_array
  articles = File.read('articles.csv').split("\n")
  articles_array=[]
  articles.each do |article|
    articles_array<<article.split(',')
  end
  articles_array
end

get '/' do
  erb :homepage
end

get '/articles' do
  @articles_array = articles_array
  erb :articles
end

post '/articles/new/submissions' do
  @article_title = params['article_title']
  @article_url = params['article_url']
  @article_description = params['article_description']
  @errors = {}
  if params['article_title'].empty?
    @errors[:title] = "Error: Please provide a title"
  end
  if params['article_url'].empty?
    @errors[:url] = "Error: Please enter a valid url"
  end
  if params['article_description'].length < 20
    @errors[:description] = "Error: Your description must contain at least 20 characters"
  end
  @articles_array = articles_array
  @articles_array.each do |article|
    if params['article_url'] == article[1]
      @errors[:plagiarized] = "Error: That URL is already on this site"
    end
  end

  if @errors.empty?
    article = []
    article << params['article_title']
    article << params['article_url']
    article << params['article_description']

    File.open('articles.csv', 'a') {|file| file.puts(article.join(','))}

    redirect '/articles'
  else
    erb :new_articles_form
  end

end

get '/articles/new' do
  @errors = {}


  erb :new_articles_form
end
