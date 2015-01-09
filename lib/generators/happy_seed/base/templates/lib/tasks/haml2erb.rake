desc "Converts everything to erb"
task :haml2erb do
  require 'httparty'

  FileUtils.mkdir_p "lib/templates/erb"

  Dir.glob( "**/*.haml").each do |f|
    puts "Converting #{f}"

    data = File.read( f )

    resp = HTTParty.post( "http://haml2erb.herokuapp.com/api.html", { query: { haml: data } } )

    puts "FROM--------"
    puts data
    puts "TO--------"
    puts resp.body

    outfile = f.gsub( /\.haml/, ".erb" )

    if outfile =~ /templates\/haml/
      outfile.gsub!( /templates\/haml/, "templates/erb" )
      puts "outfile = #{outfile}"

      FileUtils.mkdir_p( Pathname.new( outfile ).dirname )
    end

    File.open( outfile, "w" ) do |out|
      out.puts resp.body
    end

    FileUtils.mv( f, "#{f}.bak" )
  end
end
