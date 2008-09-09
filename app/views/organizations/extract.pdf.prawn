pdf.font "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"
pdf.image "#{RAILS_ROOT}/public/images/rubycampus/logo.png", :at => [0,750], :width => 150
pdf.text "#{Rubycampus::Info::extract_generated_by}", :at => [400,50], :size => 6
pdf.text "#{current_controller_human_name} Extract", :at => [350,730], :size => 20 
pdf.text "#{@presenter.contact_organization_name}", :at => [0,690], :size => 20