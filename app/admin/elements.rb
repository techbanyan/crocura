ActiveAdmin.register Element do
    config.clear_action_items!
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

    index do
        column :privacy
        column :help
        column :faq
        column :how_it_works
        column :about
        column "Actions" do |element|
            link_to "View", admin_element_path(element)
        end
        column "Actions" do |element|
            link_to "Edit", edit_admin_element_path(element)
        end
    end
end
