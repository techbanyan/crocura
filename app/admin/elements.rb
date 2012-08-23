ActiveAdmin.register Element do

    form do |f|
        f.inputs "Element Details" do
            f.input :privacy, :as => :rich
            f.input :help, :as => :rich
            f.input :faq, :as => :rich
            f.input :how_it_works, :as => :rich
            f.input :about, :as => :rich
        end
        f.buttons
    end  
end
