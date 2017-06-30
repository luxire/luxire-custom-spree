module Spree
  module OrderMailerHelper
    def show_customized_data(luxire_line_item)
      response_string = ""
     # byebug
      customized_data = luxire_line_item.customized_data
      response_string += "<tr><td colspan=3> Your customization details </td></tr>"
      customized_data.keys.each do |customized_key|
            # byebug
            response_string +=  "<tr>  <td>   #{customized_key}: </td>"
            custom_object = customized_data[customized_key]
            custom_object.keys.each do |child_customized_key|
              grand_child_obj = custom_object[child_customized_key]
              # byebug
              if grand_child_obj.class.to_s == "Hash"
		               response_string += "<td>"
                   grand_child_obj.keys.each do |grand_child_key|
                     response_string += "#{grand_child_key}: #{grand_child_obj[grand_child_key]} <br />"
                   end
                  response_string += "</td>"
              else
                  response_string +=  "<td>  #{custom_object[child_customized_key]} </td>"
              end
            end
            (0...td_count(response_string)).each do
              response_string +="<td> &nbsp; </td>"
            end
           response_string += "</tr>"
        end
        #  erb = ERB.new(response_string)
        #  @output = erb.result(binding)
       #byebug
         response_string.html_safe
    end

    def show_personalize_data(luxire_line_item)
        response_string = ""
        personalize_data  = luxire_line_item.personalize_data
        order = luxire_line_item.line_item.order
        personalize_data.keys.each do |personalize_key|
            response_string +=  " <tr>  <td>  #{personalize_key}: </td>"
            if personalize_key == 'Monogram'
              personalize_obj = personalize_data[personalize_key]
              @res = ""
              print_nested_value(personalize_obj)
              @res = @res[0...@res.length-1]
              response_string +=  " <td>" + @res + " </td>"
              (0...td_count(response_string)).each do
                response_string +="<td> &nbsp; </td>"
              end
              response_string += "</tr>"
            else
              counter = personalize_data[personalize_key].keys.length
              personalize_data[personalize_key].keys.each do |personalization_attributes|
                response_string +=  " <td>" + personalization_attributes + " </td>"
                if personalization_attributes["cost"] && personalization_attributes["cost"][order.currency]
                  cost = Money.new(personalization_attributes["cost"][order.currency], currency: order.currency).to_html
                else
                  cost = Money.new(0, currency: order.currency).to_html
                end
                response_string +=  " <td>" + cost + " </td>"
                response_string += "</tr>"
                counter -= 1
                if counter > 0
                  response_string += "<tr> <td> &nbsp; </td>"
                end
              end
            end
        end
        response_string = "<tr><td colspan=3> Your Personalization details  </td></tr>" + response_string
        response_string.html_safe
    end


    def show_body_measurements(luxire_line_item)
      response_string = ""
      body_measurements = luxire_line_item.measurement_data["body_measurement_attributes"]
      body_measurements.keys.each do |body_measurement_key|
            response_string += "<tr>  <td>  #{body_measurement_key} </td>"
            body_measurement_obj = body_measurements[body_measurement_key]
            @res = ""
            print_nested_value(body_measurement_obj)
            @res = @res[0...@res.length-1]
            response_string +=  " <td>" + @res + " </td>"
            (0...td_count(response_string)).each do
               response_string +="<td> &nbsp; </td>"
             end
             response_string += "</tr>"
      end
      response_string =" <tr><td colspan=3>  Your Body Measurement details  </td></tr>" + response_string
      response_string.html_safe
    end

    def show_std_measurements(luxire_line_item)
      response_string = ""
      std_measurements = luxire_line_item.measurement_data["standard_measurement_attributes"]
      std_measurements.keys.each do |std_measurement_key|
            response_string += "<tr>  <td>  #{std_measurement_key}: </td>"
            std_measurement_object = std_measurements[std_measurement_key]
            @res = ""
            print_nested_value(std_measurement_object)
            @res = @res[0...@res.length-1]
            response_string +=  " <td>" + @res + " </td>"
            (0...td_count(response_string)).each do
              response_string +="<td> &nbsp; </td>"
            end
            response_string += "</tr>"
       end
        response_string = "<tr><td colspan=3>  Your Standard measurement details </td></tr>" + response_string
        response_string.html_safe
    end

    def print_nested_value(key)
      key.keys.each do |child_key|
        if key[child_key].class.to_s == "Hash"
          print_nested_value(key[child_key])
        else
          @res += "#{child_key}: #{key[child_key]} <br />"
        end
      end
    end

    def td_count(response_string)
      count = response_string.scan("<td>").count % 3
      if count == 0
        0
      else
        3 - count
      end
    end
  end
end
