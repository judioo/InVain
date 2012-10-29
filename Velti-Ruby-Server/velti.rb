require 'rubygems'
require 'data_mapper'
require 'sinatra'
require 'sinatra/reloader'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'mysql://velti:velti123@localhost/velti')


class Vote
  include DataMapper::Resource

  storage_names[:default] = "vote"

  property  :id       , Serial
  property  :vote     , DateTime
  property  :campaign , String
  property  :validity , String
  property  :choice   , String
  property  :conn     , String
  property  :msisdn   , String
  property  :guid     , String
  property  :shortcode, String
end

DataMapper.finalize

configure do
  set :port => 3001
end

get '/' do

  @rs     = Vote.all(:fields => [:campaign], :unique => true, :order => [:campaign.asc])
  erb :homepage
end

get '/campaign/:campaign' do 
  @campaign_title = params[:campaign];

  @rows   = repository(:default).adapter.select('SELECT campaign, validity, choice, count(validity) AS count FROM ' +
            'vote WHERE campaign = ? GROUP BY campaign, choice, validity ORDER BY count DESC',params[:campaign])
  @stats  = { 'pre' => 0, 'during' => 0, 'post' => 0, 'total' => 0 }


  erb:campaign
end
