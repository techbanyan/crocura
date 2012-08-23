namespace :db do
	desc "Fill Database with Elements like FAQ, Help, Privacy, About, etc."
	task :populate => :environment do
		Rake::Task['db:reset'].invoke
		make_elements
		create_first_admin
	end
end

def make_elements
	@element = Element.new
	@element.privacy = "Login as admin to change this"
	@element.help = "login as admin to change this"
	@element.faq = "login as admin to change this"
	@element.how_it_works = "login as admin to change this"
	@element.about = "login as admin to change this"
	@element.save!
end

def create_first_admin
	AdminUser.create!(:email => 'admin@crocura.com', :password => 'amsterdam', :password_confirmation => 'amsterdam')
end