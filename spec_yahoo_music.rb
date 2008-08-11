require 'yahoo_music'
require 'test/spec'

YAHOO_MUSIC_API_KEY = 'kKq7PobV34GpmKOYLFtflkij2CRaUQJVAxtracFYGgdk2ZfxUSeed3.a6j6KpRE-'

# Video
#
context 'A video search with a known artist and default parameters' do
  setup do
    @ym = YahooMusic.new YAHOO_MUSIC_API_KEY
    @result = @ym.video_search('nirvana')
  end
  
  specify 'should have been a succesful query' do
    @result['Error'].should.be nil
  end
  
  specify 'should not be empty' do
    @result.class.should.be Hash
    @result.empty?.should.be false
  end
  
  specify 'should contain videos, show no errors and have a valid count' do
    @result.has_key?('Videos').should.be true
    @result['Videos']['errorCount'].to_i.should.equal 0
    vid_count = @result['Videos']['count'].to_i
    vid_count.should.be > 0
    @result['Videos']['Video'].class.should.be Array
    @result['Videos']['Video'].size.should.equal vid_count
  end
end

context 'A video search for a known artist with spaces in the name and default parameters' do
  setup do
    @ym = YahooMusic.new YAHOO_MUSIC_API_KEY
    @result = @ym.video_search('the pixies')
  end
  
  specify 'should have been a succesful query' do
    @result['Error'].should.be nil
  end
  
  specify 'should not be empty' do
    @result.class.should.be Hash
    @result.empty?.should.be false
  end
  
  specify 'should contain videos, show no errors and have a valid count' do
    @result.has_key?('Videos').should.be true
    @result['Videos']['errorCount'].to_i.should.equal 0
    vid_count = @result['Videos']['count'].to_i
    vid_count.should.be > 0
    @result['Videos']['Video'].class.should.be Array
    @result['Videos']['Video'].size.should.equal vid_count
  end
end

context 'A video search with an unknown band and default parameters' do
  setup do
    @ym = YahooMusic.new YAHOO_MUSIC_API_KEY
    @result = @ym.video_search('eikeiurjkjeri')
  end
  
  specify 'should have been a succesful query' do
    @result['Error'].should.be nil
  end
  
  specify 'should not be empty' do
    @result.class.should.be Hash
    @result.empty?.should.be false
  end
  
  specify 'should not contain videos and have a valid count' do
    @result.has_key?('Videos').should.be true
    @result['Videos']['errorCount'].to_i.should.equal 0
    vid_count = @result['Videos']['count'].to_i
    vid_count.should.be 0
    @result['Videos']['Video'].should.be nil
  end
end

context 'A video_by_ids query with valid ids and default parameters' do
  setup do
    @video_ids = [2149204, 2145414, 2145415]
    @ym = YahooMusic.new YAHOO_MUSIC_API_KEY
    @result = @ym.video_by_ids(@video_ids)
  end
  
  specify 'should have been a succesful query' do
    @result['Error'].should.be nil
  end
  
  specify 'should not be empty' do
    @result.class.should.be Hash
    @result.empty?.should.be false
  end
  
  specify 'should contain the requested videos and show no errors' do
    @result.has_key?('Videos').should.be true
    @result['Videos']['errorCount'].to_i.should.equal 0
    vid_count = @result['Videos']['count'].to_i
    vid_count.should.be @video_ids.size
    @result['Videos']['Video'].class.should.be Array
    @result['Videos']['Video'].size.should.equal vid_count
    @result['Videos']['Video'].each { |vid| @video_ids.include?(vid['id'].to_i).should.be true }
  end
end

context 'A video_by_ids query with unknown ids and default parameters' do
  setup do
    @video_ids = [rand(99999999), rand(9999999), rand(999999) ]
    @ym = YahooMusic.new YAHOO_MUSIC_API_KEY
    @result = @ym.video_by_ids(@video_ids)
  end
  
  specify 'should not be empty' do
    @result.class.should.be Hash
    @result.empty?.should.be false
  end
  
  specify 'should have been a succesful query' do
    @result['Error'].should.be nil
  end
  
  specify 'should show errors for every bad id' do
    @result['Videos']['errorCount'].to_i.should.equal @video_ids.size
  end
end

