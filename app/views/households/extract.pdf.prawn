pdf.font "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"
pdf.image "#{Rubycampus::Info::extract_header_logo}", :at => [0,750], :width => 150
pdf.text "#{Rubycampus::Info::extract_generated_by}", :at => [400,50], :size => 6
pdf.text "#{current_controller_human_name} Extract", :at => [350,730], :size => 20 
pdf.text "#{@household_presenter.contact_household_name}", :at => [0,690], :size => 20