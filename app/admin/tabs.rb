ActiveAdmin.register Tab do

    form do |f|
        f.inputs "Tab Details" do
            f.input :query_name
            f.input :query
            f.input :query_type, :as => :select, :collection => ["tag", "location"], :include_blank => false
            f.input :rank
        end
        f.buttons
    end
end
