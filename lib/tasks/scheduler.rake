desc "Heroku scheduler - Flushes out old Photos"
task :flush_out_old_photos => :environment do
    puts "Flushing out old photos"
    Photo.flush_out_old_photos
    puts "done."
end