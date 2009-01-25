class ShowReadOnly
  
  def self.included(base)
    base.extend(FormHelper)
  end  

  module FormHelper
    
    #def show_readonly_process_options(options)
    #  readonly_options = {}
    #  for key in [:value]
    #    readonly_options[key] = options.delete(key) if options.has_key?(key)
    #  end
    #  readonly_options
    #end      
    
    def show_readonly(object, method, options={})        
      #obj = options[:object] || instance_variable_get("@#{object}")
      #readonly_options = show_readonly_process_options(options)
      
      #if options[:value] == true
       render :inline => "<script type=\"text/javascript\">var form=$('edit_"+controller.controller_name.singularize+"_"+params[:id]+"'); form.disable(); form.disabled = !form.disabled;</script>"
      #else 
      #  render :inline => ""
      #end
    end 
    
  end  
end

module ActionView
  module Helpers
    class FormBuilder
      def show_readonly(method, options = {})
        @template.show_readonly(@object_name, method, options.merge(:object => @object))
      end
    end
  end
end