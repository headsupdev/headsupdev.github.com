
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
      $stdout.puts base
      return unless File.exists?(base)
      entries = Dir.chdir(base) { Dir['**/*'] }

      # first pass processes, but does not yet render post content
      entries.each do |f|
        $stdout.puts f
        $stdout.puts Post
        begin
          post = Post.new(site, site.source, dir, f)
        rescue => e
          $stdout.puts $!.backtrace
          $stdout.puts "#{e.message}"
        end

        $stdout.puts post
        site.releases << post
      end
      $stdout.puts "done"
      $stdout.puts site.releases

      site.releases.sort!

      # limit the posts if :limit_posts option is set
      if limit_posts
        limit = site.releases.length < limit_posts ? site.posts.length : limit_posts
        site.releases = site.releases[-limit, limit]
      end
    end

    def generate(site)
      #site.releases = []
      self.read_releases(site)

      self.read_directories
      $stdout.puts self.releases
    end
  end
end
