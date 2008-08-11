require 'rubygems'
require 'httparty'

class YahooMusic
  include HTTParty
  base_uri 'us.music.yahooapis.com'
  format :xml
  
  def initialize(api_key)
    @api_key = api_key
  end
  
  # Artist Service
  #
  # Required Parameters:
  #    :keyword
  #    :search_mode  [ all or artist ]
  # Valid Options:
  #    :appid 
  #    :response [ an array of strings.. valid tokens:  releases, toptracks, topsimilar, radio, events, fans, videos, sorts ]
  #    :start    [ start index of the list ]
  #    :count    [ number of items to return from start *max 100* ]
  #    :censor   [ 1 will return 'family only' results ]
  #    :spelltoken
  def artist_search(keyword, search_mode='all', options={})
    resp_types, opts = merge_defaults(options, %w(releases toptracks topsimilar radio events fans videos sorts))
    self.class.get("/artist/v1/list/search/#{search_mode}/#{URI.escape(keyword)}?response=#{resp_types.join(',')}", opts)
  end
  
  # Required Parameters:
  #    :ids   [ an array of artist ids ]
  # Valid Options:
  #    :response [ an array of strings.. valid tokens: releases, toptracks, topsimilar, radio, events, fans, videos, sorts ]
  #    :appid
  def artist_by_ids(ids, options={})
    resp_types, opts = merge_defaults(options, %w(releases toptracks topsimilar radio events fans videos sorts))
    self.class.get("/artist/v1/item/#{ids}?response=#{resp_types.join(',')}", opts)
  end
  
  # Required Parameters
  #   :category_id  [ a string or an integer representing a single category_id ]
  # Valid Options:
  #   :response [ an array of strings.. valid tokens:  releases, toptracks, topsimilar, radio, events, fans, videos, sorts ]
  #   :start    [ start index of the list ]
  #   :count    [ number of items to return from start *max 100* ]
  #   :sort 
  def artist_by_category(category_id, options={})
    resp_types, opts = merge_defaults(options, %w(releases toptracks topsimilar radio events fans videos sorts))
    self.class.get("/artist/v1/list/category/#{category_id.to_s}?response=#{resp_types.join(',')}", opts)
  end
  
  # Category Service
  #
  # def category_by_ids(ids, response_types=%w(shortdesc longdesc artists radiostation videostation sorts))
  #    self.class.get("/category/v1/item/#{ids.join(',')}?response=#{response_types.join(',')}&appid=#{@api_key}")
  #  end
   
  # valid types: genre, era, theme
  # TODO: support all valid options.
  def category_tree(type='genre', options = {})
    if options[:appid].nil? || options[:appid].empty?
      options[:appid] = @api_key
    end
    self.class.get("/category/v1/tree/#{type}", {:query => options})
  end
  
  # Release Service
  #
  def release_album()
  end
  
  def release_artist()
  end
  
  def release_search(keyword, search_mode='all', options={})
    resp_types, opts = merge_defaults(options, %w(main tracks artists categories fans reviews sorts))
    self.class.get("/release/v1/list/search/#{search_mode}/#{keyword}?response=#{resp_types.join(',')}", opts)
  end
  
  # Track Service
  #
  def track_by_ids
  end
  
  def track_by_artist
  end
  
  def track_search
  end
  # Video Service
  #
  
  # see http://developer.yahoo.com/music/api_guide/VideoService.html
  def video_by_ids(ids, options={})
    resp_types, opts = merge_defaults(options, %w(main artists releases tracks categories))
    self.class.get("/video/v1/item/#{ids.map{ |id| id.to_s }.join(',')}?response=#{resp_types.join(',')}", opts)
  end
  
  # see http://developer.yahoo.com/music/api_guide/VideoService.html
  def video_by_artist_letter(letter, options={})
    resp_types, opts = merge_defaults(options, %w(artists releases tracks categories))
    self.class.get("/video/v1/list/artist/alpha/#{letter}?response=#{resp_types.join(',')}", opts)
  end
  
  # Valid Options:
  #    :appid 
  #    :response [ an array of strings.. valid tokens:  artists, releases, tracks, categories ]
  #    :start    [ start index of the list ]
  #    :count    [ number of items to return from start *max 100* ]
  #    :censor   [ 1 will return 'family only' results ]
  def video_search(keyword, search_mode='all', options={})
    resp_types, opts = merge_defaults(options, %w(main artists releases tracks categories))
    self.class.get("/video/v1/list/search/#{search_mode}/#{URI.escape(keyword)}?response=#{resp_types.join(',')}", opts)
  end
  
  def video_by_category(id, response_types=%w(artists releases))
  end
  
protected
  def merge_defaults(options, default_response_types)
    resp_type = options[:response]
    if resp_type.nil? || resp_type.empty?
      resp_type = default_response_types
    end
    if options[:appid].nil? || options[:appid].empty?
      options[:appid] = @api_key
    end
    options.delete(:response)
    [resp_type, {:query => options}]
  end
end
