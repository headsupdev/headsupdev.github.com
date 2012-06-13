
module Jekyll
  class ReleasesGenerator < Generator
    safe true

    # Read all the files in <source>/<dir>/_releases and create a new Post
    # object with each one.
    #
    # dir - The String relative path of the directory to read.
    #
    # Returns nothing.
    def read_releases(site, dir = '_releases')
      base = File.join(site.source, dir, '_posts')
      return unless File.exists?(base)
      entries = Dir.chdir(base) { Dir['**/*'] }

      # first pass processes, but does not yet render post content
      entries.each do |f|
        begin
          post = Post.new(site, site.source, dir, f)
        rescue => e
          #$stdout.puts $!.backtrace
          $stdout.puts "#{e.message}"
        end

        site.config['releases'] << post
      end

      site.config['releases'].sort!

      # limit the posts if :limit_posts option is set
#      if limit_posts
#        limit = site.config['releases'].length < limit_posts ? sites.config['releases'].length : limit_posts
#        site.config['releases'] = site.config['releases'][-limit, limit]
#      end
    end

    def generate(site)
      site.config['releases'] = []
      self.read_releases(site)
    end
  end
end