# Artist
#
context 'An artist search with a known artist and default parameters' do
  setup do
    @ym = YahooMusic.new YAHOO_MUSIC_API_KEY
    @result = @ym.artist_search('nirvana')
  end
  
  specify 'should have been a succesful query' do
    @result['Error'].should.be nil
  end
  
  specify 'should not be empty' do
    @result.class.should.be Hash
    @result.empty?.should.be false
  end
  
  specify 'should contain artists, show no errors and have a valid count' do
    @result.has_key?('Artists').should.be true
    @result['Artists']['errorCount'].to_i.should.equal 0
    art_count = @result['Artists']['count'].to_i
    art_count.should.be > 0
    @result['Artists']['Artist'].class.should.be Array
    @result['Artists']['Artist'].size.should.equal art_count
  end
end

context 'An artist search with a known artist with spaces in the name and default parameters' do
  setup do
    @ym = YahooMusic.new YAHOO_MUSIC_API_KEY
    @result = @ym.artist_search('Nine Inch Nails')
  end
  
  specify 'should not be empty' do
    @result.class.should.be Hash
    @result.empty?.should.be false
    @result['Error'].should.be nil
  end
  
  specify 'should contain artists, show no errors and have a valid count' do
    @result.has_key?('Artists').should.be true
    @result['Artists']['errorCount'].to_i.should.equal 0
    art_count = @result['Artists']['count'].to_i
    art_count.should.be > 0
    @result['Artists']['Artist'].class.should.be Array
    @result['Artists']['Artist'].size.should.equal art_count
  end
end

context 'An artist search with an unknown artist and default parameters' do
  setup do
    @ym = YahooMusic.new YAHOO_MUSIC_API_KEY
    @result = @ym.artist_search('toiutcvbiuepqnghaz')
  end
  
  specify 'should not be empty' do
    @result.class.should.be Hash
    @result.empty?.should.be false
    @result['Error'].should.be nil
  end
  
  specify 'should contain artists, show no errors and have a count of 0' do
    @result.has_key?('Artists').should.be true
    @result['Artists']['errorCount'].to_i.should.equal 0
    art_count = @result['Artists']['count'].to_i
    art_count.should.equal 0
    @result['Artists']['Artist'].should.be nil
  end
end

context 'An artist_by_id query with a single valid artist_id and default parameters' do
  setup do
    @artist_ids = [21783032]
    @ym = YahooMusic.new YAHOO_MUSIC_API_KEY
    @result = @ym.artist_by_ids(@artist_ids)
  end
  
  specify 'should not be empty' do
    @result.class.should.be Hash
    @result.empty?.should.be false
    @result['Error'].should.be nil
  end
  
  specify 'should contain artists, show no errors and have a valid count' do
    @result.has_key?('Artists').should.be true
    @result['Artists']['errorCount'].to_i.should.equal 0
    @result['Artists']['Artist'].should.not.be nil
    @result['Artists']['Artist']['id'].to_i.should.equal @artist_ids[0]
  end
end

context 'A category_tree query with default parameters' do
  setup do
    @ym = YahooMusic.new YAHOO_MUSIC_API_KEY
    @result = @ym.category_tree
  end
  
  specify 'should have been a succesful query' do
    @result['Error'].should.be nil
  end
  
  specify 'should not be empty' do
    @result.class.should.be Hash
    @result.empty?.should.be false
  end
end

context 'A release_search query with a known artist for a keyword and default parameters' do
  setup do
    @ym = YahooMusic.new YAHOO_MUSIC_API_KEY
    @result = @ym.release_search('nirvana')
    puts @result.inspect
  end
  
  specify 'should have been a succesful query' do
    @result['Error'].should.be nil
  end
  
  specify 'should not be empty' do
    @result.class.should.be Hash
    @result.empty?.should.be false
  end
end

# context 'An artist_by_category query with a valid category_id and default parameters' do
#   setup do
#     @category_id = 7318639
#     @ym = YahooMusic.new YAHOO_MUSIC_API_KEY
#     @result = @ym.artist_by_category(@category_id)
#     puts @result.inspect
#   end
# 
#   specify 'should have been a succesful query' do
#     @result['Error'].should.be nil
#   end
# 
#   specify 'should not be empty' do
#     @result.class.should.be Hash
#     @result.empty?.should.be false
#   end
#   
#   specify 'should contain artists' do
#     @result.has_key?('Artists').should.be true
#     @result['Artists']['errorCount'].to_i.should.equal 0
#     @result['Artists']['Artist'].should.not.be nil
#   end
# end