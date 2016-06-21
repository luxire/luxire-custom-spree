module Spree
  module OrderMailerHelper
    def show_customized_data(luxire_line_item)
      response_string = ""
      byebug
      customized_data = luxire_line_item.customized_data
       unless customized_data.blank?
        response_string += "<br /> <br />  <p> Your customization details </p>"
        customized_data.keys.each do |customized_key|
              byebug
              response_string +=  "<tr>  <td>   #{customized_key}: </td>"
              custom_object = customized_data[customized_key]
              custom_object.keys.each do |child_customized_key|
                grand_child_obj = custom_object[child_customized_key]
                byebug
                if grand_child_obj.class.to_s == "Hash"
                    grand_child_obj.keys.each do |grand_child_key|
                    response_string += "<td>#{grand_child_key}: #{grand_child_obj[grand_child_key]} </td>"
                  end
                else
                response_string +=  "<td>  #{custom_object[child_customized_key]} </td>"
                end
              response_string += "</tr>"
               end
           end
         end
        #  erb = ERB.new(response_string)
        #  @output = erb.result(binding)
        byebug
         response_string.html_safe
    end

    def show_personalize_data(luxire_line_item)
      response_string = ""
      personalize_data  = luxire_line_item.personalize_data
      unless personalize_data.blank?
            response_string += "<br /> <br />  <p> Your Personalization details  </p>"
            personalize_data.keys.each do |personalize_key|
                response_string +=  " <tr>  <td>  #{personalize_key}: </td>"
                personalize_key = personalize_data[personalize_key]
                personalize_key.keys.each do |child_personalize_key|
                 grand_child_obj = personalize_key[child_personalize_key]
                 if  grand_child_obj.class.to_s == "Hash"
                     grand_child_obj.keys.each do |grand_child_key|
                     response_string += "<td> #{grand_child_key}: #{grand_child_obj[grand_child_key]} </td>"
                     end
                 else
                     response_string +=  "<td>  #{personalize_key[child_personalize_key]}: </td>"
                 end
                 response_string +=  "</tr>"
               end
             end
          end
          response_string.html_safe
      end

      def show_body_measurements(luxire_line_item)
        response_string = ""
        body_measurements = luxire_line_item.measurement_data["body_measurement_attributes"]
        unless body_measurements.blank?
            response_string +=" <br /> <br />  <p>  Your Body Measurement details </p> "
             body_measurements.keys.each do |body_measurement_key|
                  response_string += "<tr>  <td>  #{body_measurement_key}: </td>"
                  body_measurement_key = body_measurements[body_measurement_key]
                  body_measurement_key.keys.each do |child_body_measurement_key|
                  grand_child_obj = body_measurement_key[child_body_measurement_key]
                  if  grand_child_obj.class.to_s == "Hash"
                      grand_child_obj.keys.each do |grand_child_key|
                        response_string += " <td>#{grand_child_key}: #{grand_child_obj[grand_child_key]} </td>"
                      end
                  else
                      response_string += "<td>  #{body_measurement_key[child_body_measurement_key]} </td>"
                  end
                response_string += "</tr>"
                end
              end
         end
         response_string.html_safe
      end

      def show_std_measurements(luxire_line_item)
        response_string = ""
        std_measurements = luxire_line_item.measurement_data["standard_measurement_attributes"]
        unless std_measurements.blank?
            response_string += "<br /> <br />  <p>  Your Standard measurement details</p>"
             std_measurements.keys.each do |std_measurement_key|
                  response_string += "<tr>  <td>  #{std_measurement_key}: </td>"
                  std_measurement_object = std_measurements[std_measurement_key]
                  std_measurement_object.keys.each do |child_std_measurement_key|
                  grand_child_obj = std_measurement_object[child_std_measurement_key]
                  if  grand_child_obj.class.to_s == "Hash"
                      grand_child_obj.keys.each do |grand_child_key|
                      response_string += "<td> #{grand_child_key}:#{grand_child_obj[grand_child_key]} </td>"
                     end
                  else
                    response_string += "<td>  #{std_measurement_object[child_std_measurement_key]} </td>"
                  end
                response_string += "</tr>"
                end
             end
          end
          response_string.html_safe
      end
    end
end
