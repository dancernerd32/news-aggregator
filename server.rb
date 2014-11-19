require 'sinatra'
require 'pry'
require 'sinatra/reloader'

get '/' do
  erb :homepage
end

get '/articles' do
  @articles = File.read('articles.csv').split("\n")
  @articles_array=[]
  @articles.each do |article|
    @articles_array<<article.split(',')
  end
  erb :articles
end

post '/articles/new/submissions' do
  article = []
  article << params['article_title']
  article << params['article_url']
  article << params['article_description']

  File.open('articles.csv', 'a') {|file| file.puts(article.join(','))}

  redirect '/articles'

end

get '/articles/new' do


  erb :new_articles_form
end
